SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveNationalityAsXml]
AS
SELECT
RefNationalityId,
Name,
IsArchived
FROM
CRM..TRefNationality
ORDER BY 
CASE WHEN Name IN ('British', 'Manx', 'Scottish', 'Welsh', 'Northern Irish') THEN 0 ELSE 1 END,
Name
FOR XML RAW('Nationality')
GO
