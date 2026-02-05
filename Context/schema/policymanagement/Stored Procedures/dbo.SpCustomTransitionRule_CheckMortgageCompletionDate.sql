SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckMortgageCompletionDate]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) OUTPUT
AS
    
BEGIN
    
	SELECT @ErrorMessage=''
	DECLARE @PlanTypeId bigint
	-- Mortgage
	DECLARE @MORTGAGE_PLAN_TYPE int = 63
	-- Mortgage - Non-Regulated
	DECLARE @UNREGULATED_MORTGAGE_PLAN_TYPE bigint = 1039
	

	SET @PlanTypeId =
	(
		SELECT rpt2pst.RefPlanTypeId
		FROM TRefPlanType2ProdSubType rpt2pst
		JOIN TPlanDescription pds ON pds.RefPlanType2ProdSubTypeId = rpt2pst.RefPlanType2ProdSubTypeId
		JOIN TPolicyDetail pd ON pd.PlanDescriptionId = pds.PlanDescriptionId
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId
		WHERE pb.PolicyBusinessId = @PolicyBusinessId
	)
	
	IF @PlanTypeId = @MORTGAGE_PLAN_TYPE OR @PlanTypeId=@UNREGULATED_MORTGAGE_PLAN_TYPE
	BEGIN
		DECLARE @CompletionDate DATETIME

		SELECT @CompletionDate = CompletionDate
			FROM TMortgage
			WHERE PolicyBusinessId = @policyBusinessId

		
		IF @CompletionDate IS NULL
		BEGIN
			SELECT @ErrorMessage = @ErrorMessage + 'MORTGAGEPLANCOMPLETIONDATE'
		END
	END
	
END    
  


GO
