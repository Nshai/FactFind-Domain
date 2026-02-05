SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPreExistingProtection]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(max) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
										
	--Only applies to person clients
	if @ClientType != 'PERSON'
		return(0)	
	
	Declare @Valid1 int = 0
	Declare @TenantId bigint
		
	Declare @PreExistingProtections TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, --Required
			ExpiryDate varchar(3), BenefitOrSumAssured varchar(3), Premium varchar(3)
	)

	SELECT @TenantId=IndigoClientId FROM TPolicyBusiness WHERE PolicyBusinessId=@PolicyBusinessId
	
	Declare @PreExistingAdviceType bigint
	Set @PreExistingAdviceType = (Select Top 1 AdviceTypeId from TAdviceType where IntelligentOfficeAdviceType = 'Pre-Existing'
	AND IndigoClientId=@TenantId AND ArchiveFg=0)

	IF OBJECT_ID('tempdb..#AllowedPlanTypes') IS NOT NULL
		DROP TABLE #AllowedPlanTypes;

	CREATE TABLE #AllowedPlanTypes
	(
		RefPlanType2ProdSubTypeId INT NOT NULL PRIMARY KEY
	)

	INSERT INTO #AllowedPlanTypes (RefPlanType2ProdSubTypeId)
	VALUES (23),  --Pension Term Assurance
		(24),  --Group Death In Service
		(54),  --Whole Of Life
		(55),  --Term Protection
		(56),  --Income Protection
		(58),  --Accident Sickness & Unemployment Insurance
		(64),  --Group Income Protection
		(65),  --Group Term
		(78),  --Group Critical Illness
		(91),  --Term Protection (Critical Illness)
		(92),  --Term Protection (Decreasing Term)
		(93),  --Term Protection (Directors Share Protection)
		(94),  --Term Protection (Family Income Benefit)
		(95),  --Term Protection (Key Person Assurance)
		(96),  --Term Protection (Mortgage Protection)
		(97),  --Term Protection (Partnership Protection)
		(103),  --Term Protection (Convertible)
		(104),  --Term Protection (Level)
		(109),  --Group Accident and Sickness
		(110),  --Accident and Sickness Insurance
		(111),  --Unemployment Insurance
		(112),  --Gift Inter Vivos
		(123),  --Redundancy Insurance
		(124),  --Term Protection (Increasing Term)
		(1015),  --Whole Of Life (Non Investment)
		(1021),  --Income Protection (Executive)
		(1022),  --Income Protection (Key person)
		(1023),  --Term Protection (Renewable)
		(1028),  --Pre-Paid Funeral Plan
		(1057),  --Relevant Life Policy
		(1059),  --General Insurance (Income Protection)
		(1062),  --Term Protection (Decreasing Term - CI)
		(1065),  --Accidental Death Insurance
		(1069),  --Term Protection (Decreasing Term - Life & CI)
		(1070),  --Term Protection (Family Income Benefit - CI)
		(1071),  --Term Protection (Family Income Benefit - Life & CI)
		(1072),  --Term Protection (Level - Life & CI)
		(1114),  --Group Life (Excepted)
		(1115)  --Group Life (Registered)

	insert into @PreExistingProtections
		Select Distinct B.PolicyBusinessId, B.SequentialRef, @Owner1Id,								-- OWNER 1 pre-existing Protection Plans			
			Case  When B.MaturityDate IS NOT NULL Then 'YES' ELSE 'NO' END,							-- ExpiryDate		
			Case  When ISNULL(CONVERT(INT,B1.BenefitAmount),0)=0
					 AND ISNULL(CONVERT(INT,GI.SumAssured),0)=0 
					 AND ISNULL(CONVERT(INT, F.LifeCoverSumAssured), 0) = 0
					 AND ISNULL(CONVERT(INT, F.CriticalIllnessSumAssured), 0) = 0
					 Then 'NO' ELSE 'YES' END,			-- Benefit or SumAssured
			Case  When ISNULL(CONVERT(INT,B.TotalRegularPremium),0)=0  Then 'NO' ELSE 'YES' END		-- Premium
			
		From TPolicyOwner A 
		Inner join TPolicyBusiness B ON A.PolicyDetailId = B.PolicyDetailId
		Inner Join TStatusHistory SH ON B.PolicyBusinessId=SH.PolicyBusinessId AND SH.CurrentStatusFG=1
		Inner Join TStatus ST ON SH.StatusId=ST.StatusId 
		Inner Join TPolicyDetail C ON B.PolicyDetailId = C.PolicyDetailId
		Inner join TPlanDescription D ON C.PlanDescriptionId = D.PlanDescriptionId
		Inner join TRefPlanType2ProdSubType E ON D.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId
		INNER JOIN #AllowedPlanTypes apt ON apt.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId --Specific plan types only
		Inner join factfind..TRefPlanTypeToSection G ON E.RefPlanType2ProdSubTypeId = G.RefPlanType2ProdSubTypeId  -- THIS IS THE IMPORTANT JOIN FOR PROTECTION 
		LEFT join TProtection F ON B.PolicyBusinessId = F.PolicyBusinessId
		Left Join TAssuredLife AL1 WITH(NOLOCK) ON AL1.ProtectionId = F.ProtectionId AND AL1.OrderKey = 1  
		Left JOIN PolicyManagement..TBenefit B1 WITH(NOLOCK) ON B1.BenefitId = AL1.BenefitId 
		Left JOIN PolicyManagement..TGeneralInsuranceDetail GI WITH(NOLOCK) ON GI.ProtectionId = F.ProtectionId AND GI.RefInsuranceCoverCategoryId = 5 -- Payment Protection  

		Where B.AdviceTypeId = @PreExistingAdviceType		
		And G.Section = 'Protection' -- this is the advised way to filter protection plans for this is case.
		And A.CRMContactId = @Owner1Id
		AND ST.IntelligentOfficeStatusType!='Deleted'
		
		
	UNION -- get owner 2s prexsiting mortgages
	
		Select Distinct B.PolicyBusinessId, B.SequentialRef, @Owner1Id,								-- OWNER 1 pre-existing Protection Plans			
			Case  When B.MaturityDate IS NOT NULL Then 'YES' ELSE 'NO' END,							-- ExpiryDate		
			Case  When ISNULL(CONVERT(INT,B1.BenefitAmount),0)=0
					 AND ISNULL(CONVERT(INT,GI.SumAssured),0)=0 
					 AND ISNULL(CONVERT(INT, F.LifeCoverSumAssured), 0) = 0
					 AND ISNULL(CONVERT(INT, F.CriticalIllnessSumAssured), 0) = 0
					 Then 'NO' ELSE 'YES' END,			-- Benefit or SumAssured
			Case  When ISNULL(CONVERT(INT,B.TotalRegularPremium),0)=0 Then 'NO' ELSE 'YES' END		-- Premium
			
		From TPolicyOwner A 
		Inner join TPolicyBusiness B ON A.PolicyDetailId = B.PolicyDetailId 
		Inner Join TStatusHistory SH ON B.PolicyBusinessId=SH.PolicyBusinessId AND SH.CurrentStatusFG=1
		Inner Join TStatus ST ON SH.StatusId=ST.StatusId 
		Inner Join TPolicyDetail C ON B.PolicyDetailId = C.PolicyDetailId
		Inner join TPlanDescription D ON C.PlanDescriptionId = D.PlanDescriptionId
		Inner join TRefPlanType2ProdSubType E ON D.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId
		INNER JOIN #AllowedPlanTypes apt ON apt.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId --Specific plan types only
		Inner join factfind..TRefPlanTypeToSection G ON E.RefPlanType2ProdSubTypeId = G.RefPlanType2ProdSubTypeId  -- THIS IS THE IMPORTANT JOIN FOR PROTECTION 
		LEFT join TProtection F ON B.PolicyBusinessId = F.PolicyBusinessId
		Left Join TAssuredLife AL1 WITH(NOLOCK) ON AL1.ProtectionId = F.ProtectionId AND AL1.OrderKey = 1  
		Left JOIN PolicyManagement..TBenefit B1 WITH(NOLOCK) ON B1.BenefitId = AL1.BenefitId 
		Left JOIN PolicyManagement..TGeneralInsuranceDetail GI WITH(NOLOCK) ON GI.ProtectionId = F.ProtectionId AND GI.RefInsuranceCoverCategoryId = 5 -- Payment Protection  

		Where B.AdviceTypeId = @PreExistingAdviceType		
		And G.Section = 'Protection' -- this is the advised way to filter protection plans for this is case.
		And A.CRMContactId = @Owner2Id
		AND ST.IntelligentOfficeStatusType!='Deleted'
	
		
		--Remove Preexisting mortgages that have no Redemtion Penalty
		Delete From @PreExistingProtections 
		WHERE ExpiryDate = 'YES' 
		AND  BenefitOrSumAssured = 'YES' 
		AND  Premium = 'YES'
	
	
	if (Select COUNT(1) From @PreExistingProtections) = 0 
		return(0)
	
	

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'PlanId=' +convert(varchar(50),PlanId) + '::'+  
			'SequentialRef=' +convert(varchar(50),SequentialRef)  + '::'+  
			'OwnerId=' +convert(varchar(20),OwnerId) + '::'+  
			'ExpiryDate=' + ExpiryDate + '::' +  
			'BenefitOrSumAssured='+ BenefitOrSumAssured + '::' +  
			'Premium='+ Premium 	
			
		FROM @PreExistingProtections
				
		SELECT @ErrorMessage = 'PREEXISTINGPROTECTION_' + @Ids

	
		

GO
