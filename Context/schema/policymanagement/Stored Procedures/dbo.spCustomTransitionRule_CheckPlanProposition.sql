SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPlanProposition]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS


BEGIN

	--make sure that the plan has a PropositionTypeId (if applicable)
	DECLARE @PropositionTypeId int

	select @PropositionTypeId = PropositionTypeId 
	from TPolicyBusiness
	WHERE PolicyBusinessId = @PolicyBusinessId
	
	if(ISNULL(@PropositionTypeId,'')= '')
	begin
		select @ErrorMessage = 'PLANPROPOSITION'
	end

END

GO
