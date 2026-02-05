SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveATRQuestionAndAnswers]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint,
	@AnswerSplitPattern NVARCHAR(255) = '####'
AS


--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155
--DECLARE @AnswerSplitPattern NVARCHAR(255) = '#^#'

IF OBJECT_ID('tempdb..#QuestionAndAnswers') IS NOT NULL
	DROP TABLE #QuestionAndAnswers

SELECT DISTINCT
		CAST(1 AS BIT) AS ProfileType,
		IQ.AtrQuestionGuid QuestionGuid,
		Q.AtrQuestionId QuestionId ,
		Q.[Description] QuestionDescription,
		IQ.CRMContactId,
		a.[Description] Answer,
		IQ.FreeTextAnswer,
		Q.Ordinal,
		(CASE WHEN ISNULL(IQ.CRMContactId, 0) = @PartyId
		THEN 1 ELSE 0
		END) AS ISPrimaryParty,
		Convert(varchar(max), '') Answers
INTO #QuestionAndAnswers
FROM factfind..TAtrInvestment IQ
	INNER JOIN factfind..TAtrQuestionCombined Q ON Q.[Guid] = IQ.AtrQuestionGuid AND q.Active = 1
	INNER JOIN factfind..TAtrTemplateCombined TC ON ISNULL(TC.BaseAtrTemplate, TC.Guid) = Q.AtrTemplateGuid AND TC.Active = 1 	
	LEFT JOIN factfind..TAtrAnswer a ON IQ.AtrAnswerGuid = a.[Guid]
WHERE IQ.CRMContactId IN (@PartyId, @RelatedPartyId) AND TC.IndigoClientId = @TenantId 

UNION

SELECT DISTINCT
		CAST(0 AS BIT) AS ProfileType,
		RQ.AtrQuestionGuid QuestionGuid,
		Q.AtrQuestionId QuestionId ,
		Q.[Description] QuestionDescription,
		RQ.CRMContactId,
		a.[Description] Answer,
		RQ.FreeTextAnswer,
		Q.Ordinal,
		(CASE WHEN ISNULL(RQ.CRMContactId, 0) = @PartyId
		THEN 1 ELSE 0
		END) AS ISPrimaryParty,
		Convert(varchar(max), '') Answers
FROM factfind..TAtrRetirement RQ
	INNER JOIN factfind..TAtrQuestionCombined Q ON Q.[Guid] = RQ.AtrQuestionGuid  AND q.Active = 1	
	INNER JOIN factfind..TAtrTemplateCombined TC ON ISNULL(TC.BaseAtrTemplate, TC.Guid) = Q.AtrTemplateGuid AND TC.Active = 1 	
	LEFT JOIN factfind..TAtrAnswer a ON RQ.AtrAnswerGuid = a.[Guid] 
WHERE RQ.CRMContactId IN (@PartyId, @RelatedPartyId) AND TC.IndigoClientId = @TenantId

UPDATE a
SET Answers = CONVERT(VARCHAR(MAX), 
(
	SELECT @AnswerSplitPattern +  ans.[Description] 
	from factfind..TAtrAnswer ans	
	Where ISNULL(ans.[Description], '') <> '' and ans.AtrQuestionGuid = a.QuestionGuid
	order by ans.Ordinal asc
	for xml path(''), type
))
From #QuestionAndAnswers a
WHERE a.ISPrimaryParty = 1

SELECT 
		P1.ProfileType IsInvestmentQuestion,
		P1.QuestionGuid as QuestionGuid, 
		P1.QuestionId,
		P1.QuestionDescription,
		P1.Ordinal, 
		P1.CRMContactId PartyId, 
		P1.Answer Client1Answer, 
		P1.FreeTextAnswer Client1FreeTextAnswer, 
		P2.CRMContactId RelatedPartyId, 
		P2.Answer Client2Answer, 
		P2.FreeTextAnswer  Client2FreeTextAnswer,
		CASE WHEN P1.ProfileType = 1
		THEN (SELECT TOP 1 Client2AgreesWithAnswers FROM factfind..TAtrInvestmentGeneral
					WHERE CRMContactId = @PartyId
					ORDER BY 1 DESC)
		ELSE (SELECT TOP 1 Client2AgreesWithAnswers FROM factfind..TAtrRetirementGeneral
					WHERE CRMContactId = @PartyId
					ORDER BY 1 DESC)
		END	Client2AgreesWithAnswers,
		P1. Answers
	
FROM #QuestionAndAnswers P1
	LEFT JOIN #QuestionAndAnswers P2 ON P1.QuestionGuid = P2.QuestionGuid 
		 AND P1.ProfileType = P2.ProfileType
		 AND P1.CRMContactId <> P2.CRMContactId
WHERE P1.ISPrimaryParty = 1 
ORDER BY Ordinal ASC

GO