SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviseFeeChargingType]
	@StampUser varchar (255),
	@AdviseFeeChargingTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO [TAdviseFeeChargingTypeAudit] 
( RefAdviseFeeChargingTypeId, TenantId, IsArchived, 
	ConcurrencyId, AdviseFeeChargingTypeId,StampAction, StampDateTime, StampUser,GroupId) 
Select RefAdviseFeeChargingTypeId, TenantId, IsArchived, 
	ConcurrencyId,AdviseFeeChargingTypeId, @StampAction, GetDate(), @StampUser,GroupId
FROM [TAdviseFeeChargingType]
WHERE AdviseFeeChargingTypeId = @AdviseFeeChargingTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
