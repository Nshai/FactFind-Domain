SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateGeneralInsurancePlan]       
	@StampUser varchar(255),  
	@CRMContactId bigint,      
	@Owner varchar(255),      
	@SellingAdviser bigint,      
	@RefPlanType2ProdSubTypeId bigint,    
	@RefProdProviderId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@StartDate datetime=null,    
	@RenewalDate datetime = null,      
	@RegularPremium money=null,      
	@PremiumFrequency varchar(50),      
	@BuildingsSumInsured money = null,
	@BuildingsAccidentalDamage bit = null,
	@BuildingsExcess money = null,
	@ContentsSumInsured money = null,
	@ContentsAccidentalDamage bit = null,
	@ContentsExcess money = null,
	@PremiumLoading money = null,
	@Exclusions varchar(255) = null,
	@PropertyInsuranceType varchar(50) =null,
	@ProductName varchar(200) = null,
	@SplitTemplateGroupId int = null,  
	@TemplateGroupType varchar(255) = null,
	@PlanCurrency varchar(3) = null,
	@AgencyStatus varchar(50) null = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS
-------------------------------------------------------------------------------            
-- Declarations    
-------------------------------------------------------------------------------            
DECLARE @TenantId bigint, @PolicyBusinessId bigint, @ProtectionId bigint,
	@Discriminator bigint, @GenInsId bigint, @CRMContactId2 bigint

-------------------------------------------------------------------------------            
-- Get tenantId and Joint FF details.
-------------------------------------------------------------------------------      
SELECT @TenantId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId
SELECT @CRMContactId2 = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId      

-------------------------------------------------------------------------------            
-- Create the basic plan data, this will return a PolicyBusinessId      
-------------------------------------------------------------------------------      
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, NULL, NULL, 
	NULL, @Owner, @RegularPremium, @PremiumFrequency, NULL, @TenantId, @ProductName, @StampUser, 
	@StartDate, @SellingAdviser, @PolicyBusinessId OUTPUT, @RefPlanType2ProdSubTypeId, @RefProdProviderId,
	@PlanCurrency=@PlanCurrency, @AgencyStatus = @AgencyStatus

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
-------------------------------------------------------------------------------            
-- Discriminator used by NIO.
-------------------------------------------------------------------------------                
SET @Discriminator = 47 -- GI protection plans
				
-------------------------------------------------------------------------------      
-- Create a TProtection record 
-------------------------------------------------------------------------------
INSERT INTO PolicyManagement..TProtection (
	IndigoClientId, PolicyBusinessId, RefPlanSubCategoryId, PremiumLoading, Exclusions, RenewalDate,PropertyInsuranceType)       
VALUES (@TenantId, @PolicyBusinessId, @Discriminator, @PremiumLoading, @Exclusions, @RenewalDate,@PropertyInsuranceType)	
      
SET @ProtectionId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'C'
            
-------------------------------------------------------------------------------      
-- General Insurance (Buildings)
-------------------------------------------------------------------------------
IF @RefPlanType2ProdSubTypeId IN (98, 1058, 99, 1191, 1192) BEGIN 
	INSERT INTO PolicyManagement..TGeneralInsuranceDetail (
		ProtectionId, RefInsuranceCoverCategoryId, SumAssured, AdditionalCoverAmount, Owner2PercentageOfSumAssured, ExcessAmount,
		InsuranceCoverOptions, RefInsuranceCoverAreaId, RefInsuranceCoverTypeId, IsCoverNoteIssued)
	VALUES (@ProtectionId, 1, @BuildingsSumInsured, 0, 0, @BuildingsExcess, CAST(@BuildingsAccidentalDamage AS int), 0, 1, 0)

	SET @GenInsId  = SCOPE_IDENTITY()	
	EXEC PolicyManagement..SpNAuditGeneralInsuranceDetail @StampUser, @GenInsId, 'C'
END

-------------------------------------------------------------------------------      
-- General Insurance (Contents)
-------------------------------------------------------------------------------
IF @RefPlanType2ProdSubTypeId IN (98, 1058, 100, 1192, 1194) BEGIN 
	INSERT INTO PolicyManagement..TGeneralInsuranceDetail (
		ProtectionId, RefInsuranceCoverCategoryId, SumAssured, AdditionalCoverAmount, Owner2PercentageOfSumAssured, ExcessAmount,
		InsuranceCoverOptions, RefInsuranceCoverAreaId, RefInsuranceCoverTypeId, IsCoverNoteIssued)
	VALUES (@ProtectionId, 2, @ContentsSumInsured, 0, 0, @ContentsExcess, CAST(@ContentsAccidentalDamage AS int), 0, 1, 0)

	SET @GenInsId  = SCOPE_IDENTITY()	
	EXEC PolicyManagement..SpNAuditGeneralInsuranceDetail @StampUser, @GenInsId, 'C'
END

IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC SpNCreateSplitTemplatesForPlans @TenantId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END

-- return Id for FF.
SELECT @PolicyBusinessId AS GeneralInsurancePlanId
GO

