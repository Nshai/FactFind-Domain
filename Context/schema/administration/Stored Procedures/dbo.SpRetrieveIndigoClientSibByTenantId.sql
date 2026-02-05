SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpRetrieveIndigoClientSibByTenantId]
	@TenantId bigint
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
	sib.IndigoClientId AS TenantId,
	ic.Identifier AS TenantName,
	sib.GroupId,
	sib.Sib,
	ic.RefEnvironmentId
	FROM TIndigoClientSib AS sib
	INNER JOIN TIndigoClientCombined AS ic
	ON sib.IndigoClientId = ic.IndigoClientId
	WHERE sib.IndigoClientId = @TenantId
END
GO
