SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProgram]
	@StampUser varchar (255),
	@ProgramId bigint,
	@StampAction char(1)
AS

INSERT INTO TProgramAudit
(
    ProgramId,
    TenantId,
    Name,
    CreatedBy,
    CreatedAt,
    ModifiedBy,
    ModifiedAt,
    DoesAllowTrading,
    Status,
    Description,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @ProgramId,
    TenantId,
    Name,
    CreatedBy,
    CreatedAt,
    ModifiedBy,
    ModifiedAt,
    DoesAllowTrading,
    Status,
    Description,
    @StampAction,
    GetDate(),
    @StampUser
FROM TProgram
WHERE ProgramId = @ProgramId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
