SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateExtraRiskQuestionAnswers]
	@AnswersInXml XML,
	@StampUser VARCHAR(255)
AS

IF OBJECT_ID('tempdb..#Answers') IS NOT NULL
	DROP TABLE #Answers;

CREATE TABLE #Answers (
	ExtraRiskQuestionAnswerId BIGINT,
	RefRiskQuestionId BIGINT,
	CRMContactId BIGINT,
	Answer INT,
	Comment VARCHAR(5000)
);

DECLARE @HDoc INT;

EXEC factfind.dbo.sp_xml_preparedocument @HDoc OUTPUT, @AnswersInXml;

INSERT INTO #Answers(ExtraRiskQuestionAnswerId, RefRiskQuestionId, CRMContactId, Answer, Comment)
SELECT NULL, RefRiskQuestionId, CRMContactId, CAST(NULLIF(Answer, '') AS INT), NULLIF(Comment, '')
FROM OPENXML (@HDoc, '/Answers/Answer' , 1)
WITH (
	RefRiskQuestionId BIGINT,
	CRMContactId BIGINT,
	Answer VARCHAR(10),
	Comment VARCHAR(5000)
);

EXEC factfind.dbo.sp_xml_removedocument @HDoc;

UPDATE A
SET ExtraRiskQuestionAnswerId = ERQA.ExtraRiskQuestionAnswerId
FROM #Answers A
LEFT JOIN factfind.dbo.TExtraRiskQuestionAnswer ERQA
	ON ERQA.RefRiskQuestionId = A.RefRiskQuestionId AND ERQA.CRMContactId = A.CRMContactId;

DELETE ERQA
OUTPUT
	DELETED.ExtraRiskQuestionAnswerId,
	DELETED.RefRiskQuestionId,
	DELETED.CRMContactId,
	DELETED.Answer,
	DELETED.Comment,
	DELETED.ConcurrencyId,
	'D',
	GETDATE(),
	@StampUser
INTO factfind.dbo.TExtraRiskQuestionAnswerAudit(
	ExtraRiskQuestionAnswerId,
	RefRiskQuestionId,
	CRMContactId,
	Answer,
	Comment,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
FROM factfind.dbo.TExtraRiskQuestionAnswer ERQA
INNER JOIN #Answers A ON ERQA.ExtraRiskQuestionAnswerId = A.ExtraRiskQuestionAnswerId AND A.Answer = -1;

INSERT INTO factfind.dbo.TExtraRiskQuestionAnswer(RefRiskQuestionId, CRMContactId, Answer, ConcurrencyId, Comment)
OUTPUT
	INSERTED.ExtraRiskQuestionAnswerId,
	INSERTED.RefRiskQuestionId,
	INSERTED.CRMContactId,
	INSERTED.Answer,
	INSERTED.Comment,
	INSERTED.ConcurrencyId,
	'C',
	GETDATE(),
	@StampUser
INTO factfind.dbo.TExtraRiskQuestionAnswerAudit(
	ExtraRiskQuestionAnswerId,
	RefRiskQuestionId,
	CRMContactId,
	Answer,
	Comment,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
SELECT A.RefRiskQuestionId, A.CRMContactId, A.Answer, 1, A.Comment
FROM #Answers A
WHERE A.ExtraRiskQuestionAnswerId IS NULL;

UPDATE ERQA
SET
	Answer = A.Answer,
	Comment = A.Comment,
	ConcurrencyId = ConcurrencyId + 1
OUTPUT
	DELETED.ExtraRiskQuestionAnswerId,
	DELETED.RefRiskQuestionId,
	DELETED.CRMContactId,
	DELETED.Answer,
	DELETED.Comment,
	DELETED.ConcurrencyId,
	'U',
	GETDATE(),
	@StampUser
INTO factfind.dbo.TExtraRiskQuestionAnswerAudit(
	ExtraRiskQuestionAnswerId,
	RefRiskQuestionId,
	CRMContactId,
	Answer,
	Comment,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
FROM factfind.dbo.TExtraRiskQuestionAnswer ERQA
INNER JOIN #Answers A ON ERQA.ExtraRiskQuestionAnswerId = A.ExtraRiskQuestionAnswerId AND A.Answer <> -1
WHERE
	NOT ((ERQA.Answer IS NULL AND A.Answer IS NULL) OR (ERQA.Answer IS NOT NULL AND A.Answer IS NOT NULL AND ERQA.Answer = A.Answer))
	OR NOT ((ERQA.Comment IS NULL AND A.Comment IS NULL) OR (ERQA.Comment IS NOT NULL AND A.Comment IS NOT NULL AND ERQA.Comment = A.Comment));

GO
