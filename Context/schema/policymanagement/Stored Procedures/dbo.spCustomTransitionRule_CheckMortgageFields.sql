SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckMortgageFields]    
  @PolicyBusinessId bigint,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
    
	declare @PlanTypeId bigint    
	declare @PlanSubTypeId bigint    

	-- Mortgage
	declare @MORTGAGE_PLAN_TYPE bigint = 63    
	-- Mortgage - Non-Regulated
	declare @UNREGULATED_MORTGAGE_PLAN_TYPE bigint = 1039      

	SELECT 
		@PlanTypeId = rpt2pst.RefPlanTypeId, @PlanSubTypeId = rpt2pst.ProdSubTypeId
	FROM 
		TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
	WHERE 
		pb.PolicyBusinessId = @PolicyBusinessId    


	if @PlanTypeId = @MORTGAGE_PLAN_TYPE OR @PlanTypeId = @UNREGULATED_MORTGAGE_PLAN_TYPE 
	begin    
		declare @LoanAmount money,     
			@PropertyValue bigint,     
			@InterestRate real,     
			@MortgageTerm decimal,
			@MortgageTermMonths int,
			@BaseRate varchar(50),
			@LoadingPercentage bigint

		SELECT @LoanAmount = LoanAmount,     
			@PropertyValue = PriceValuation,     
			@InterestRate = InterestRate,     
			@MortgageTerm = MortgageTerm,
			@MortgageTermMonths = MortgageTermMonths,
			@BaseRate = BaseRate,
			@LoadingPercentage=LoadingPct
		From 
			TMortgage    
		WHERE 
			PolicyBusinessId = @policyBusinessId    
		 
		if (ISNULL(@LoanAmount, 0) = 0 or ISNULL(@PropertyValue,0) = 0 or ISNULL(@MortgageTerm ,0)= 0) or ISNULL(@MortgageTermMonths,0)= 0 
		OR (ISNULL(@InterestRate,0)= 0 AND ISNULL(@BaseRate,'') = '' AND ISNULL(@LoadingPercentage,0)= 0)
		begin    
		   
			set @ErrorMessage = '' -- can't append if null 
		    
			If ISNULL(@LoanAmount, 0) = 0     
				select @ErrorMessage = @ErrorMessage + 'LOANAMOUNT,'    
		    
			If ISNULL(@PropertyValue, 0) = 0     
				select @ErrorMessage = @ErrorMessage + 'PROPERTYVALUE,'     
		    
			IF ISNULL(@InterestRate, 0) = 0 AND ISNULL(@BaseRate, '') = '' AND ISNULL(@LoadingPercentage,0) = 0
				select @ErrorMessage = @ErrorMessage + 'INTERESTBASEDONPERCENTAGE,'
	    
			IF ISNULL(@MortgageTerm, 0) = 0    
				select @ErrorMessage = @ErrorMessage + 'MORTGAGETERM'      
		end        
	end    
END    
  


GO
