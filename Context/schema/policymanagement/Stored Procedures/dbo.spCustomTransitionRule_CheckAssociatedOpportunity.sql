SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckAssociatedOpportunity]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

BEGIN
	
	--make sure the plan is linked to an opportunity
	if(select count(OpportunityId) from CRM..TOpportunityPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId) = 0
	begin
		select @ErrorMessage = 'OPPORTUNITY'  
	end
	
END



GO
