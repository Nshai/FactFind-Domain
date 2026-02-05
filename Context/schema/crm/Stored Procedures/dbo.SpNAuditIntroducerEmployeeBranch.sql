SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntroducerEmployeeBranch]
	@StampUser varchar (255),
	@IntroducerEmployeeBranchId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntroducerEmployeeBranchAudit
                      (IntroducerEmployeeId, IntroducerBranchId, ConcurrencyId, IntroducerEmployeeBranchId, StampAction, StampDateTime, StampUser)
SELECT     IntroducerEmployeeId, IntroducerBranchId, ConcurrencyId, IntroducerEmployeeBranchId, @StampAction AS Expr1, GETDATE() AS Expr2, @StampUser AS Expr3
FROM         TIntroducerEmployeeBranch
WHERE     (IntroducerEmployeeBranchId = @IntroducerEmployeeBranchId)

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
