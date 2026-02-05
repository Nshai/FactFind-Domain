SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomUpdateTotalPlanValuationType] 
	@PolicyBusinessId BIGINT,
	@NewRefPlanType2ProdSubTypeId BIGINT,
	@StampUser BIGINT,
	@StampDateTime DATETIME = NULL 
AS  

SET NOCOUNT ON
	
DECLARE @tx int
SELECT @tx = @@TRANCOUNT

IF @tx = 0 
BEGIN TRANSACTION TX

BEGIN
	SET @StampDateTime = ISNULL(@StampDateTime, GETDATE()) 
	
	DECLARE @NewIsWrapper BIT = 0, @NewPlanTypeWrap BIT = 0
				
	SELECT @NewIsWrapper = PType.IsWrapperFg
	FROM PolicyManagement..TRefPlanType2ProdSubType PType2Subtype
	JOIN PolicyManagement..TRefPlanType PType ON PType2Subtype.RefPlanTypeId = PType.RefPlanTypeId
	WHERE PType2Subtype.RefPlanType2ProdSubTypeId = @NewRefPlanType2ProdSubTypeId
	
	SELECT @NewPlanTypeWrap = 1
	FROM PolicyManagement..TRefPlanType2ProdSubType PType2Subtype
	JOIN PolicyManagement..TRefPlanType PType ON PType2Subtype.RefPlanTypeId = PType.RefPlanTypeId
	WHERE PType2Subtype.RefPlanType2ProdSubTypeId = @NewRefPlanType2ProdSubTypeId AND PlanTypeName = 'wrap'
	
	IF(@NewIsWrapper = 0)
	BEGIN
		DELETE TPV		
			-- Auditing -------------------------------------
			OUTPUT 
				DELETED.[TenantId]
				,DELETED.[RefTotalPlanValuationTypeId]
				,DELETED.[ConcurrencyId]
				,DELETED.[PolicyBusinessId]
				,DELETED.[PolicyBusinessTotalPlanValuationTypeId]
				,DELETED.[PlanMigrationRef]
				,'D'
				,@StampDateTime
				,@StampUser
			INTO [PolicyManagement]..[TPolicyBusinessTotalPlanValuationTypeAudit]
				([TenantId]
				,[RefTotalPlanValuationTypeId]
				,[ConcurrencyId]
				,[PolicyBusinessId]
				,[PolicyBusinessTotalPlanValuationTypeId]
				,[PlanMigrationRef]
				,[StampAction]
				,[StampDateTime]
				,[StampUser])
			-------------------------------------------------
    
		FROM PolicyManagement..TPolicyBusinessTotalPlanValuationType TPV
		WHERE PolicyBusinessId = @PolicyBusinessId		
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM PolicyManagement..TPolicyBusinessTotalPlanValuationType WHERE PolicyBusinessId = @PolicyBusinessId)
		BEGIN
			UPDATE TPV
			SET RefTotalPlanValuationTypeId = 
				CASE 
					WHEN @NewPlanTypeWrap = 1 THEN 1 -- TotalSubPlansIfHaveValueOrTotalMasterPlanValue
					ELSE 2 -- TotalMasterAndSubPlans
				END,
				ConcurrencyId = TPV.ConcurrencyId + 1
				
				    -- Auditing -------------------------------------
					OUTPUT 
						DELETED.[TenantId]
						,DELETED.[RefTotalPlanValuationTypeId]
						,DELETED.[ConcurrencyId]
						,DELETED.[PolicyBusinessId]
						,DELETED.[PolicyBusinessTotalPlanValuationTypeId]
						,DELETED.[PlanMigrationRef]
						,'U'
						,@StampDateTime
						,@StampUser
					INTO [PolicyManagement]..[TPolicyBusinessTotalPlanValuationTypeAudit]
						([TenantId]
						,[RefTotalPlanValuationTypeId]
						,[ConcurrencyId]
						,[PolicyBusinessId]
						,[PolicyBusinessTotalPlanValuationTypeId]
						,[PlanMigrationRef]
						,[StampAction]
						,[StampDateTime]
						,[StampUser])
					-------------------------------------------------
    				
			FROM PolicyManagement..TPolicyBusinessTotalPlanValuationType TPV
			WHERE PolicyBusinessId = @PolicyBusinessId
		END
		ELSE
		BEGIN
			INSERT INTO [PolicyManagement]..[TPolicyBusinessTotalPlanValuationType]
			(
				[PolicyBusinessId]
				,[TenantId]
				,[RefTotalPlanValuationTypeId]
			)
				
				-- Auditing -------------------------------------
				OUTPUT 
					INSERTED.[TenantId]
					,INSERTED.[RefTotalPlanValuationTypeId]
					,INSERTED.[ConcurrencyId]
					,INSERTED.[PolicyBusinessId]
					,INSERTED.[PolicyBusinessTotalPlanValuationTypeId]
					,INSERTED.[PlanMigrationRef]
					,'C'
					,@StampDateTime
					,@StampUser
				INTO [PolicyManagement]..[TPolicyBusinessTotalPlanValuationTypeAudit]
					([TenantId]
					,[RefTotalPlanValuationTypeId]
					,[ConcurrencyId]
					,[PolicyBusinessId]
					,[PolicyBusinessTotalPlanValuationTypeId]
					,[PlanMigrationRef]
					,[StampAction]
					,[StampDateTime]
					,[StampUser])
				-------------------------------------------------
    
			SELECT 
				PolicyBusinessId,
				IndigoClientId,
				CASE 
					WHEN @NewPlanTypeWrap = 1 THEN 1 -- TotalSubPlansIfHaveValueOrTotalMasterPlanValue
					ELSE 2 -- TotalMasterAndSubPlans
				END
			FROM PolicyManagement..TPolicyBusiness
			WHERE PolicyBusinessId = @PolicyBusinessId
		END
	END
		
	IF @@ERROR != 0 
		GOTO ERR
			
	IF @tx = 0 
		COMMIT TRANSACTION TX	
END
RETURN (0)
	
ERR:
  IF @tx = 0 
	ROLLBACK TRANSACTION TX
  RETURN (100)
  
GO

