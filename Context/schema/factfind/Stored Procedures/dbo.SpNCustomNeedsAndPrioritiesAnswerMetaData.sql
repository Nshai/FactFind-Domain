SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomNeedsAndPrioritiesAnswerMetaData]
	@CrmContactId bigint, 
	@QuestionId bigint, 
	@AnswerId bigint = null,  -- -1 means that we are updating text.
	@FreeText varchar(max) = null,
	@StampUser varchar (255)
AS
DECLARE @NeedsAndPrioritiesAnswerId bigint

-- Try to find existing record for this question
SELECT @NeedsAndPrioritiesAnswerId = NeedsAndPrioritiesAnswerId
FROM TNeedsAndPrioritiesAnswer 
WHERE CRMContactId = @CrmContactId
And QuestionId = @QuestionId

IF @NeedsAndPrioritiesAnswerId IS NULL BEGIN	
	IF @AnswerId = -1 SET @AnswerId = NULL
	-- Add new question
	INSERT Into TNeedsAndPrioritiesAnswer(CRMContactId, QuestionId, AnswerId, FreeTextAnswer, ConcurrencyId)
	VALUES (@CrmContactId, @QuestionId, @AnswerId, @FreeText, 1)
	
	SELECT @NeedsAndPrioritiesAnswerId = SCOPE_IDENTITY()
	EXEC dbo.SpNAuditNeedsAndPrioritiesAnswer @StampUser, @NeedsAndPrioritiesAnswerId, 'C'
END	
ELSE BEGIN	
	-- Update existing question
	EXEC dbo.SpNAuditNeedsAndPrioritiesAnswer @StampUser, @NeedsAndPrioritiesAnswerId, 'U'
	
	-- -1 means that we are updating text
	IF @AnswerId = -1	
		UPDATE TNeedsAndPrioritiesAnswer
		SET FreeTextAnswer = @FreeText, ConcurrencyId = ConcurrencyId + 1
		WHERE NeedsAndPrioritiesAnswerId = @NeedsAndPrioritiesAnswerId	
	ELSE	
		UPDATE TNeedsAndPrioritiesAnswer
		SET AnswerId = @AnswerId, ConcurrencyId = ConcurrencyId + 1
		WHERE NeedsAndPrioritiesAnswerId = @NeedsAndPrioritiesAnswerId
END
RETURN (0)
GO
