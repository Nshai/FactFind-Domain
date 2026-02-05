SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveRefProductLinkByRefProductLinkId]
	@RefProductLinkId bigint
AS

SELECT T1.RefProductLinkId, T1.ApplicationLinkId, T1.RefProductTypeId, T1.ProductGroupData, T1.ProductTypeData, T1.IsArchived, T1.ConcurrencyId
FROM TRefProductLink  T1
WHERE T1.RefProductLinkId = @RefProductLinkId
GO
