SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Create date: 14 September 2012
-- Description:	This sp will be called the UI to calculate the expectation amount
-- for ongoing fee
-- with % based fee charging type
-- on status change to "Due"
-- =============================================
CREATE PROCEDURE [dbo].[SpCalculateExpectationAmt]	
	 @feeId BIGINT,
	 @tenantClientId BIGINT,
	 @CurrentUserDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION TX

	DECLARE @MaxId BIGINT,
			@StampUser VARCHAR (255),		
			@policyBusinessId BIGINT,
			@feePercentage DECIMAL(18,2),
			@discountAmount DECIMAL(18,2),
			@discountPercentage DECIMAL(18,2),
			@vatPercentage DECIMAL(18,2),
			@maxFee DECIMAL(18,2),
			@minFee DECIMAL(18,2),
			@vatExempt BIT,
			@tenantId BIGINT,
			@RecurrenceId BIGINT,
			@chargingType varchar(50),
			@feePercentageOutput DECIMAL(18,2), 
			@RefContributionTypeId BIGINT
			
	SET @StampUser='999999'				 
	
	BEGIN
										 
	--Declare the FEE PLAN Table variable 
	DECLARE @EligibleFeePlanRecords TABLE
	(	
		Number INT IDENTITY(1,1) --Auto incrementing Identity column
		,FeeId BIGINT
		,PolicyBusinessId BIGINT,
		 FeeType VARCHAR(500),
		 FeeTypeId BIGINT,
		 FeePercentage DECIMAL(18,2),
		 Feemax DECIMAL(18,2),
		 FeeMin DECIMAL(18,2),
		 discountAmount DECIMAL(18,2),
		 discountPercentage DECIMAL(18,2),
		 Vatpercentage DECIMAL(18,2),
		 vatexempt BIT, 
		 TenantId BIGINT
	)
	--Declare a variable to remember the position of the current delimiter
	DECLARE @N INT 

	--Declare a variable to remember the number of rows in the table
	DECLARE @Count INT
	
	--Populate Plan linked fees details	
	INSERT INTO @EligibleFeePlanRecords 
		SELECT 
			Fee.FeeId, 
			FP.PolicyBusinessId,	
			RFCT.Name AS FeeType,
			RFCT.RefAdviseFeeChargingTypeId AS FeeTypeId,
			ISNULL(Fee.FeePercentage,FCD.PercentageOfFee) AS FeePercentage,
			FCD.MaximumFee AS Feemax,
			FCD.MinimumFee AS FeeMin,
			ISNULL(Fee.DiscountAmount, 0) AS discountAmount,
			ISNULL(Fee.DiscountPercentage, 0) AS discountPercentage,
			RV.VATRate AS Vatpercentage,
			Fee.VATExempt AS vatexempt,	
			IC.IndigoClientId AS TenantId
		FROM TFee Fee			
			LEFT JOIN TRefVAT RV on Fee.RefVATId = RV.RefVATId
			INNER JOIN TAdviseFeeChargingDetails FCD on FCD.AdviseFeeChargingDetailsId = Fee.AdviseFeeChargingDetailsId
			INNER JOIN TAdviseFeeChargingType FCT on FCT.AdviseFeeChargingTypeId = FCD.AdviseFeeChargingTypeId
			INNER JOIN TRefAdviseFeeChargingType RFCT on FCT.RefAdviseFeeChargingTypeId = RFCT.RefAdviseFeeChargingTypeId			
			INNER JOIN administration..TIndigoClient IC on IC.IndigoClientId = Fee.IndigoClientId
			INNER JOIN TFee2Policy FP on  Fee.FeeId = FP.FeeId
			LEFT JOIN TPolicyBusiness PB on PB.PolicyBusinessId = FP.PolicyBusinessId	
		WHERE Fee.FeeId = @feeId and Fee.IndigoClientId = @tenantClientId
		
	--Initialize the loop variable
	SET @N = 1

	--Determine the number of rows in the Table
	SELECT @Count=max(Number) from @EligibleFeePlanRecords
	print @Count
	--Loop through until all row processing is done
	WHILE @N <= @Count
	BEGIN	
		SELECT	@policyBusinessId = PolicyBusinessId,
				@discountAmount = discountAmount,
				@discountPercentage = discountPercentage,
				@feePercentage = FeePercentage, 
				@maxFee = Feemax,
				@minFee = FeeMin,
				@vatPercentage = Vatpercentage,
				@vatExempt = vatexempt,		
				@tenantId = TenantId,
				@chargingType = FeeType
		FROM	@EligibleFeePlanRecords 
		WHERE	Number = @N	
		
		
		
		-- Calculate the Fee Percentage based on the frequency.		
		print 'percentage'
		print @feePercentage
		
		--EXECUTE dbo.SpCalculateFeePercentage  @feeId,@feePercentage,@tenantId, @feePercentageOutput OUTPUT
		--print @feePercentageOutput

		
		if (@chargingType = '% of FUM/AUM')
			begin 	
					
					PRINT 	@policyBusinessId			
			PRINT 	@feeId		
			PRINT 	@feePercentage			
			PRINT 	@discountAmount
			PRINT 	@discountPercentage
			PRINT 	@vatPercentage
			PRINT 	@maxFee
			PRINT 	@minFee
			PRINT 	@vatExempt
			PRINT 	@tenantId
			PRINT 	@CurrentUserDate
			--print cast(sql_variant_property(feePercentage,'BaseType') as varchar(20))
			EXECUTE  dbo.spCalculateRecurringInvestmentFee @policyBusinessId,@feeId, @feePercentage,@discountAmount,
											 @discountPercentage,@vatPercentage,@maxFee,@minFee,@vatExempt,@tenantId,@CurrentUserDate
			end
			
			IF (@chargingType = '% of All Investment Contribution')
			BEGIN 	
				EXECUTE  dbo.SpCalculateRecurringContributionFee @policyBusinessId,@feeId,@feePercentage,
													  @discountPercentage,@vatPercentage,@vatExempt,@tenantId,@CurrentUserDate = @CurrentUserDate
			END	
			
			ELSE IF (@chargingType = '% of Regular Contribution')
			BEGIN 	
				
				SET @RefContributionTypeId = (SELECT RefContributionTypeId from TRefContributionType where RefContributionTypeName ='Regular')
				EXECUTE  dbo.SpCalculateRecurringContributionFee @policyBusinessId,@feeId,@feePercentage,
													  @discountPercentage,@vatPercentage,@vatExempt,@tenantId,@RefContributionTypeId,@CurrentUserDate
			END
			
			ELSE IF (@chargingType = '% of Lump Sum Contribution')
			BEGIN 	
				SET @RefContributionTypeId = (SELECT RefContributionTypeId from TRefContributionType where RefContributionTypeName ='Lump Sum')	 				
				EXECUTE  dbo.SpCalculateRecurringContributionFee @policyBusinessId,@feeId,@feePercentage,
													  @discountPercentage,@vatPercentage,@vatExempt,@tenantId,@RefContributionTypeId,@CurrentUserDate
			END
			
			ELSE IF (@chargingType = '% of Transfer Contribution')
			BEGIN 	
				SET @RefContributionTypeId = (SELECT RefContributionTypeId from TRefContributionType where RefContributionTypeName ='Transfer')		 				
				EXECUTE  dbo.SpCalculateRecurringContributionFee @policyBusinessId,@feeId,@feePercentage,
													  @discountPercentage,@vatPercentage,@vatExempt,@tenantId,@RefContributionTypeId,@CurrentUserDate
			END
			
	--Increment loop counter
    SET @N = @N + 1;
	
	END
	
	END
	IF @@ERROR != 0 GOTO errh

	IF(@@TRANCOUNT>0)
	BEGIN 		
		COMMIT TRANSACTION TX		
	END
	RETURN (0)

	errh:
	  IF(@@TRANCOUNT>0) ROLLBACK TRANSACTION TX
	  RETURN (100)
END
GO
