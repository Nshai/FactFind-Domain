SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFilePollingProcess]
	@StampUser varchar (255),
	@FilePollingProcessId bigint,
	@StampAction char(1)
AS

INSERT INTO TFilePollingProcessAudit
                      (Identifier, Description, WatchingFolder, IsEnabled, PollingInterval, HasLimitInterval, IntervalFrom, IntervalTo, TenantId, ConcurrencyId, FilePollingProcessId, 
                      StampAction, StampDateTime, StampUser, NotificationEmails)
SELECT     Identifier, Description, WatchingFolder, IsEnabled, PollingInterval, HasLimitInterval, IntervalFrom, IntervalTo, TenantId, ConcurrencyId, FilePollingProcessId, 
                      @StampAction AS Expr1, GETDATE() AS Expr2, @StampUser AS Expr3, NotificationEmails
FROM         TFilePollingProcess
WHERE     (FilePollingProcessId = @FilePollingProcessId)

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
