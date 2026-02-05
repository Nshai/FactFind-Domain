SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateDocumentBinderLink]
	@StampUser varchar(255),
	@CRMContactId bigint,
	@CRMContactId2 bigint,
	@DocVersionId bigint,
	@BinderId bigint = -1, -- -1 = not selected, 0 = new, > 0 = existing binder.
	@NewBinderName varchar(255) = '',
	@CurrentUserDate datetime
AS
DECLARE @RefBinderStatusId bigint, @BinderDocumentId bigint, @IsNewBinder bit = 0
-- If binder is 0 that means create new
IF @BinderId = 0 SET @IsNewBinder = 1

-- Check that binder information is valid
IF @BinderId < 0 OR (@IsNewBinder = 1 AND LEN(@NewBinderName) = 0)
	RETURN;

-- Second owner should have a value or null.
IF @CRMContactId2 = 0 SET @CRMContactId2 = NULL

-- Create new binder?
IF @IsNewBinder = 1 BEGIN
	-- Get binder status
	SELECT @RefBinderStatusId = RefBinderStatusId
	FROM Documentmanagement..TRefBinderStatus
	WHERE DefaultStatusFg = 1

	INSERT INTO Documentmanagement..TBinder ([Description], CRMContactId, RefBinderStatusId, ConcurrencyId, Owner2PartyId)
	VALUES (@NewBinderName, @CRMContactId, @RefBinderStatusId, 1, @CRMContactId2)
	-- Get id and audit
	SET @BinderId = SCOPE_IDENTITY()
	EXEC Documentmanagement..SpNAuditBinder @StampUser, @BinderId, 'C'

	EXEC DocumentManagement..SpCreateBinderStatusHistory @StampUser, @BinderId, @RefBinderStatusId, @CurrentUserDate, @StampUser
END

-- Link document to binder
INSERT INTO Documentmanagement..TBinderDocument (BinderId, DocVersionId)
VALUES (@BinderId, @DocVersionId)
-- Get id and audit
SET @BinderDocumentId = SCOPE_IDENTITY()
EXEC Documentmanagement..SpNAuditBinderDocument @StampUser, @BinderDocumentId, 'C'
GO
