SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[spCustomTransitionRule_CheckIncomeEvidenced]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS
	
	declare @PlanTypeId bigint    
	declare @MORTGAGE_PLAN_TYPE int    

	set @MORTGAGE_PLAN_TYPE = 63    

	SET @PlanTypeId =     
	(    
		select rpt2pst.RefPlanTypeId    
		FROM TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
		WHERE pb.PolicyBusinessId = @PolicyBusinessId    
	)    

	if @PlanTypeId != @MORTGAGE_PLAN_TYPE    
		Return(0)
	
			
	Declare @Valid int = 0
		
	
	--This is the same check for single and joint, because even for single the 
	--owner could be the second owner of a valid Fact.
	Set @Valid = (
			Select COUNT(1) from TMortgage
			Where PolicyBusinessId = @PolicyBusinessId
			AND IncomeEvidencedFg = 1
		)
	
	IF @Valid = 0
	BEGIN	
		select @ErrorMessage = 'MORTGAGEINCOMEEVIDENCED'
	END