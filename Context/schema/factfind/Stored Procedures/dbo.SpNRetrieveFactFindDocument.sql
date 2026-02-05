SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFactFindDocument]
	@FactFindDocumentId bigint
AS

SELECT T1.FactFindDocumentId, T1.FactFindDocumentTypeId, T1.DocVersionId, T1.CrmContactId, T1.CreatedDate, T1.Creator, T1.ConcurrencyId
FROM TFactFindDocument  T1
WHERE T1.FactFindDocumentId = @FactFindDocumentId

GO
