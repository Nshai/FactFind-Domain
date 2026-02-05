SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveDraftVersion]  
 @CrmContactId bigint,  
 @FactFindDocumentTypeId bigint = 1  
AS  
SELECT   
	f.FactFindDocumentId,  
	d.DocVersionId,d.Version,d.FileName
FROM   
	TFactFindDocument f  
	JOIN DocumentManagement..TDocVersion d on d.DocVersionId = f.DocVersionId  
	JOIN (
		SELECT  
			MAX(DocVersionId) DocVersionId,  
			DocumentId  
		FROM    
			DocumentManagement..TDocVersion  
		GROUP BY DocumentId) AS MaxVersion ON MaxVersion.DocumentId = d.DocumentId  
	JOIN DocumentManagement..TDocVersion LastVersion on LastVersion.DocVersionId = MaxVersion.DocVersionId         
WHERE   
	f.CrmContactId = @CrmContactId  
	AND f.FactFindDocumentTypeId = @FactFindDocumentTypeId  
	AND LastVersion.Status = 'Draft'  
GO
