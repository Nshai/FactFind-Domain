SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateOrUpdatePlanAdditionalNotes]
	@PolicyBusinessId int,
	@AdditionalNotes varchar(1000),
	@StampUser varchar(255)
AS
DECLARE @PolicyBusinessExtId int, @ExistingNotes varchar(1000)

-- Find PolicyBusinessExtended information
SELECT @PolicyBusinessExtId = PolicyBusinessExtId, @ExistingNotes = AdditionalNotes
FROM PolicyManagement..TPolicyBusinessExt
WHERE PolicyBusinessId = @PolicyBusinessId

-- Create Notes
IF @PolicyBusinessExtId IS NULL BEGIN
	INSERT INTO PolicyManagement..TPolicyBusinessExt (PolicyBusinessId, AdditionalNotes)
	VALUES (@PolicyBusinessId, @AdditionalNotes)

	SET @PolicyBusinessExtId = SCOPE_IDENTITY()
	EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'C'
END
-- Update Notes
ELSE IF ISNULL(@ExistingNotes, '') != ISNULL(@AdditionalNotes, '') BEGIN 
	EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U'

	UPDATE A
	SET AdditionalNotes = @AdditionalNotes
	FROM PolicyManagement..TPolicyBusinessExt A
	WHERE PolicyBusinessExtId = @PolicyBusinessExtId
END
GO
