SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProgramFeeModel]
	@StampUser varchar (255),
	@ProgramFeeModelId bigint,
	@StampAction char(1)
AS

INSERT INTO TProgramFeeModelAudit
(
    ProgramFeeModelId,
    ProgramId,
    FeeModelId,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @ProgramFeeModelId,
    ProgramId,
    FeeModelId,
    @StampAction,
    GetDate(),
    @StampUser
FROM TProgramFeeModel
WHERE ProgramFeeModelId = @ProgramFeeModelId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
