SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting Contact types
-- ==================================================================
CREATE PROCEDURE [dbo].[SpListContactTypesQuery]
AS

SELECT
  RefContactTypeId as [Id], 
  ContactTypeName, 
  ArchiveFG
FROM TRefContactType
ORDER BY RefContactTypeId

GO