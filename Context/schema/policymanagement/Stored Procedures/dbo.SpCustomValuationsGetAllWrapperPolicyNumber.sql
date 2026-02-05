SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE dbo.SpCustomValuationsGetAllWrapperPolicyNumber
@ValScheduleId int
AS

BEGIN

       SET NOCOUNT ON
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   select distinct PolicyNumber
			from TValScheduledPlan sp 
				join TWrapperPolicyBusiness wp on sp.PolicyBusinessId = wp.ParentPolicyBusinessId
				join TValPotentialPlan pp on wp.ParentPolicyBusinessId = pp.PolicyBusinessId
			where coalesce(PolicyNumber,'') <> '' and sp.ValScheduleId = @ValScheduleId  and sp.[Status] = 1 

  SET NOCOUNT OFF

END
GO
