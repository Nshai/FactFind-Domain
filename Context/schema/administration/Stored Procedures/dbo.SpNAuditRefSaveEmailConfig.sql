SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRefSaveEmailConfig]
    @StampUser VARCHAR(255),
    @RefSaveEmailConfigId TINYINT,
    @StampAction CHAR(1)
AS

INSERT INTO TRefSaveEmailConfigAudit
    (SaveEmailConfigName, ConcurrencyId, RefSaveEmailConfigId, StampAction, StampDateTime, StampUser)
SELECT
    SaveEmailConfigName, ConcurrencyId, RefSaveEmailConfigId, @StampAction, GETDATE(), @StampUser
FROM TRefSaveEmailConfig
WHERE RefSaveEmailConfigId = @RefSaveEmailConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
