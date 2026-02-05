SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckMortgageTerm]    
  @PolicyBusinessId bigint,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
    
	DECLARE @PlanTypeId bigint 
	-- Mortgage
	DECLARE @MORTGAGE_PLAN_TYPE bigint = 63    
	-- Equity Release
	DECLARE @EQUITY_RELEASE_PLAN_TYPE bigint = 64
	-- Mortgage - Non-Regulated
	DECLARE @UNREGULATED_MORTGAGE_PLAN_TYPE bigint = 1039

	SELECT 
		@PlanTypeId = rpt2pst.RefPlanTypeId
	FROM 
		TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
	WHERE 
		pb.PolicyBusinessId = @PolicyBusinessId    

	IF @PlanTypeId != @MORTGAGE_PLAN_TYPE AND @PlanTypeId != @UNREGULATED_MORTGAGE_PLAN_TYPE AND @PlanTypeId != @EQUITY_RELEASE_PLAN_TYPE
		RETURN;

	DECLARE @Term decimal(18,3),     
			@CapitalTerm decimal(18,3),   
			@InterestTerm decimal(18,3)

	if @PlanTypeId = @MORTGAGE_PLAN_TYPE OR @PlanTypeId =  @UNREGULATED_MORTGAGE_PLAN_TYPE
	BEGIN   
		SELECT @Term = ISNULL(MortgageTerm, MortgageTermMonths),
		@CapitalTerm = CapitalRepaymentTerm,
		@InterestTerm = InterestOnlyTerm
		FROM 
			TMortgage    
		WHERE 
			PolicyBusinessId = @policyBusinessId

		If ISNULL(@Term, 0) = 0 AND ISNULL(@CapitalTerm, 0) = 0 AND ISNULL(@InterestTerm, 0) = 0   
			SELECT @ErrorMessage = 'MORTGAGE'
	END  
	ELSE IF @PlanTypeId = @EQUITY_RELEASE_PLAN_TYPE
	BEGIN
		SELECT @Term = COALESCE(TermInYears,TermInMonths)
		FROM 
			TEquityRelease
		WHERE 
			PolicyBusinessId = @policyBusinessId  

		If ISNULL(@Term, 0) = 0     
			SELECT @ErrorMessage = 'EQUITY'
	END	
END
GO
