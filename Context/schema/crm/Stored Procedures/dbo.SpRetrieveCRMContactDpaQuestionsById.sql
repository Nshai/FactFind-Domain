SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveCRMContactDpaQuestionsById]
	@CRMContactDpaQuestionsId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CRMContactDpaQuestionsId AS [CRMContactDpaQuestions!1!CRMContactDpaQuestionsId], 
	T1.CRMContactId AS [CRMContactDpaQuestions!1!CRMContactId], 
	T1.Mail AS [CRMContactDpaQuestions!1!Mail], 
	T1.Telephone AS [CRMContactDpaQuestions!1!Telephone], 
	T1.Email AS [CRMContactDpaQuestions!1!Email], 
	T1.Sms AS [CRMContactDpaQuestions!1!Sms], 
	T1.OtherMail AS [CRMContactDpaQuestions!1!OtherMail], 
	T1.OtherTelephone AS [CRMContactDpaQuestions!1!OtherTelephone], 
	T1.OtherEmail AS [CRMContactDpaQuestions!1!OtherEmail], 
	T1.OtherSms AS [CRMContactDpaQuestions!1!OtherSms], 
	T1.ConcurrencyId AS [CRMContactDpaQuestions!1!ConcurrencyId]
	FROM TCRMContactDpaQuestions T1
	
	WHERE T1.CRMContactDpaQuestionsId = @CRMContactDpaQuestionsId
	ORDER BY [CRMContactDpaQuestions!1!CRMContactDpaQuestionsId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
