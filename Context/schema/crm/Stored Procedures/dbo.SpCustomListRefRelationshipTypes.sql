SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--drop procedure SpAliasGetRelationshipsforCRMContact

CREATE PROCEDURE [dbo].[SpCustomListRefRelationshipTypes]
AS
SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefRelationshipTypeId AS [RefRelationshipType!1!RefRelationshipTypeId], 
    ISNULL(T1.RelationshipTypeName, '') AS [RefRelationshipType!1!RelationshipTypeName], 
    --T1.IndClientId AS [RefRelationshipType!1!IndClientId], 
    ISNULL(T1.ArchiveFg, '') AS [RefRelationshipType!1!ArchiveFg], 
    ISNULL(T1.PersonFg, '') AS [RefRelationshipType!1!PersonFg], 
    ISNULL(T1.CorporateFg, '') AS [RefRelationshipType!1!CorporateFg], 
    ISNULL(T1.TrustFg, '') AS [RefRelationshipType!1!TrustFg], 
    CASE 
          WHEN T1.Extensible IS NULL THEN 0 
          WHEN T1.Extensible='' THEN 0 
          ELSE 1 
    END AS [RefRelationshipType!1!HasExtensible], 
    ISNULL(T1.Extensible, '<extxml/>') AS [RefRelationshipType!1!!xmltext], 
    T1.ConcurrencyId AS [RefRelationshipType!1!ConcurrencyId], 
    NULL AS [RefRelationshipTypeLink!2!RefRelationshipTypeLinkId], 
    NULL AS [RefRelationshipTypeLink!2!RefRelTypeId], 
    NULL AS [RefRelationshipTypeLink!2!RefRelCorrespondTypeId], 
    NULL AS [RefRelationshipTypeLink!2!HasExtensible], 
    NULL AS [RefRelationshipTypeLink!2!!xmltext], 
    NULL AS [RefRelationshipTypeLink!2!ConcurrencyId], 
    NULL AS [ChildRelationshipType!3!RefRelationshipTypeId], 
    --NULL AS [ChildRelationshipType!3!IndClientId], 
    NULL AS [ChildRelationshipType!3!RelationshipTypeName], 
    NULL AS [ChildRelationshipType!3!ArchiveFg], 
    NULL AS [ChildRelationshipType!3!PersonFg], 
    NULL AS [ChildRelationshipType!3!CorporateFg], 
    NULL AS [ChildRelationshipType!3!TrustFg], 
    NULL AS [ChildRelationshipType!3!HasExtensible], 
    NULL AS [ChildRelationshipType!3!!xmltext], 
    NULL AS [ChildRelationshipType!3!ConcurrencyId]
  FROM TRefRelationshipType T1

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.RefRelationshipTypeId, 
    ISNULL(T1.RelationshipTypeName, ''), 
    --T1.IndClientId, 
    ISNULL(T1.ArchiveFg, ''), 
    ISNULL(T1.PersonFg, ''), 
    ISNULL(T1.CorporateFg, ''), 
    ISNULL(T1.TrustFg, ''), 
    CASE 
          WHEN T1.Extensible IS NULL THEN 0 
          WHEN T1.Extensible='' THEN 0 
          ELSE 1 
    END AS [RefRelationshipType!2!HasExtensible], 
    ISNULL(T1.Extensible, '<extxml/>'), 
    T1.ConcurrencyId, 
    T2.RefRelationshipTypeLinkId, 
    T2.RefRelTypeId, 
    T2.RefRelCorrespondTypeId, 
    CASE 
       WHEN T2.Extensible IS NULL THEN 0 
       WHEN T2.Extensible='' THEN 0 
       ELSE 1 
    END AS [RefRelationshipTypeLink!2!HasExtensible], 
    ISNULL(T2.Extensible, '<extxml/>'), 
    T2.ConcurrencyId, 
    NULL, 
    --NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL AS [ChildRelationshipType!3!HasExtensible], 
    NULL, 
    NULL
  FROM TRefRelationshipTypeLink T2
  INNER JOIN TRefRelationshipType T1
  ON T2.RefRelTypeId = T1.RefRelationshipTypeId

  UNION ALL

  SELECT
    3 AS Tag,
    2 AS Parent,
    T1.RefRelationshipTypeId, 
    NULL, 
    --NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL AS [RefRelationshipTypeLink!3!HasExtensible], 
    NULL, 
    NULL, 
    T2.RefRelationshipTypeLinkId, 
    T2.RefRelTypeId, 
    T2.RefRelCorrespondTypeId, 
    CASE 
       WHEN T2.Extensible IS NULL THEN 0 
       WHEN T2.Extensible='' THEN 0 
       ELSE 1 
    END AS [RefRelationshipTypeLink!2!HasExtensible], 
    ISNULL(T2.Extensible, '<extxml/>'), 
    T2.ConcurrencyId, 
    T3.RefRelationshipTypeId, 
    --T3.IndClientId, 
    ISNULL(T3.RelationshipTypeName, ''), 
    ISNULL(T3.ArchiveFg, ''), 
    ISNULL(T3.PersonFg, ''), 
    ISNULL(T3.CorporateFg, ''), 
    ISNULL(T3.TrustFg, ''), 
    CASE 
       WHEN T3.Extensible IS NULL THEN 0 
       WHEN T3.Extensible='' THEN 0 
       ELSE 1 
    END AS [ChildRelationshipType!3!HasExtensible], 


    ISNULL(T3.Extensible, '<extxml/>'), 
    T3.ConcurrencyId
  FROM TRefRelationshipType T3
  INNER JOIN TRefRelationshipTypeLink T2
  ON T3.RefRelationshipTypeId = T2.RefRelCorrespondTypeId
  INNER JOIN TRefRelationshipType T1
  ON T2.RefRelTypeId = T1.RefRelationshipTypeId

  ORDER BY [RefRelationshipType!1!RefRelationshipTypeId], [RefRelationshipTypeLink!2!RefRelationshipTypeLinkId], [ChildRelationshipType!3!RefRelationshipTypeId]

  FOR XML EXPLICIT










GO
