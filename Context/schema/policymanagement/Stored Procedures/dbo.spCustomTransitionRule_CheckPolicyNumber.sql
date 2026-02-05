SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPolicyNumber]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS


BEGIN

	--make sure that the plan has a policynumber
	DECLARE @PolicyNumber varchar(255)

	select @PolicyNumber = PolicyNumber 
	from TPolicyBusiness
	WHERE PolicyBusinessId = @PolicyBusinessId
	
	
	if(ISNULL(@PolicyNumber,'')= '')
	begin
		select @ErrorMessage = 'POLICYNUM'
	end

END







GO
