SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRelationshipById]
	@RelationshipId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RelationshipId AS [Relationship!1!RelationshipId], 
	ISNULL(T1.RefRelTypeId, '') AS [Relationship!1!RefRelTypeId], 
	ISNULL(T1.RefRelCorrespondTypeId, '') AS [Relationship!1!RefRelCorrespondTypeId], 
	T1.CRMContactFromId AS [Relationship!1!CRMContactFromId], 
	ISNULL(T1.CRMContactToId, '') AS [Relationship!1!CRMContactToId], 
	ISNULL(T1.ExternalContact, '') AS [Relationship!1!ExternalContact], 
	ISNULL(T1.ExternalURL, '') AS [Relationship!1!ExternalURL], 
	ISNULL(T1.OtherRelationship, '') AS [Relationship!1!OtherRelationship], 
	ISNULL(T1.IsPartnerFg, '') AS [Relationship!1!IsPartnerFg], 
	ISNULL(T1.IsFamilyFg, '') AS [Relationship!1!IsFamilyFg], 
	T1.ConcurrencyId AS [Relationship!1!ConcurrencyId]
	FROM TRelationship T1
	
	WHERE T1.RelationshipId = @RelationshipId
	ORDER BY [Relationship!1!RelationshipId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
