SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckForActiveTopUps]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

      BEGIN

	--cannot delete a plan if it has top ups which are not deleted
	declare @PolicyDetailId bigint, @NumberOfPlans int
	SET @PolicyDetailId = 
	(
		SELECT PolicyDetailId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId
	)
	
	-- is this a top up?
	declare @MinPolicyBusinessId bigint
	SET @MinPolicyBusinessId = (SELECT min(PolicyBusinessId) FROM TPolicyBusiness WHERE PolicyDetailId = @PolicyDetailId)
	
	IF @MinPolicyBusinessId < @PolicyBusinessId -- this is a top up
		return
		
	SET @NumberOfPlans = (
		SELECT count(pb.PolicyBusinessId)
		FROM TPolicyDetail pd
		JOIN TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId
		JOIN TStatusHistory sh ON sh.PolicyBusinessId = pb.PolicyBusinessId AND sh.CurrentStatusFg = 1
		JOIN TStatus s ON s.StatusId = sh.StatusId AND s.IntelligentOfficeStatusType <> 'Deleted'
		WHERE pd.PolicyDetailId = @PolicyDetailId
	)
		
	
	if(@NumberOfPlans > 1)
	begin
		select @ErrorMessage = 'ACTIVETOPUPS'
	end


	

      END







GO
