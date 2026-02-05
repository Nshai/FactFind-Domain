SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditTransferInstructionFee]
	@StampUser varchar (255),
	@TransferInstructionFeeId bigint,
	@StampAction char(1)
AS

INSERT INTO TTransferInstructionFeeAudit
(
    TransferInstructionFeeId,
    PlanId,
    FeeId,
    TransferInstructionId,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @TransferInstructionFeeId,
    PlanId,
    FeeId,
    TransferInstructionId,
    @StampAction,
    GetDate(),
    @StampUser
FROM TTransferInstructionFee
WHERE TransferInstructionFeeId = @TransferInstructionFeeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
