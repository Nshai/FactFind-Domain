SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting Address types
-- ==================================================================
CREATE PROCEDURE [dbo].[SpListAddressTypesQuery]
AS

SELECT
	RefAddressTypeId as [Id],
	AddressTypeName as [Name]
FROM TRefAddressType
ORDER BY [RefAddressTypeId]

GO
