SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviseFeeChargingDetailsTiering]
	@StampUser VARCHAR (50),
	@AdviseFeeChargingDetailsTieringId BIGINT,
	@StampAction CHAR(1)  
AS    

INSERT INTO TAdviseFeeChargingDetailsTieringAudit (
	AdviseFeeChargingDetailsTieringId, 
	AdviseFeeChargingDetailsId, 
	Threshold, 
	[Percentage], 
	TenantId, 
	ConcurrencyId, 
	StampAction, 
	StampDateTime, 
	StampUser)
SELECT
	AdviseFeeChargingDetailsTieringId,
	AdviseFeeChargingDetailsId,
	Threshold,
	[Percentage],
	TenantId,
	ConcurrencyId,
	@StampAction,
	GetDate(),
	@StampUser
FROM
	TAdviseFeeChargingDetailsTiering  
WHERE
	AdviseFeeChargingDetailsTieringId = @AdviseFeeChargingDetailsTieringId
	
IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
