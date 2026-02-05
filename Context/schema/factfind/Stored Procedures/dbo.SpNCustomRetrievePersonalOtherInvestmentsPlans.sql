SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalOtherInvestmentsPlans]   
(  
  @IndigoClientId bigint,
  @UserId bigint, 
  @FactFindId bigint, 
  @ParentPolicyBusinessId bigint = null,  
  @ExcludePlanPurposes BIT = 0,
  @CurrentUserDate datetime
)  
As  

Begin
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE     
 @CRMContactId bigint, @CRMContactId2 bigint, @AdviserId bigint, @AdviserCRMId bigint, @AdviserName varchar(255),    
 @PreExistingAdviserId bigint, @PreExistingAdviserName varchar(255), @PreExistingAdviserCRMId bigint,                      
 @NewId bigint, @IncludeTopups bit, @TenantId bigint,    
 @AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint, @PolicyBusinessId Bigint,@IsInvestmentPlan bigint = 1, @RegularContribution varchar(50) = 'Regular',
 @LumpSumContribution varchar(50) = 'Lump Sum', @SelfContributor varchar(50) = 'Self' 

    
---------------------------------------------------------------------------------    
-- Get some initial settings    
---------------------------------------------------------------------------------    
 Exec dbo.SpNCustomRetrievePersonalDataInitialSettings @IndigoClientId, @UserId, @FactFindId, @ExcludePlanPurposes,@CRMContactId OutPut,   
				@CRMContactId2 OutPut, @AdviserId OutPut, @AdviserCRMId OutPut, @AdviserName OutPut,    
				@PreExistingAdviserId OutPut, @PreExistingAdviserName OutPut, @PreExistingAdviserCRMId OutPut,                      
				@NewId OutPut, @IncludeTopups OutPut, @TenantId OutPut,    
				@AdviserUserId OutPut, @AdviserGroupId OutPut, @IncomeReplacementRate OutPut, @UserIncomeReplacementRate OutPut  

DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)  
INSERT INTO @PlanList  
SELECT DISTINCT PB.PolicyBusinessId, PB.PolicyDetailId  
FROM                            
	 PolicyManagement..TPolicyOwner PO WITH(NOLOCK)                            
	 JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId  
WHERE                            
	CRMContactId IN (@CRMContactId, @CRMContactId2)  

   
-- Basic Plan Details     
DECLARE @PlanDescription TABLE                                  
(                                  
 PolicyBusinessId bigint not null PRIMARY KEY,                                  
 PolicyDetailId bigint not null,                                  
 CRMContactId bigint not null,                                  
 CRMContactId2 bigint null,                                  
 [Owner] varchar(16) not null,                                  
 OwnerCount int not null,        
 RefPlanType2ProdSubTypeId bigint not NULL,     
 PlanType varchar(128) not null,               
 UnderlyingPlanType varchar(128) not null,                      
 RefProdProviderId bigint not null,    
 Provider varchar(128) not null,                                  
 PolicyNumber varchar(64) null,                                  
 AgencyStatus varchar(50) null,
 StartDate datetime null,                                  
 MaturityDate datetime null,                                  
 StatusDate datetime null,                                  
 Term tinyint null,                                      
 RegularPremium money null,                                  
 ActualRegularPremium money null,                                  
 TotalLumpSum money null,                                  
 TotalPremium money null,                                  
 Frequency varchar(32) null,                                  
 Valuation money null,                                  
 CurrentValue money null,                                  
 ValuationDate datetime,                                  
 ProductName varchar(255) null,                                  
 RefPlanTypeId bigint,                                  
 SellingAdviserId bigint,                                  
 SellingAdviserName varchar(255),                                  
 PlanPurpose varchar(255),     
 PlanPurposeId bigint null,        
 ParentPolicyBusinessId bigint,    
 ExcludeValuation bit,      
 ConcurrencyId bigint null,    
 PlanStatus varchar(50) null,                              
 MortgageRepayPercentage money null,     
 MortgageRepayAmount money null,    
 [IsGuaranteedToProtectOriginalInvestment] bit null,  
 LowMaturityValue money null,  
 MediumMaturityValue money null,  
 HighMaturityValue money null,
 ProjectionDetails varchar(5000) null,
 InterestRate money null,
 PlanCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
 )

