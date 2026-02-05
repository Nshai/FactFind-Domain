SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateGeneralInsurancePlan]       
	@StampUser varchar(255),  
	@GeneralInsurancePlanId bigint,		-- PolicyBusinessId
	@CRMContactId bigint,      
	@Owner varchar(255),				-- Not used.
	@SellingAdviser bigint = null,      -- Not used.
	@RefPlanType2ProdSubTypeId bigint,    
	@StartDate datetime = null,
	@RenewalDate datetime = null,       
	@RegularPremium money = null,		-- Not used. 
	@PremiumFrequency varchar(50)  = null,  -- Not used.
	@BuildingsSumInsured money = null,
	@BuildingsAccidentalDamage bit = null,
	@BuildingsExcess money = null,
	@ContentsSumInsured money = null,
	@ContentsAccidentalDamage bit = null,
	@ContentsExcess money = null,
	@PremiumLoading money = null,
	@Exclusions varchar(255) = null,
	@ConcurrencyId int = null, -- Not used.	
	@ProductName varchar(200) = null,
 	@PlanCurrency varchar(3),
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
DECLARE @ProtectionId bigint, @Discriminator bigint, @BuildingsId bigint, @ContentsId bigint,
	@PolicyBusinessId bigint = @GeneralInsurancePlanId, @PolicyBusinessExtId bigint

-------------------------------------------------------------------------------            
-- Discriminator used by NIO.
-------------------------------------------------------------------------------                
SET @Discriminator = 47 -- GI protection plans
				
-------------------------------------------------------------------------------      
-- Update TProtection record 
-------------------------------------------------------------------------------
SELECT @ProtectionId = ProtectionId FROM PolicyManagement..TProtection WHERE PolicyBusinessId = @GeneralInsurancePlanId

IF EXISTS (SELECT 1 FROM PolicyManagement..TProtection WHERE ProtectionId = @ProtectionId 
		AND (ISNULL(PremiumLoading, -1) != ISNULL(@PremiumLoading, -1)
			OR ISNULL(Exclusions, '') != ISNULL(@Exclusions, '')
			OR ISNULL(RenewalDate, '31-Dec-1899') != ISNULL(@RenewalDate, '31-Dec-1899')))			
BEGIN			
	EXEC PolicyManagement..SpNAuditProtection @StampUser, @ProtectionId, 'U'
	UPDATE PolicyManagement..TProtection
	SET
		PremiumLoading = @PremiumLoading,
		Exclusions = @Exclusions,
		RenewalDate = @RenewalDate,
		ConcurrencyId = ConcurrencyId + 1		
	WHERE
		ProtectionId = @ProtectionId 
END

--------------------------------------------------------------
-- Update Pension Info
--------------------------------------------------------------
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
	        
-------------------------------------------------------------------------------      
-- General Insurance (Buildings)
-------------------------------------------------------------------------------
IF @RefPlanType2ProdSubTypeId IN (98, 1058, 99) BEGIN 
	-- Find GI line for buildings
	SELECT @BuildingsId = GeneralInsuranceDetailId 
	FROM PolicyManagement..TGeneralInsuranceDetail
	WHERE ProtectionId = @ProtectionId AND RefInsuranceCoverCategoryId = 1
	-- Update
	EXEC SpNCustomUpdateGeneralInsuranceDetail @StampUser, @BuildingsId, 	
		@BuildingsSumInsured, @BuildingsAccidentalDamage, @BuildingsExcess
END

-------------------------------------------------------------------------------      
-- General Insurance (Contents)
-------------------------------------------------------------------------------
IF @RefPlanType2ProdSubTypeId IN (98, 1058, 100) BEGIN 	
	-- Find GI line for contents
	SELECT @ContentsId = GeneralInsuranceDetailId 
	FROM PolicyManagement..TGeneralInsuranceDetail
	WHERE ProtectionId = @ProtectionId AND RefInsuranceCoverCategoryId = 2
	-- Update
	EXEC SpNCustomUpdateGeneralInsuranceDetail @StampUser, @ContentsId, 	
		@ContentsSumInsured, @ContentsAccidentalDamage, @ContentsExcess
END

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

EXEC PolicyManagement..SpNAuditPolicyBusiness @StampUser, @GeneralInsurancePlanId, 'U'      
    
UPDATE PolicyManagement..TPolicyBusiness         
SET   
 ProductName = @ProductName, 
 BaseCurrency = @PlanCurrency,
 PolicyStartDate = @StartDate
WHERE     
 PolicyBusinessId = @GeneralInsurancePlanId  
GO
