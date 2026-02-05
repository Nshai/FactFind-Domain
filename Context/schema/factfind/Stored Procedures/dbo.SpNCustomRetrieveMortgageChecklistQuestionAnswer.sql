CREATE PROCEDURE dbo.SpNCustomRetrieveMortgageChecklistQuestionAnswer
(
	@CRMContactId INT,
	@CRMContactId2 INT,
	@TenantId INT
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
		AND a.CRMContactId = CASE @IsContact2MainClient WHEN 1 THEN @CRMContactId2 ELSE @CRMContactId END
		AND q.IsArchived = 0
		AND c.ArchiveFG = 0
		AND (q.ParentQuestionId IS NULL OR q.ParentQuestionId = 0)
	ORDER BY c.MortgageChecklistCategoryName, q.Ordinal

END
