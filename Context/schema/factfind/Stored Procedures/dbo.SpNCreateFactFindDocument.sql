SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFactFindDocument]
	@StampUser varchar (255),
	@FactFindDocumentTypeId bigint, 
	@DocVersionId bigint = NULL, 
	@CrmContactId bigint = NULL, 
	@CreatedDate datetime = getdate, 
	@Creator varchar(255),
	@Full bit = null
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @FactFindDocumentId bigint
			
	
	INSERT INTO TFactFindDocument
	(FactFindDocumentTypeId, DocVersionId, CrmContactId, CreatedDate, Creator, IsFull, ConcurrencyId)
	VALUES(@FactFindDocumentTypeId, @DocVersionId, @CrmContactId, @CreatedDate, @Creator, @Full, 1)

	SELECT @FactFindDocumentId = SCOPE_IDENTITY()

	INSERT INTO TFactFindDocumentAudit 
	(FactFindDocumentTypeId, DocVersionId, CrmContactId, CreatedDate, Creator, IsFull, ConcurrencyId,
		FactFindDocumentId, StampAction, StampDateTime, StampUser)
	SELECT  FactFindDocumentTypeId, DocVersionId, CrmContactId, CreatedDate, Creator, IsFull, ConcurrencyId,
		FactFindDocumentId, 'C', GetDate(), @StampUser
	FROM TFactFindDocument
	WHERE FactFindDocumentId = @FactFindDocumentId

	EXEC SpNRetrieveFactFindDocument @FactFindDocumentId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