-- Basic Plan Details      
Insert into @PlanDescription 
Select * from dbo.FnCustomGetPlanDescriptionForOtherInvestments(@CRMContactId, @CRMContactId2, @TenantId, @ExcludePlanPurposes, @IncludeTopups)   

DECLARE @PlanDesc TABLE                                
( 
 OtherInvestmentsPlansId int not null, 
 PolicyBusinessId int not null PRIMARY KEY, 
 CRMContactId int not null, 
 CRMContactId2 int null, 
 [Owner] varchar(16) not null, 
 SellingAdviserId int, 
 SellingAdviserName varchar(255),
 RefProdProviderId bigint not null,
 Provider varchar(255), 
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 PlanType varchar(255) null, 
 RefPlanType2ProdSubTypeId int,
 PlanPurposeText varchar(255) null, 
 ContributionThisTaxYearFg bit, 
 RegularContribution money null,
 Frequency varchar(255) null, 
 CurrentValue money null,
 ValuationDate datetime null,
 OtherInvStartDate datetime null,
 MaturityDate datetime null, 
 MonthlyIncome money null, 
 InTrustFg bit null,
 ExcludeValuation bit null,
 ConcurrencyId int null, 
 PlanStatus varchar(255) null,
 MortgageRepayPercentage money null,
 MortgageRepayAmount money null,
 IsGuaranteedToProtectOriginalInvestment bit null,
 PlanPurposeId int null, 
 LowMaturityValue money null,  
 MediumMaturityValue money null,
 HighMaturityValue money null,
 ProjectionDetails varchar(5000) null,
 ToWhom varchar(255) null,
 ActualRegularContribution money null,
 TotalSingleContribution money null, 
 RegularContributionsFrequency varchar(255) null,
 IsWrapperFg bit null,
 ProductName varchar(255) null,
 LumpsumContributionAmount money null,
 InterestRate money null,
 PlanCurrency varchar(3) null,
 ParentPlanType varchar(128) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
 )


-- Get a list of plan ids for these clients  
-- Update WRAPs so their valuation's are excluded if they have child plans    
UPDATE A    
SET    
 ExcludeValuation = 1     
FROM    
 -- The A's are the WRAPs    
 @PlanDescription A    
 -- The B's are child plans who's parent also appears in our list.    
 JOIN @PlanDescription B ON B.ParentPolicyBusinessId = A.PolicyBusinessId    
WHERE    
 A.UnderlyingPlanType = 'WRAP'    
 AND B.CurrentValue != 0 -- Child plan must have a value.    
 

-- Contributions
DECLARE @Contributions TABLE (PolicyBusinessId bigint, TypeId int, ContributorTypeId int, Amount money, 
	RefFrequencyId int, FrequencyName varchar(50), StartDate datetime, StopDate datetime, FirstId bigint)
-- Lump Sum amounts.
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, FrequencyName, FirstId) 
SELECT PolicyBusinessId, RefContributionTypeId, RefContributorTypeId, SUM(Amount), 'Single', MIN(PolicyMoneyInId) AS FirstId
FROM PolicyManagement..TPolicyMoneyIn 
WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND StartDate < @CurrentUserDate AND RefContributionTypeId != 1
GROUP BY PolicyBusinessId, RefContributionTypeId, RefContributorTypeId


