SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateExtraRiskQuestionAnswer]
	@RefRiskQuestionId bigint,
	@CRMContactId bigint,
	@Answer int,
	@StampUser varchar(255), 
	@Comment varchar(5000)
AS
DECLARE @ExtraRiskQuestionAnswerId bigint

-- Find existing answer
SELECT @ExtraRiskQuestionAnswerId = ExtraRiskQuestionAnswerId
FROM TExtraRiskQuestionAnswer
WHERE	
	CRMContactId = @CRMContactId and
	RefRiskQuestionId = @RefRiskQuestionId

-- If answer has been reset then delete existing
IF @Answer = -1 BEGIN
	IF @ExtraRiskQuestionAnswerId IS NOT NULL BEGIN	
		EXEC SpNAuditExtraRiskQuestionAnswer @ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId, @StampUser = @StampUser, @StampAction = 'D'
		DELETE FROM TExtraRiskQuestionAnswer WHERE ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId
	END
			
	RETURN;
END

-- Has question been answered?
IF @ExtraRiskQuestionAnswerId IS NULL BEGIN	
	-- No, add new
	INSERT INTO TExtraRiskQuestionAnswer (RefRiskQuestionId, CRMContactId, Answer, ConcurrencyId, Comment)
	VALUES(@RefRiskQuestionId, @CRMContactId, @Answer, 1, @Comment)

	SET @ExtraRiskQuestionAnswerId = SCOPE_IDENTITY()
	EXEC SpNAuditExtraRiskQuestionAnswer @ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId, @StampUser = @StampUser, @StampAction = 'C'
END
ELSE BEGIN
	-- Yes, update existing answer.
	EXEC SpNAuditExtraRiskQuestionAnswer @ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId, @StampUser = @StampUser, @StampAction = 'U'
	
	UPDATE TExtraRiskQuestionAnswer
	SET	Answer = @Answer,
		Concurrencyid = Concurrencyid + 1,
		Comment = @Comment
	WHERE ExtraRiskQuestionAnswerId = @ExtraRiskQuestionAnswerId
END	
GO
