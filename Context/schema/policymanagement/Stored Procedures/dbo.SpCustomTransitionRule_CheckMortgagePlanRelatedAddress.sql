SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckMortgagePlanRelatedAddress]    
  @PolicyBusinessId bigint,    
  @ErrorMessage varchar(512) OUTPUT    
AS    
    
BEGIN    
    
	SELECT @ErrorMessage=''
	DECLARE @PlanTypeId bigint    
	DECLARE @MORTGAGE_PLAN_TYPE int  
	declare @UNREGULATED_MORTGAGE_PLAN_TYPE bigint

	SELECT @MORTGAGE_PLAN_TYPE = RefPlanTypeId FROM TRefPlanType WHERE PlanTypeName='Mortgage'    
	SELECT @UNREGULATED_MORTGAGE_PLAN_TYPE = RefPlanTypeId FROM TRefPlanType WHERE PlanTypeName='Mortgage - Non-Regulated'    
	

	SET @PlanTypeId =     
	(    
		SELECT rpt2pst.RefPlanTypeId    
		FROM TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
		WHERE pb.PolicyBusinessId = @PolicyBusinessId    
	)    
	
	IF (@PlanTypeId = @MORTGAGE_PLAN_TYPE OR @PlanTypeId = @UNREGULATED_MORTGAGE_PLAN_TYPE)   
	BEGIN    
		DECLARE @AddressStoreId bigint
			
		SELECT @AddressStoreId = AddressStoreId			
			FROM TMortgage    
			WHERE PolicyBusinessId = @policyBusinessId    

		 
		IF ISNULL(@AddressStoreId, 0) = 0 
		BEGIN		   
			select @ErrorMessage =@ErrorMessage + 'MORTGAGERELATEDADDRESS'      	                
		END        
	END   
	
END    
  


GO
