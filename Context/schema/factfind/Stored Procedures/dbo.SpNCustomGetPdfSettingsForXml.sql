SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPdfSettingsForXml]
	@TenantId bigint
AS
SELECT * 
FROM TPdfSettings
WHERE TenantId = @TenantId
FOR XML RAW('PdfSettings')
GO
