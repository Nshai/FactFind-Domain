SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUpdateDocumentStatus]
	@StampUser varchar(255),
	@FactFindDocumentId bigint,
	@Status varchar(16)
AS
BEGIN

DECLARE @tx int, @Id bigint, @DocVersionId bigint

SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	-- Get document details
	SELECT 
		@DocVersionId = Dv.DocVersionId
	FROM
		TFactFindDocument Ffd
		JOIN DocumentManagement..TDocVersion Dv ON Dv.DocVersionId = Ffd.DocVersionId
	WHERE
		Ffd.FactFindDocumentId = @FactFindDocumentId

	IF @@ERROR != 0 GOTO errh

	INSERT INTO [DocumentManagement].[dbo].[TDocVersionAudit](
		[DocumentId], [FileExtension], [FileName], [FileSize], [Version], [DocumentData], 
		[CRMContactId], [CreatedDate], [CreatedByUserId], [LastUpdatedDate], [LastUserId], [CheckedOutByUserId], 
		[CheckOutDate], [CheckOutReason], [CheckInDate], [IndigoClientId], [Status], [LastAction], [Archived], 
		[Locked], [FolderId], [OriginalFileName], [IsUrl], [IsAllocationChanged], [ConcurrencyId], [DocVersionId],
		StampAction, StampDatetime, StampUser, [CreatedByAppId])
	SELECT
		[DocumentId], [FileExtension], [FileName], [FileSize], [Version], [DocumentData], 
		[CRMContactId], [CreatedDate], [CreatedByUserId], [LastUpdatedDate], [LastUserId], [CheckedOutByUserId], 
		[CheckOutDate], [CheckOutReason], [CheckInDate], [IndigoClientId], [Status], [LastAction], [Archived], 
		[Locked], [FolderId], [OriginalFileName], [IsUrl], [IsAllocationChanged], [ConcurrencyId], [DocVersionId], 
		'U', GETDATE(), @StampUser, [CreatedByAppId]
	FROM 
		DocumentManagement..TDocVersion
	WHERE 
		DocVersionId = @DocVersionId

	IF @@ERROR != 0 GOTO errh

	UPDATE 
		DocumentManagement..TDocVersion
	SET
		Status = @Status,
		LastUpdatedDate = GETDATE(),
		LastAction = 'Updated',
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		DocVersionId = @DocVersionId

	-- FF Documents with changed status must be processed by Transform Engine
	IF EXISTS (
		SELECT 1 FROM documentmanagement..TRefDocumentStatus
		WHERE [Description] = @Status AND FactFindStatusFg = 1
	)
	BEGIN
		INSERT INTO SDB.dbo.TChangeLog (Action, TableName, PKColumn, PKValue)  
		VALUES('U' , 'TFactFindDocument','FactFindDocumentId', Convert(varchar(1024), @FactFindDocumentId))
	END

	IF @@ERROR != 0 GOTO errh
	IF @tx = 0 COMMIT TRANSACTION TX		
END

RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

END
GO
