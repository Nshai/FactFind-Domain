SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting Trust types
-- ==================================================================
CREATE PROCEDURE [dbo].[SpListRefTrustTypesQuery]
AS

SELECT
  RefTrustTypeId AS [RefTrustTypeId], 
  TrustTypeName AS [TrustTypeName], 
  ArchiveFG AS [ArchiveFG]
FROM TRefTrustType
ORDER BY [RefTrustTypeId]

GO
