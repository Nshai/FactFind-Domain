CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgageChecklistSubQuestionAnswer]
(
	@CRMContactId BIGINT,
	@CRMContactId2 BIGINT,
	@SubQuestionsIds NVARCHAR(MAX),
	@TenantId BIGINT
)
As
BEGIN
	DECLARE @IsContact2MainClient BIT = 0

	SELECT @IsContact2MainClient = 1
	WHERE EXISTS(
		SELECT * FROM factfind..TFactFind
		WHERE IndigoClientId = @TenantID
		AND CRMContactId1 = @CRMContactId2
		AND CRMContactId2 = @CRMContactId)

	SELECT
		q.MortgageChecklistQuestionId AS "ChecklistQuestionId",
		q.ParentQuestionId AS "ParentChecklistQuestionId",
		a.CRMContactId AS "PartyId",
		c.MortgageChecklistCategoryName AS "Category",
		q.Question AS "Question",
		a.Answer AS "Answer"
	FROM factFind..TMortgageChecklistQuestionAnswer AS a
	LEFT JOIN administration..TMortgageCheckListQuestion AS q
		ON a.MortgageChecklistQuestionId = q.MortgageChecklistQuestionId
	LEFT JOIN administration..TMortgageChecklistCategory AS c
		on c.MortgageChecklistCategoryId = q.MortgageChecklistCategoryId
	WHERE
		a.TenantId = @TenantId
		AND q.IsArchived = 0
		AND c.ArchiveFG = 0
		AND q.ParentQuestionId IN (SELECT * FROM dbo.FnGetIdsFromString(@SubQuestionsIds, ','))
		AND a.CRMContactId = CASE @IsContact2MainClient WHEN 1 THEN @CRMContactId2 ELSE @CRMContactId END
	ORDER BY q.Ordinal

END
