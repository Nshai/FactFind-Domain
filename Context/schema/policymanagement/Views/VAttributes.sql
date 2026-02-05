USE [policymanagement]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAttributes]

AS
	SELECT 
		ala.AttributeList2AttributeId,
		al.[Name] AS ListName,
		al.AttributeListId,
		a.[Value] AS [Value],
		a.AttributeId
	FROM TAttributeList2Attribute ala 
	INNER JOIN TAttributeList al ON al.[AttributeListId] = ala.[AttributeListId]
	LEFT  JOIN TAttribute a ON a.AttributeId = ala.AttributeId

GO