SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProgramPlanType]
	@StampUser varchar (255),
	@ProgramPlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TProgramPlanTypeAudit
(
    ProgramPlanTypeId,
    ProgramId,
    PlanTypeId,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @ProgramPlanTypeId,
    ProgramId,
    PlanTypeId,
    @StampAction,
    GetDate(),
    @StampUser
FROM TProgramPlanType
WHERE ProgramPlanTypeId = @ProgramPlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
