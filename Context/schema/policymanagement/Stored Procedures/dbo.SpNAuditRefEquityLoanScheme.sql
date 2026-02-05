SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRefEquityLoanScheme]
	@StampUser varchar (255),
	@RefEquityLoanSchemeId bigint,
	@StampAction char(1)
AS

	INSERT INTO TRefEquityLoanSchemeAudit (RefEquityLoanSchemeId, [Name], StampAction, StampDateTime, StampUser)
	SELECT RefEquityLoanSchemeId, [Name], @StampAction, GetDate(), @StampUser from TRefEquityLoanScheme
	WHERE RefEquityLoanSchemeId = @RefEquityLoanSchemeId



IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