-- other investments                                  
INSERT INTO @PlanDesc
SELECT DISTINCT                                   
	Pd.PolicyBusinessId AS OtherInvestmentsPlansId,
	Pd.PolicyBusinessId,
	pd.CRMContactId,
	pd.CRMContactId2,
	pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	pd.RefProdProviderId,  
	pd.Provider,
	pd.PolicyNumber,
	pd.AgencyStatus,
	pd.PlanType,
	Pd.RefPlanType2ProdSubTypeId,

	CASE 
		@ExcludePlanPurposes WHEN 1 THEN ''    
		ELSE ISNULL(Pd.PlanPurpose,'') 
	END AS PlanPurposeText,
	T.ContributionThisTaxYearFg,
	Pd.RegularPremium as RegularContribution,
			 
	CASE                             
		WHEN isnull(Pd.ActualRegularPremium,0) > 0 then Pd.Frequency    
		WHEN isnull(Pd.TotalLumpSum,0) > 0 then 'Single'                            
		ELSE Pd.Frequency    
	END AS Frequency,

	pd.CurrentValue,                            
	pd.ValuationDate,                            
	pd.StartDate as OtherInvStartDate,         
	pd.MaturityDate,
	T.MonthlyIncome,                           
	P.InTrust AS InTrustFg,
	pd.ExcludeValuation,
	pd.ConcurrencyId,
	pd.PlanStatus,
	pd.MortgageRepayPercentage,
	pd.MortgageRepayAmount,
	pd.[IsGuaranteedToProtectOriginalInvestment],

	CASE 
		@ExcludePlanPurposes WHEN 1 THEN null
		ELSE pd.PlanPurposeId 
	END As PlanPurposeId,

	pd.LowMaturityValue,  
	pd.MediumMaturityValue,  
	pd.HighMaturityValue, pd.ProjectionDetails, 
	P.ToWhom, 

	-- Calculating TotalRegularPremium depending on FactFind Setting is on  or off
	CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, pd.PolicyBusinessId,@SelfContributor,@RegularContribution,pd.Frequency,@IsInvestmentPlan,@CurrentUserDate) 
			                    else Pd.ActualRegularPremium 
								end AS ActualRegularContribution,
	-- Calculating LumpsumContributionAmount depending on FactFind Setting is on  or off
	CASE When @IncludeTopups = 0 Then policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, pd.PolicyBusinessId,null,@LumpSumContribution,pd.Frequency,@IsInvestmentPlan,@CurrentUserDate)
			                    else Pd.TotalLumpSum 
								end AS TotalSingleContribution,
	Pd.Frequency AS RegularContributionsFrequency,
	RPT.IsWrapperFg AS IsWrapperPlan,
	Pd.ProductName,
	LumpSum.Amount as LumpsumContributionAmount,
	pd.InterestRate,
	pd.PlanCurrency,
	PPD.PlanType,
	pd.SequentialRef,
	pd.IsProviderManaged
FROM     
	@PlanDescription pd                                  
	JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId    
	JOIN policymanagement..TRefPlanType2ProdSubType PTPS ON pd.RefPlanType2ProdSubTypeId = PTPS.RefPlanType2ProdSubTypeId 
	JOIN policymanagement..TRefPlanType RPT ON RPT.RefPlanTypeId = PTPS.RefPlanTypeId   
	LEFT JOIN TOtherInvestmentsPlanFFExt t ON t.PolicyBusinessId = pd.PolicyBusinessId                                  
	LEFT JOIN @PlanDescription PPD ON PPD.PolicyBusinessId = pd.ParentPolicyBusinessId
	LEFT JOIN Policymanagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = pd.PolicyBusinessId    
	-- Lump Sum Contributions
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId
WHERE     
	PTS.Section = 'Other Investments' 

---holding table to identify plans where IsWrapperFg = 0/1 and WrapPlan = 0/x - where 'x' is the wrapl its linked to 
DECLARE @PlanGrouping TABLE (PolicyBusinessId int, IsWrapperPlan bit, WrapPlan int, TopupMasterPolicyBusinessId int Default(0))

--Identify IsWrapper Plan
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 1, WrapPlan = 0
FROM  
	@PlanDesc PD 
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = PD.PolicyBusinessId   
WHERE 
	PD.IsWrapperFg = 1
	AND wrapper.PolicyBusinessId IS NULL

--Identify NON-IsWrapper Plan
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 0, WrapPlan = 0
FROM
	@PlanDesc PD
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = PD.PolicyBusinessId		
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = PD.PolicyBusinessId                                
	LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = wrapper1.ParentPolicyBusinessId
	LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId

WHERE 
	(wrapper1.PolicyBusinessId IS NULL OR TS.IntelligentOfficeStatusType = 'Deleted' AND TSH.CurrentStatusFG = 1) 
	AND wrapper2.ParentPolicyBusinessId IS NULL
	AND PD.IsWrapperFg = 0

--Identify wrap sub plan types
INSERT INTO @PlanGrouping (PolicyBusinessId, IsWrapperPlan, WrapPlan)
SELECT 
	PD.PolicyBusinessId, IsWrapperPlan = 0, WrapPlan = ISNULL(Wrapper1.ParentPolicyBusinessId, 0) 
FROM
	@PlanDesc PD
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = PD.PolicyBusinessId    
	LEFT JOIN policymanagement..TStatusHistory TSH ON TSH.PolicyBusinessId = wrapper1.ParentPolicyBusinessId
	LEFT JOIN policymanagement..TStatus TS ON TS.StatusId = TSH.StatusId
	LEFT JOIN (
		SELECT 
			PRPT.PlanTypeName, PPB.PolicyBusinessId 
		FROM 
			policymanagement..TPolicyBusiness PPB 
			INNER JOIN policymanagement..TPolicyDetail PPD ON PPD.PolicyDetailId = PPB.PolicyDetailId
			INNER JOIN policymanagement..TPlanDescription PPDes ON PPDes.PlanDescriptionId = PPD.PlanDescriptionId
			INNER JOIN policymanagement..TRefPlanType2ProdSubType PPTPS ON PPDes.RefPlanType2ProdSubTypeId = PPTPS.RefPlanType2ProdSubTypeId   
			INNER JOIN policymanagement..TRefPlanType PRPT ON PRPT.RefPlanTypeId = PPTPS.RefPlanTypeId
			INNER JOIN policymanagement..TRefProdProvider PP ON PP.RefProdProviderId = PPDes.RefProdProviderId
			INNER JOIN crm..TCRMContact crm ON crm.CRMContactId = PP.CRMContactId 
		WHERE 
			PRPT.PlanTypeName = 'Wrap') AS ParentPlan
			ON ParentPlan.PolicyBusinessId = wrapper1.ParentPolicyBusinessId

WHERE 
	Wrapper1.ParentPolicyBusinessId IS NOT NULL 
	AND ParentPlan.PlanTypeName = 'Wrap'
	AND (TS.IntelligentOfficeStatusType = 'In force' OR TS.IntelligentOfficeStatusType = 'Paid Up') 
	AND TSH.CurrentStatusFG = 1


--Identify TopUp plans
Update a
Set a.TopupMasterPolicyBusinessId = pb.TopupMasterPolicyBusinessId
From @PlanGrouping a 
inner join policymanagement..TPolicyBusiness pb on pb.PolicyBusinessId = a.PolicyBusinessId

--Group Topup plans under their respective 'WRAP' plan types
Update a
Set a.WrapPlan = wp2topupplan.wrapplan
From  @PlanGrouping a
Inner Join (
	--Identify wrap plan linked to a topup master plan
	Select topupplans.TopupMasterPolicyBusinessId, topupplans.PolicyBusinessId, a.WrapPlan
	From @PlanGrouping a
	Inner Join (
		--Identify topup plans 
		Select PolicyBusinessId, TopupMasterPolicyBusinessId
		From @PlanGrouping
		Where WrapPlan = 0 and TopupMasterPolicyBusinessId is not null
		) topupplans on a.PolicyBusinessId = topupplans.TopupMasterPolicyBusinessId
	) wp2topupplan on wp2topupplan.PolicyBusinessId = a.PolicyBusinessId


--test 
--select *from @PlanGrouping


-- other investments plans
IF (ISNULL(@ParentPolicyBusinessId ,0) <= 0)
BEGIN   
	SELECT DISTINCT
		Pd.OtherInvestmentsPlansId,
		pd.CRMContactId,
		pd.CRMContactId2,
		pd.[Owner],
		pd.SellingAdviserId,
		pd.SellingAdviserName,
		pd.RefProdProviderId,  
		pd.Provider,
		pd.PolicyNumber,
		pd.AgencyStatus,
		pd.PlanType,
		Pd.RefPlanType2ProdSubTypeId,
		Pd.PlanPurposeText,
		Pd.ContributionThisTaxYearFg,
		Pd.RegularContribution,
		Pd.Frequency,
		Pd.CurrentValue,
		Pd.ValuationDate,
		Pd.OtherInvStartDate,
		Pd.MaturityDate,
		Pd.MonthlyIncome,
		Pd.InTrustFg,
		Pd.ExcludeValuation,
		Pd.ConcurrencyId,
		Pd.PlanStatus,
		Pd.MortgageRepayPercentage,
		Pd.MortgageRepayAmount,
		Pd.[IsGuaranteedToProtectOriginalInvestment],
		Pd.PlanPurposeId,
		Pd.LowMaturityValue,
		Pd.MediumMaturityValue,
		Pd.HighMaturityValue,
		Pd.ProjectionDetails,
		Pd.ToWhom, 
		Pd.ActualRegularContribution,
		Pd.TotalSingleContribution,
		Pd.RegularContributionsFrequency,
		PG.IsWrapperPlan,
		Pd.ProductName,
		Pd.LumpsumContributionAmount,
		PG.WrapPlan,
		Pd.InterestRate,
		Pd.PlanCurrency,
		Pd.ParentPlanType,
		Pd.SequentialRef,
		Pd.IsProviderManaged
	FROM
		@PlanDesc Pd
		LEFT JOIN @PlanGrouping PG ON PD.PolicyBusinessId = PG.PolicyBusinessId

