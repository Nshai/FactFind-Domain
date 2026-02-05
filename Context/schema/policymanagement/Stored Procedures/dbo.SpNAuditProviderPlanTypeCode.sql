SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProviderPlanTypeCode]
    @StampUser varchar (255),
    @ProviderPlanTypeCodeId bigint,
    @StampAction char(1)
AS

INSERT INTO TProviderPlanTypeCodeAudit
(ProviderPlanTypeCodeId, RefPlanType2ProdSubTypeId, ProdProviderId, Code, Abbreviation, StampAction, StampDateTime, StampUser)
SELECT ProviderPlanTypeCodeId, RefPlanType2ProdSubTypeId, ProdProviderId, Code, Abbreviation, @StampAction, GetDate(), @StampUser
FROM TProviderPlanTypeCode
WHERE ProviderPlanTypeCodeId = @ProviderPlanTypeCodeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
