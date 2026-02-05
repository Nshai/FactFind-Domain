SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntegratedSystemDocumentMapping]
	@StampUser varchar (255),
	@IntegratedSystemDocumentMappingId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntegratedSystemDocumentMappingAudit 
( 
	ApplicationLinkId, IsSaveDocuments, DocumentCategoryId, DocumentSubCategoryId,
	ConcurrencyId, IntegratedSystemDocumentMappingId, StampAction, StampDateTime, StampUser) 

Select ApplicationLinkId, IsSaveDocuments, DocumentCategoryId, DocumentSubCategoryId, 
		ConcurrencyId, IntegratedSystemDocumentMappingId, @StampAction, GetDate(), @StampUser
FROM TIntegratedSystemDocumentMapping
WHERE IntegratedSystemDocumentMappingId = @IntegratedSystemDocumentMappingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
