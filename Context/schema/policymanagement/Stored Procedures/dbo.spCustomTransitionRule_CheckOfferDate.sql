SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckOfferDate]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS
	
	declare @PlanTypeId bigint    
	-- Mortgage
	declare @MORTGAGE_PLAN_TYPE int = 63    
	-- Mortgage - Non-Regulated
	declare @UNREGULATED_MORTGAGE_PLAN_TYPE bigint = 1039   

	

	SET @PlanTypeId =     
	(    
		select rpt2pst.RefPlanTypeId    
		FROM TRefPlanType2ProdSubType rpt2pst    
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId    
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId    
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId    
		WHERE pb.PolicyBusinessId = @PolicyBusinessId    
	)    

	if @PlanTypeId = @MORTGAGE_PLAN_TYPE OR @PlanTypeId =  @UNREGULATED_MORTGAGE_PLAN_TYPE  
	BEGIN				
		Declare @Valid int = 0
		
	
		Set @Valid = (
				Select COUNT(1) from TMortgage
				Where PolicyBusinessId = @PolicyBusinessId
				AND ISNULL(OfferIssued,'') != ''
			)
	
		IF @Valid = 0
		BEGIN	
			Select @ErrorMessage = 'MORTGAGEOFFERDATE'
		END
	END