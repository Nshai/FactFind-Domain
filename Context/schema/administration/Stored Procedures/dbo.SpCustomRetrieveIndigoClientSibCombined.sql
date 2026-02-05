SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveIndigoClientSibCombined]
AS
SELECT
	A.Guid,
	A.Sib,
	A.IndigoClientId,
	A.GroupId,	
	B.RefEnvironmentId,
	B.Identifier AS TenantName
FROM 
	TIndigoClientSibCombined A
	JOIN TIndigoClientCombined B ON B.Guid = A.IndigoClientGuid
FOR XML RAW('IndigoClientSib')
GO
