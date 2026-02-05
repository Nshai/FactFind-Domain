SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLinkedDocuments]
	@TenantId bigint,
	@CRMContactType tinyint
AS
SELECT
	A.LinkedDocumentId,C.DocVersionId,B.DocumentId,B.Descriptor,C.Version,C.LastUpdatedDate,C.Status
FROM 
	FactFind..TLinkedDocument A
	JOIN TFactFindType FFT ON FFT.FactFindTypeId = A.FactFindTypeId
	JOIN DocumentManagement..TDocument B ON A.DocumentId=B.DocumentId
	JOIN (
		SELECT 
			MAX(DocVersionId) AS DocVersionId, DocumentId
		FROM 
			DocumentManagement..TDocVersion 
		WHERE
			IndigoClientId = @TenantId
		GROUP BY DocumentId) AS Latest ON B.DocumentId = Latest.DocumentId
	JOIN DocumentManagement..TDocVersion C ON Latest.DocVersionId=C.DocVersionId
	JOIN DocumentManagement..TFolder TF ON TF.FolderId=C.FolderId
WHERE 
	FFT.IndigoClientId = @TenantId
	AND C.IndigoClientId = @TenantId
	AND FFT.CRMContactType = @CRMContactType
GO
