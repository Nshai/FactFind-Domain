SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditValExcludeFundUpdate] 
	@StampUser varchar (255),
	@ValExcludeFundUpdateId bigint,
	@StampAction char(1)
AS

INSERT INTO TValExcludeFundUpdateAudit( 
	 ValScheduleId, ValGatingId, ValExcludeFundUpdateId, ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT
	 ValScheduleId, ValGatingId, ValExcludeFundUpdateId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM 
	 TValExcludeFundUpdate
WHERE
	 ValExcludeFundUpdateId = @ValExcludeFundUpdateId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)


GO