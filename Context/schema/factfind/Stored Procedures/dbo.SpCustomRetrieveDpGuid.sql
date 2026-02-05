SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveDpGuid]
	@DpGuidId bigint
AS

SELECT T1.DpGuidId, T1.EntityId, T1.DpGuidTypeId, T1.Guid, T1.ConcurrencyId
FROM TDpGuid T1
	
WHERE T1.DpGuidId = @DpGuidId

GO