END
ELSE
BEGIN
	SELECT DISTINCT
		Pd.PolicyBusinessId AS OtherInvestmentsPlansId,                              
		pd.CRMContactId,                             
		pd.CRMContactId2,                                  
		pd.[Owner],                            
		pd.SellingAdviserId,                            
		pd.SellingAdviserName,  
		pd.RefProdProviderId,
		pd.Provider,                            
		pd.PolicyNumber,
		pd.AgencyStatus,
		pd.PlanType,      
		Pd.RefPlanType2ProdSubTypeId,                        
		CASE @ExcludePlanPurposes     
		WHEN 1 THEN ''    
		ELSE ISNULL(Pd.PlanPurpose,'')    
		END AS PlanPurposeText,                                    
		t.ContributionThisTaxYearFg,                                  
		Pd.RegularPremium as RegularContribution,               
		 
		CASE
			WHEN isnull(Pd.ActualRegularPremium,0) > 0 then Pd.Frequency    
			WHEN isnull(Pd.TotalLumpSum,0) > 0 then 'Single'
			ELSE Pd.Frequency    
		END AS Frequency,
		                    
		pd.CurrentValue,
		pd.ValuationDate,                            
		pd.StartDate as OtherInvStartDate,         
		pd.MaturityDate,       
		T.MonthlyIncome,                                  
		P.InTrust AS InTrustFg,    
		pd.ExcludeValuation,     
		pd.ConcurrencyId,    
		pd.PlanStatus,    
		pd.MortgageRepayPercentage,    
		pd.MortgageRepayAmount,    
		[IsGuaranteedToProtectOriginalInvestment]  ,  
		CASE @ExcludePlanPurposes     
			WHEN 1 THEN null    
			ELSE pd.PlanPurposeId    
		END As PlanPurposeId,  
		pd.LowMaturityValue,  
		pd.MediumMaturityValue,  
		pd.HighMaturityValue, pd.ProjectionDetails, 
		P.ToWhom, 
		Pd.ActualRegularPremium AS ActualRegularContribution,
		Pd.TotalLumpSum AS TotalSingleContribution,

		--Need to display only regular frequency types
		CASE WHEN Pd.Frequency = 'SINGLE' THEN '' ELSE Pd.Frequency END AS RegularContributionsFrequency,		 
		CAST(0 AS BIT) AS IsWrapperPlan,
		Pd.ProductName,
		LumpSum.Amount as LumpsumContributionAmount,
		0 AS [WrapPlan],
		pd.InterestRate,
		pd.PlanCurrency,
		pd.SequentialRef,
		pd.IsProviderManaged
		FROM     
		@PlanDescription pd                                 
		 	 
		LEFT JOIN TOtherInvestmentsPlanFFExt t ON t.PolicyBusinessId = pd.PolicyBusinessId                                 
		LEFT JOIN Policymanagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = pd.PolicyBusinessId    
		JOIN Policymanagement..TWrapperPolicyBusiness wrapper WITH(NOLOCK) ON wrapper.PolicyBusinessId = PD.PolicyBusinessId                             
		LEFT JOIN PolicyManagement..TPolicyMoneyIn TPM WITH(NOLOCK) ON pd.PolicyBusinessId   = TPM.PolicyBusinessId 
		-- Lump Sum Contributions
		LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = pd.PolicyBusinessId  
	
		WHERE     
		wrapper.ParentPolicyBusinessId = @ParentPolicyBusinessId
	END

SET NOCOUNT OFF
END
GO
