SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveATRAdditionalQuestionAndAnswers]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint
AS

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155

IF OBJECT_ID('tempdb..#AdditionalQuestionAndAnswers') IS NOT NULL
	DROP TABLE #AdditionalQuestionAndAnswers

SELECT 
		IQ.IsRetirement AS IsRetirement,
		Q.AdditionalRiskQuestionId QuestionId,
		IQ.QuestionNumber QuestionNumber,
		Q.QuestionText QuestionDescription,
		IQ.CRMContactId,
		IQ.ResponseId Answer,
		IQ.ResponseText Notes,		
		(CASE WHEN ISNULL(IQ.CRMContactId, 0) = @PartyId
		THEN 1 ELSE 0 END) AS ISPrimaryParty	
INTO #AdditionalQuestionAndAnswers
FROM factfind..TAdditionalRiskQuestionResponse IQ
	INNER JOIN factfind..TAdditionalRiskQuestion Q ON Q.QuestionNumber = IQ.QuestionNumber and Q.TenantId = IQ.TenantId 	
WHERE IQ.CRMContactId IN (@PartyId, @RelatedPartyId) AND IQ.TenantId = @TenantId 	


SELECT 
		P1.IsRetirement IsRetirementQuestion,
		P1.QuestionId as QuestionId, 
		P1.QuestionNumber,
		P1.QuestionDescription,		 
		P1.CRMContactId PartyId, 
		P1.Answer ClientAnswer, 
		P1.Notes ClientNotes, 
		P2.CRMContactId RelatedPartyId, 
		P2.Answer PartnerAnswer, 
		P2.Notes  PartnerNotes
	
FROM #AdditionalQuestionAndAnswers P1
	LEFT JOIN #AdditionalQuestionAndAnswers P2 ON P1.QuestionId = P2.QuestionId 
		AND P1.CRMContactId <> P2.CRMContactId AND P1.IsRetirement = P2.IsRetirement
WHERE P1.ISPrimaryParty = 1 
ORDER BY QuestionNumber ASC


