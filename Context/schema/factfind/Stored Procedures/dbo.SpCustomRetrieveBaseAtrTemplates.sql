SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveBaseAtrTemplates]
	@IndigoClientId bigint
AS

DECLARE @IndigoClientGuid uniqueidentifier

SELECT 
	@IndigoClientGuid = [Guid]
FROM
	Administration..TIndigoClient
WHERE
	IndigoClientID = @IndigoClientId

-- List of distinct template providers for this client
SELECT
	A.Guid,
	I.Identifier + ' - ' + A.Identifier AS Identifier
FROM
	Administration..TIndigoClientCombined I
	JOIN TAtrTemplateCombined A ON A.IndigoClientGuid = I.Guid
	JOIN Administration..TIndigoClientPreferenceCombined P ON P.[Value] = I.Guid
WHERE
	I.IsAtrProvider = 1
	AND P.IndigoClientGuid = @IndigoClientGuid
	AND P.PreferenceName = 'AtrProfileProvider'
ORDER BY
	Identifier
FOR
	XML RAW
GO
