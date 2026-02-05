SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_AdviceCase]
  @PolicyBusinessId bigint,
  @ResponseCode varchar(512) output
AS

BEGIN
	-- make sure the plan is linked to an service case - formerly advice case
	-- IO-9265 Pt 1 - where the case/s are not closed.
	if
	(	
	SELECT COUNT(A.AdviceCaseId) FROM CRM..TAdviceCasePlan A
		INNER JOIN 
		(
			--THis gets the latest status - do not check the autoclsoe here as it might mean picking a status that is not the latest.
			SELECT MAX(AdviceCaseHistoryId) AS AdviceCaseHistoryId, A.AdviceCaseId 
			FROM CRM..TAdviceCaseHistory A
			INNER JOIN CRM..TAdviceCasePlan C ON A.AdviceCaseId = C.AdviceCaseId
			WHERE C.PolicyBusinessId = @PolicyBusinessId
			GROUP BY A.AdviceCaseId 
			
		) B ON A.AdviceCaseId = B.AdviceCaseId
		INNER JOIN CRM..TAdviceCaseHistory C ON B.AdviceCaseHistoryId = C.AdviceCaseHistoryId -- join on latest status primary key
		INNER JOIN CRM..TAdviceCaseStatus D ON C.StatusId = D.AdviceCaseStatusId -- Check the status details
		WHERE PolicyBusinessId = @PolicyBusinessId
		AND D.IsAutoClose = 0 -- must not be autoclosed.
		AND D.IsComplete=0
	) = 0
	begin
		select @ResponseCode = 'SERVICECASE'  
	end
END

GO
