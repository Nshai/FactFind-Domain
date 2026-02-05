SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveDocumentDisclosureTypeAsXml]
	@IndigoClientId bigint,
	@ExcludeArchived bit = 0
AS
SELECT
	DocumentDisclosureTypeId AS Id,
	Name	
FROM
	TDocumentDisclosureType
WHERE
	IndigoClientId = @IndigoClientId
	AND NOT (@ExcludeArchived = 1 AND [IsArchived] = 1)
ORDER BY [Name]
FOR XML RAW('Type')
		
	
GO
