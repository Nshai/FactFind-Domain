SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFileImportItem]
    @StampUser varchar (255),
    @FileImportItemId uniqueidentifier,
    @StampAction char(1)
AS

INSERT INTO TFileImportItemAudit 
( 
    FileImportHeaderId, 
    RowNumber, 
    RowData, 
    [Status], 
    DuplicateHash, 
    [Message], 
    SystemMessage, 
    CreatedId, 
    ResourceHref, 
    MigrationId, 
    FileImportItemId, 
    StampAction, 
    StampDateTime, 
    StampUser
 ) 
Select 
    FileImportHeaderId, 
    RowNumber, 
    RowData, 
    [Status], 
    DuplicateHash, 
    [Message], 
    SystemMessage, 
    CreatedId,
    ResourceHref, 
    MigrationId, 
    FileImportItemId, 
    @StampAction, 
    GetDate(), 
    @StampUser
FROM TFileImportItem
WHERE FileImportItemId = @FileImportItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)