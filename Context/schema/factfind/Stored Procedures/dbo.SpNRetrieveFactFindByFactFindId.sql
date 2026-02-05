SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFactFindByFactFindId]
	@FactFindId bigint
AS

SELECT T1.FactFindId, T1.CRMContactId1, T1.CRMContactId2, T1.FactFindTypeId, T1.IndigoClientId, T1.ConcurrencyId
FROM TFactFind  T1
WHERE T1.FactFindId = @FactFindId
GO
