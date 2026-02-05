SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpUpdateMultiTieFgToAdviser]
    @TenantId int,
    @AdviserIds dbo.[tvp_bigint] READONLY
AS
BEGIN

    UPDATE CRM.dbo.TPractitioner SET MultiTieFg = 1
    WHERE PractitionerId IN (SELECT id FROM @AdviserIds)
    AND IndClientId = @TenantId
    
END

GO

