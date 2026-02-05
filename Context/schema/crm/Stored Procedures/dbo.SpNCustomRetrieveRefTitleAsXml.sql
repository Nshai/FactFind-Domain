SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefTitleAsXml]
AS
SELECT
	TitleName AS [Name]
FROM 
	TRefTitle
ORDER BY 
	CASE 
		WHEN TitleName IN ('Mr', 'Miss', 'Ms', 'Mrs') THEN 0
		ELSE 1
	END,
	[Name]
FOR XML RAW('Title')
GO
