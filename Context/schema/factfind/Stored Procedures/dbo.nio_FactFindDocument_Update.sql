SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_FactFindDocument_Update]
	@StampUser varchar(255),
	@IndigoClientId bigint,
	@FactFindDocumentId bigint,
	@FileSize int,
	@Full bit,
	@CRMContactId2 bigint = 0,
	@BinderId bigint = -1, -- -1 = not selected, 0 = new, > 0 = existing binder.
	@NewBinderName varchar(255) = '',
	@ServiceCaseId bigint = 0,
	@CurrentUserDate datetime
AS
DECLARE @Id bigint, @DocVersionId bigint, @OldFileSize int, @DocStorageId bigint,
	@DocumentId bigint, @DocumentOwnerId bigint, @PrimaryClientId bigint, @ChangeInFileSize bigint

----------------------------------------------------------------------
-- Get document details
----------------------------------------------------------------------
SELECT
	@OldFileSize = Dv.FileSize,
	@DocVersionId = Dv.DocVersionId,
	@DocumentId = Dv.DocumentId,
	@PrimaryClientId = Ffd.CRMContactId
FROM
	TFactFindDocument Ffd WITH(NOLOCK)
	JOIN DocumentManagement..TDocVersion Dv WITH(NOLOCK) ON Dv.DocVersionId = Ffd.DocVersionId
WHERE
	Ffd.FactFindDocumentId = @FactFindDocumentId

----------------------------------------------------------------------
-- Update Fact Find Document
----------------------------------------------------------------------
EXEC SpNAuditFactFindDocument @StampUser, @FactFindDocumentId, 'U'

UPDATE
	TFactFindDocument
SET
	CreatedDate = GETDATE(),
	IsFull = @Full,
	ConcurrencyId = ConcurrencyId + 1
WHERE
	FactFindDocumentId = @FactFindDocumentId

----------------------------------------------------------------------
-- Update doc version
----------------------------------------------------------------------
EXEC [DocumentManagement].[dbo].SpNAuditDocVersion @StampUser, @DocVersionId, 'U'

UPDATE
	DocumentManagement..TDocVersion
SET
	FileSize = @FileSize,
	CreatedDate = SYSUTCDATETIME(),
	LastUpdatedDate = SYSUTCDATETIME(),
	LastAction = 'Updated',
	ConcurrencyId = ConcurrencyId + 1
WHERE
	DocVersionId = @DocVersionId

----------------------------------------------------------------------
-- Delete any owners not in the current owner set
----------------------------------------------------------------------
SELECT DocumentOwnerId, CRMContactId
INTO #Owners
FROM DocumentManagement..TDocumentOwner WITH(NOLOCK)
WHERE DocumentId = @DocumentId

SELECT DocumentOwnerId AS Id
INTO #OwnersToDelete
FROM #Owners
WHERE CRMContactId NOT IN (@PrimaryClientId, @CRMContactId2)

IF EXISTS (SELECT 1 FROM #OwnersToDelete) BEGIN
	INSERT INTO DocumentManagement..TDocumentOwnerAudit (
		DocumentId, CRMContactId, IndigoClientId, ConcurrencyId, DocumentOwnerId, StampAction, StampDateTime, StampUser)
	SELECT
		A.DocumentId, A.CRMContactId, A.IndigoClientId, A.ConcurrencyId, A.DocumentOwnerId, 'D', GETDATE(), @StampUser
	FROM
		DocumentManagement..TDocumentOwner A
		JOIN #OwnersToDelete ON #OwnersToDelete.Id = A.DocumentOwnerId

	DELETE A
	FROM
		DocumentManagement..TDocumentOwner A
		JOIN #OwnersToDelete ON #OwnersToDelete.Id = A.DocumentOwnerId
END

----------------------------------------------------------------------
-- Make sure that we add second owner if they are not listed
----------------------------------------------------------------------
IF @CRMContactId2 > 0 AND NOT EXISTS (SELECT 1 FROM #Owners WHERE CRMContactId = @CRMContactId2)
BEGIN
	INSERT INTO DocumentManagement..TDocumentOwner (DocumentId, CRMContactId, IndigoClientId)
	VALUES (@DocumentId, @CRMContactId2, @IndigoClientId)

	SET @DocumentOwnerId = SCOPE_IDENTITY()
	EXEC [DocumentManagement].[dbo].SpNAuditDocumentOwner @StampUser, @DocumentOwnerId, 'C'
END

----------------------------------------------------------------------
-- Manage Binders, check that binder link doesn't already exist
----------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM DocumentManagement..TBinderDocument WITH(NOLOCK) WHERE DocVersionId = @DocVersionId And BinderId = @BinderId)
	EXEC SpNCustomCreateDocumentBinderLink @StampUser, @PrimaryClientId, @CRMCOntactId2, @DocVersionId, @BinderId, @NewBinderName, @CurrentUserDate

----------------------------------------------------------------------
-- Link document to service case
----------------------------------------------------------------------
EXEC SpNCustomCreateDocumentToServiceCaseLink @StampUser, @DocumentId, @ServiceCaseId

----------------------------------------------------------------------
-- Update document storage
----------------------------------------------------------------------
-- Get Doc Store Type
DECLARE @DocStoreType tinyint
SELECT @DocStoreType = DocStoreType FROM Administration..TTenantDocumentStoreConfig WITH(NOLOCK) WHERE TenantId = @IndigoClientId
SELECT @DocStoreType = ISNULL(@DocStoreType, 0)

SET @ChangeInFileSize = ISNULL(@FileSize, 0) - ISNULL(@OldFileSize, 0)

If @DocStoreType != 1 AND @ChangeInFileSize != 0 BEGIN
	SELECT @DocStorageId = DocStorageId
	FROM DocumentManagement..TDocStorage WITH(NOLOCK)
	WHERE IndigoClientId = @IndigoClientId

	EXEC [DocumentManagement].[dbo].SpNAuditDocStorage @StampUser, @DocStorageId, 'U'

	UPDATE
		DocumentManagement..TDocStorage
	SET
		SpaceUsed = SpaceUsed + @ChangeInFileSize,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		DocStorageId = @DocStorageId
END
GO
