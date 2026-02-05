SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAtrTemplateById]
	@AtrTemplateId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.AtrTemplateId AS [AtrTemplate!1!AtrTemplateId], 
	ISNULL(T1.Identifier, '') AS [AtrTemplate!1!Identifier], 
	ISNULL(T1.Descriptor, '') AS [AtrTemplate!1!Descriptor], 
	T1.Active AS [AtrTemplate!1!Active], 
	T1.HasModels AS [AtrTemplate!1!HasModels], 
	ISNULL(CONVERT(VARCHAR(36), T1.BaseAtrTemplate), '') AS [AtrTemplate!1!BaseAtrTemplate], 
	T1.IndigoClientId AS [AtrTemplate!1!IndigoClientId], 
	T1.Guid AS [AtrTemplate!1!Guid], 
	T1.ConcurrencyId AS [AtrTemplate!1!ConcurrencyId]
	FROM TAtrTemplate T1
	
	WHERE T1.AtrTemplateId = @AtrTemplateId
	ORDER BY [AtrTemplate!1!AtrTemplateId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
