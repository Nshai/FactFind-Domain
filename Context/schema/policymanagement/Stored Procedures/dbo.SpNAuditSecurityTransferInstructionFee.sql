SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditSecurityTransferInstructionFee]
	@StampUser varchar (255),
	@SecurityTransferInstructionFeeId bigint,
	@StampAction char(1)
AS

INSERT INTO TSecurityTransferInstructionFeeAudit
(
    SecurityTransferInstructionFeeId,
    PlanId,
    FeeId,
    SecurityTransferInstructionId,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @SecurityTransferInstructionFeeId,
    PlanId,
    FeeId,
    SecurityTransferInstructionId,
    @StampAction,
    GetDate(),
    @StampUser
FROM TSecurityTransferInstructionFee
WHERE SecurityTransferInstructionFeeId = @SecurityTransferInstructionFeeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
