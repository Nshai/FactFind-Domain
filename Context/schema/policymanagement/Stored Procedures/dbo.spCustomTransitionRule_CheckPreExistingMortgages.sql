SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPreExistingMortgages]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(max) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  
	Declare @TenantId bigint

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
										
	--Only applies to person clients
	if @ClientType != 'PERSON'
		return(0)	
	
	Declare @Valid1 int = 0

	SELECT @TenantId=IndigoClientId from TPolicyBusiness Where PolicyBusinessId=@PolicyBusinessId
		
	Declare @PreExistingMortgages TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, --Required
			RateType varchar(3), RatePeriodFromCompletion varchar(3), RepaymentMethod varchar(3), 
			InterestRate varchar(3), CurrentBalance varchar(3), HasRedemptionPenalty varchar(3), 
			RedemptionTerms varchar(3), RedemptionEndDate varchar(3), WillPayRedemption varchar(3), 
			RemainingTerm varchar(3)
	)

	-- Mortgage
	declare @MortgagePlanType int = 63    
	-- Mortgage - Non-Regulated
	declare @UnregulatedMortgagePlanType bigint = 1039   
	
	Declare @PreExistingAdviceType bigint
	Set @PreExistingAdviceType = (Select Top 1 AdviceTypeId from TAdviceType where IntelligentOfficeAdviceType = 'Pre-Existing' AND IndigoClientId=@TenantId AND ArchiveFg=0)

	insert into @PreExistingMortgages
		Select Distinct B.PolicyBusinessId, B.SequentialRef, @Owner1Id,							-- OWNER 1 pre-existing Morgages
			
			Case  When F.MortgageType IS NULL THEN 'NO' ELSE 'YES' END,									-- Rate Type
			Case  When F.RatePeriodFromCompletionMonths IS NULL THEN 'NO' ELSE 'YES' END,				-- RatePeriodFromCompletion
			Case  When F.RefMortgageRepaymentMethodId IS NULL THEN 'NO' ELSE 'YES' END,					-- RepaymentMethod
			Case  When ISNULL(CONVERT(INT,F.InterestRate),0)=0 THEN 'NO' ELSE 'YES' END,				-- InterestRate
			Case  When ISNULL(CONVERT(INT,pv.PlanValue),0)=0 THEN 'NO' ELSE 'YES' END,				-- CurrentBalance
			Case  When F.PenaltyFg IS NULL THEN 'NO' ELSE 'YES' END,									-- HasRedemptionPenalty			
			Case  When F.PenaltyFg = 1 AND F.RedemptionTerms IS NULL THEN 'NO' ELSE 'YES' END,			-- RedemptionTerms
			Case  When F.PenaltyFg = 1 AND F.PenaltyExpiryDate IS NULL THEN 'NO' ELSE 'YES' END,		-- RedemptionEndDate
			Case  When F.PenaltyFg = 1 AND ISNULL(F.WillPayRedemption, 0) = 0 THEN 'NO' ELSE 'YES' END,	-- WillPayRedemption
			Case  When ISNULL(F.RemainingTerm,0)=0 THEN 'NO' ELSE 'YES' END									-- RemainingTerm
			
		From TPolicyOwner A 
		Inner join TPolicyBusiness B ON A.PolicyDetailId = B.PolicyDetailId 
		Inner Join TPolicyDetail C ON B.PolicyDetailId = C.PolicyDetailId
		Inner join TPlanDescription D ON C.PlanDescriptionId = D.PlanDescriptionId
		Inner join TRefPlanType2ProdSubType E ON D.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId
		inner join TMortgage F ON B.PolicyBusinessId = F.PolicyBusinessId
		left join (
			select MAX(planvaluationid) as LastValuationId, PolicyBusinessId 
			from TPlanValuation 
			GROUP BY PolicyBusinessId
		) lastVal on lastVal.PolicyBusinessId = b.PolicyBusinessId
		left join TPlanValuation pv on pv.PlanValuationId = lastVal.LastValuationId

		Where B.AdviceTypeId = @PreExistingAdviceType
		And (E.RefPlanTypeId = @MortgagePlanType OR E.RefPlanTypeId = @UnregulatedMortgagePlanType)
		And A.CRMContactId = @Owner1Id
		
	UNION -- get owner 2s prexsiting mortgages
	
		Select Distinct B.PolicyBusinessId, B.SequentialRef, @Owner2Id,							-- OWNER 1 pre-existing Morgages			
			Case  When F.MortgageType IS NULL THEN 'NO' ELSE 'YES' END,									-- Rate Type
			Case  When F.RatePeriodFromCompletionMonths IS NULL THEN 'NO' ELSE 'YES' END,				-- RatePeriodFromCompletion
			Case  When F.RefMortgageRepaymentMethodId IS NULL THEN 'NO' ELSE 'YES' END,					-- RepaymentMethod
			Case  When ISNULL(CONVERT(INT,F.InterestRate),0)=0 THEN 'NO' ELSE 'YES' END,				-- InterestRate
			Case  When ISNULL(CONVERT(INT,pv.PlanValue),0)=0 THEN 'NO' ELSE 'YES' END,				-- Current Balance
			Case  When F.PenaltyFg IS NULL THEN 'NO' ELSE 'YES' END,									-- HasRedemptionPenalty	
			Case  When F.PenaltyFg = 1 AND F.RedemptionTerms IS NULL THEN 'NO' ELSE 'YES' END,			-- RedemptionTerms
			Case  When F.PenaltyFg = 1 AND F.PenaltyExpiryDate IS NULL THEN 'NO' ELSE 'YES' END,		-- RedemptionEndDate
			Case  When F.PenaltyFg = 1 AND ISNULL(F.WillPayRedemption, 0) = 0 THEN 'NO' ELSE 'YES' END,	-- WillPayRedemption
			Case  When ISNULL(F.RemainingTerm,0)=0  THEN 'NO' ELSE 'YES' END							-- RemainingTerm
			
		from TPolicyOwner A 
		Inner join TPolicyBusiness B ON A.PolicyDetailId = B.PolicyDetailId 
		Inner Join TPolicyDetail C ON B.PolicyDetailId = C.PolicyDetailId
		Inner join TPlanDescription D ON C.PlanDescriptionId = D.PlanDescriptionId
		Inner join TRefPlanType2ProdSubType E ON D.RefPlanType2ProdSubTypeId = E.RefPlanType2ProdSubTypeId
		inner join TMortgage F ON B.PolicyBusinessId = F.PolicyBusinessId
		left join @PreExistingMortgages G on B.PolicyBusinessId = G.PlanId
		left join (
			select MAX(planvaluationid) as LastValuationId, PolicyBusinessId 
			from TPlanValuation 
			GROUP BY PolicyBusinessId
		) lastVal on lastVal.PolicyBusinessId = b.PolicyBusinessId		
		left join TPlanValuation pv on pv.PlanValuationId = lastVal.LastValuationId
		Where B.AdviceTypeId = @PreExistingAdviceType
		And (E.RefPlanTypeId = @MortgagePlanType OR E.RefPlanTypeId = @UnregulatedMortgagePlanType)
		And A.CRMContactId = @Owner2Id
		and G.PlanId IS NULL -- don't add if already added from owner 1
	
		Delete From @PreExistingMortgages --Remove Preexisting mortgages that have no Redemtion Penalty
		WHERE RateType = 'YES' 
		AND  RatePeriodFromCompletion = 'YES' 
		AND  RepaymentMethod = 'YES' 
		AND  InterestRate = 'YES' 
		AND  CurrentBalance = 'YES' 
		AND  HasRedemptionPenalty = 'NO' -- indicates no redemption penalty
		
		Delete From @PreExistingMortgages --Remove Preexisting mortgages that have a Redemtion Penaly
		WHERE RateType = 'YES'  
		AND  RatePeriodFromCompletion = 'YES' 
		AND  RepaymentMethod = 'YES' 
		AND  InterestRate = 'YES' 
		AND  CurrentBalance = 'YES' 
		AND  HasRedemptionPenalty = 'YES' -- indicates redemption penalty, fields below must also be checked
		AND  RedemptionTerms = 'YES' 
		AND  RedemptionEndDate = 'YES' 
		AND  WillPayRedemption = 'YES' 
		AND  RemainingTerm = 'YES'
	
	
	if (Select COUNT(1) From @PreExistingMortgages) = 0 
		return(0)
	
	

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'PlanId=' +convert(varchar(50),PlanId) + '::'+  
			'SequentialRef=' +convert(varchar(50),SequentialRef)  + '::'+  
			'OwnerId=' +convert(varchar(20),OwnerId) + '::'+  
			'RateType=' + RateType + '::' +  
			'RatePeriodFromCompletion='+ RatePeriodFromCompletion + '::' +  
			'RepaymentMethod='+ RepaymentMethod + '::' +  
			'InterestRate='+ InterestRate + '::' +  
			'CurrentBalance='+ CurrentBalance + '::' +  
			'HasRedemptionPenalty='+ HasRedemptionPenalty + '::' +  
			'RedemptionTerms='+ RedemptionTerms + '::' +  
			'RedemptionEndDate='+ RedemptionEndDate + '::' +  
			'WillPayRedemption='+ WillPayRedemption + '::' +  
			'RemainingTerm='+ RemainingTerm 		
			
		FROM @PreExistingMortgages
				
		SELECT @ErrorMessage = 'PREEXISTINGMORTGAGES_' + @Ids

	
		

GO
