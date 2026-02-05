SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntroducerEmployee]
	@StampUser varchar (255),
	@IntroducerEmployeeId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerEmployeeAudit
                      (IntroducerId, UserId, TenantId, ConcurrencyId, IntroducerEmployeeId, StampAction, StampDateTime, StampUser)
SELECT     IntroducerId, UserId, TenantId, ConcurrencyId, IntroducerEmployeeId, @StampAction AS Expr1, GETDATE() AS Expr2, @StampUser AS Expr3
FROM         TIntroducerEmployee
WHERE IntroducerEmployeeId = @IntroducerEmployeeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
