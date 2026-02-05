SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefYesNoClosedResponse]
    @StampUser varchar(255),
    @RefYesNoClosedResponseId tinyint,
    @StampAction char(1)
AS
BEGIN
    INSERT INTO TRefYesNoClosedResponseAudit
    (
        Name,
        ConcurrencyId,
        RefYesNoClosedResponseId,
        StampAction,
        StampDateTime,
        StampUser
    )
    SELECT
        Name,
        ConcurrencyId,
        @RefYesNoClosedResponseId,
        @StampAction,
        GETDATE(),
        @StampUser
    FROM TRefYesNoClosedResponse
    WHERE RefYesNoClosedResponseId = @RefYesNoClosedResponseId;

    IF @@ERROR != 0 GOTO errh

    RETURN (0)

errh:
    RETURN (100)
END
GO