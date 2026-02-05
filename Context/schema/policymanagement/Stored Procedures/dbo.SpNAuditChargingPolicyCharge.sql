SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditChargingPolicyCharge]
    @StampUser VARCHAR (255),
    @ChargingPolicyChargeId BIGINT,
    @StampAction CHAR(1)
AS

INSERT INTO dbo.TChargingPolicyChargeAudit
    ([ChargingPolicyChargeId]
    ,[TenantId]
    ,[PolicyBusinessId]
    ,[ChargeDate]
    ,[ChargeType]
    ,[TotalAmount]
    ,[IsArchived]
    ,[LastUpdatedAt]
    ,[StampAction]
    ,[StampDateTime]
    ,[StampUser]
    ,[Note])
SELECT 
     [ChargingPolicyChargeId]
    ,[TenantId]
    ,[PolicyBusinessId]
    ,[ChargeDate]
    ,[ChargeType]
    ,[TotalAmount]
    ,[IsArchived]
    ,[LastUpdatedAt]
    ,@StampAction
    ,GETDATE()
    ,@StampUser
    ,Note
FROM dbo.TChargingPolicyCharge
WHERE ChargingPolicyChargeId = @ChargingPolicyChargeId

IF @@ERROR != 0 
    RETURN (100)

RETURN (0)

GO