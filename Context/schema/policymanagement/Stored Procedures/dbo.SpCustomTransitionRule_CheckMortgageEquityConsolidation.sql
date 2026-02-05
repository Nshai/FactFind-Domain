SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckMortgageEquityConsolidation]    
  @PolicyBusinessId bigint,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
    
	declare @PlanTypeId bigint 	  
	-- Mortgage
	declare @MORTGAGE_PLAN_TYPE bigint = 63    

	SELECT 
		@PlanTypeId = rpt2pst.RefPlanTypeId
	FROM 
		TRefPlanType2ProdSubType rpt2pst    
		INNER JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		INNER JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		INNER JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
	WHERE 
		pb.PolicyBusinessId = @PolicyBusinessId    

	--Check Plan Type
	if @PlanTypeId = @MORTGAGE_PLAN_TYPE 
	begin    
		DECLARE @IsRepayDept bit = null

		--Check Value
		SELECT @IsRepayDept = RepayDebtFg
		FROM 
			TMortgage    
		WHERE 
			PolicyBusinessId = @policyBusinessId    
		
		--Check result
		IF @IsRepayDept IS NULL
		BEGIN		   
			SET @ErrorMessage = 'ISREPAYDEBT'     
		END        
	end    
END    
  


GO
