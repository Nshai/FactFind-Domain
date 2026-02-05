SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveLumpSumTypes]
AS
SELECT 1 AS TAG,
	NULL AS Parent,
	LS.RefLumpsumAtRetirementTypeId AS [RefLumpsumAtRetirementType!1!LumpsumAtRetirementTypeId],
	LS.TypeName AS [RefLumpsumAtRetirementType!1!LumpsumAtRetirementType]
FROM TRefLumpsumAtRetirementType LS
ORDER BY [RefLumpsumAtRetirementType!1!LumpsumAtRetirementTypeId]
FOR XML EXPLICIT
GO
