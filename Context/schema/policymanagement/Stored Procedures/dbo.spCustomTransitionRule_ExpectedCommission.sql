SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_ExpectedCommission]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

	--Get the plan Type
	declare @PlanTypeId bigint    
	-- Mortgage
	declare @MORTGAGE_PLAN_TYPE int = 63 

	

	SET @PlanTypeId =     
	(    
		select rpt2pst.RefPlanTypeId    
		FROM TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
		WHERE pb.PolicyBusinessId = @PolicyBusinessId    
	)    

	Declare @IsMortgagePlan varchar(3) = 'NO'
	
	if @PlanTypeId = @MORTGAGE_PLAN_TYPE 
	BEGIN			
		set @IsMortgagePlan = 'YES'
	END



--    Check if  there is at least one expected commission record      
       IF  (Select count(*) From TPolicyExpectedCommission Where PolicyBusinessId = @PolicyBusinessId) = 0
       BEGIN
            SELECT @ErrorMessage = 'EXPECTEDCOMMS_IsMortgagePlanType=' + @IsMortgagePlan
       END




GO


