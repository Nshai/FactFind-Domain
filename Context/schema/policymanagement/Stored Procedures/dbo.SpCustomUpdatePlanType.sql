SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
 This procedure will update an existing plan types portfolio category and discriminator.

 PARAMS:
 @PlanTypeName			> Required: The plan type name to update
 @ProdSubTypeName		> Optional: The product sub type name.
 @PortfolioCategoryName > Required: The portfolio category name to update plan type to
 @PlanDiscriminatorName > Required: The discriminator name to update plan type to
*/
CREATE PROCEDURE SpCustomUpdatePlanType
	@PlanTypeName VARCHAR(50), 
	@ProdSubTypeName VARCHAR(50) = NULL,
	@PortfolioCategoryName VARCHAR(50),
	@PlanDiscriminatorName VARCHAR(50),
	@RegionCode varchar(2) = 'GB'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RefPlanTypeId INT,
			@ProdSubTypeId INT = NULL,
			@RefPortfolioCategoryId INT,
			@RefPlanDiscriminatorId INT,
			@RefPlanType2ProdSubTypeId INT,
			@StampAction CHAR(1) = 'U',
			@StampUser VARCHAR(255) = '0',
			@AuditResult INT

	-- Fetch PlanTypeId for plan type
	SET @RefPlanTypeId = (SELECT top 1 rpt.RefPlanTypeId FROM TRefPlanType rpt 
							INNER JOIN TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanTypeId = rpt.RefPlanTypeId
							WHERE rpt.PlanTypeName = @PlanTypeName AND rpt2pst.RegionCode = @RegionCode)

	IF (@RefPlanTypeId IS NULL) BEGIN 
		PRINT CONCAT('Plan type ',@PlanTypeName,' does not exist. Update failed')
		RETURN
	END
	-- Fetch ProdSubTypeId for product sub type
	SELECT @ProdSubTypeId = ProdSubTypeId FROM TProdSubType WHERE ProdSubTypeName = @ProdSubTypeName AND @ProdSubTypeName IS NOT NULL
	IF (@ProdSubTypeName IS NOT NULL AND @ProdSubTypeId IS NULL) BEGIN 
		PRINT CONCAT('Product sub type ',@ProdSubTypeName,' does not exist. Update failed')
		RETURN
	END
	-- Fetch PortfolioCategoryId for portfolio category
	SELECT @RefPortfolioCategoryId = RefPortfolioCategoryId FROM TRefPortfolioCategory WHERE PortfolioCategoryName = @PortfolioCategoryName
	IF (@RefPortfolioCategoryId IS NULL) BEGIN 
		PRINT CONCAT('Portfolio category ',@PortfolioCategoryName,' does not exist. Update failed')
		RETURN
	END
	-- Fetch PlanDiscriminatorId for plan discriminator
	SELECT @RefPlanDiscriminatorId = RefPlanDiscriminatorId FROM TRefPlanDiscriminator WHERE PlanDiscriminatorName = @PlanDiscriminatorName
	IF (@RefPlanDiscriminatorId IS NULL) BEGIN 
		PRINT CONCAT('Plan discriminator ',@PlanDiscriminatorName,' does not exist. Update failed')
		RETURN
	END

	-- Fetch the Id for row we want to update in TRefPlanType2ProdSubType
	SELECT @RefPlanType2ProdSubTypeId = RefPlanType2ProdSubTypeId 
	FROM   TRefPlanType2ProdSubType 
	WHERE  RefPlanTypeId = @RefPlanTypeId 
	AND	  (@ProdSubTypeId IS NULL OR ProdSubTypeId IN (SELECT ProdSubTypeId FROM TProdSubType WHERE ProdSubTypeName = @ProdSubTypeName))
	--NB. Using subquery here bc of duplicates in TProdSubType table!

	IF (@RefPlanType2ProdSubTypeId IS NULL) BEGIN 
		PRINT 'Failed to find row in table TRefPlanType2ProdSubType to update'
		RETURN
	END

	-- Add row to audit table
	EXEC @AuditResult = SpNAuditRefPlanType2ProdSubType @StampUser, @RefPlanType2ProdSubTypeId, @StampAction
	IF (@AuditResult != 0) BEGIN
		PRINT 'Failed to insert audit record into table TRefPlanType2ProdSubTypeAudit'
		RETURN
	END

	-- Update the portfolio category discriminator
	UPDATE	TRefPlanType2ProdSubType 
	SET		RefPortfolioCategoryId = @RefPortfolioCategoryId, 
			RefPlanDiscriminatorId = @RefPlanDiscriminatorId,
			ConcurrencyId = ConcurrencyId + 1
	WHERE	RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId

	IF (@@ROWCOUNT != 1) BEGIN
		RAISERROR('Failed to update table TRefPlanType2ProdSubType',16,1)
	END

	-- Success
	IF (@ProdSubTypeName IS NULL) BEGIN
		PRINT CONCAT('Successfully updated plan type ',@PlanTypeName,' with portfolio category ',@PortfolioCategoryName,' and discriminator ',@PlanDiscriminatorName)
	END ELSE BEGIN
		PRINT CONCAT('Successfully updated plan type ',@PlanTypeName, ' (',@ProdSubTypeName,') with portfolio category ',@PortfolioCategoryName,' and discriminator ',@PlanDiscriminatorName)
	END
END
GO
