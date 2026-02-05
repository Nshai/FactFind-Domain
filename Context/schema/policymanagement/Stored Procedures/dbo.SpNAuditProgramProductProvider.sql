SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProgramProductProvider]
	@StampUser varchar (255),
	@ProgramProductProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO TProgramProductProviderAudit
(
    ProgramProductProviderId,
    ProgramId,
    ProviderId,
    StampAction,
    StampDateTime,
    StampUser
)
SELECT
    @ProgramProductProviderId,
    ProgramId,
    ProviderId,
    @StampAction,
    GetDate(),
    @StampUser
FROM TProgramProductProvider
WHERE ProgramProductProviderId = @ProgramProductProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO