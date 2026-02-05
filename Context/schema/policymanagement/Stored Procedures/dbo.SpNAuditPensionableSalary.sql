SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPensionableSalary]
	@StampUser varchar (255),
	@PensionableSalaryId bigint,
	@StampAction char(1)
AS

INSERT INTO TPensionableSalaryAudit 
( TenantId, PolicyBusinessId, PensionableSalary, StartDate, EndDate, IsCurrent, ActionDate, HasBeenActioned, ConcurrencyId, PensionableSalaryId, StampAction, StampDateTime, StampUser) 
Select TenantId, PolicyBusinessId, PensionableSalary, StartDate, EndDate, IsCurrent, ActionDate, HasBeenActioned, ConcurrencyId, PensionableSalaryId, @StampAction, GetDate(), @StampUser
FROM TPensionableSalary
WHERE PensionableSalaryId = @PensionableSalaryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
