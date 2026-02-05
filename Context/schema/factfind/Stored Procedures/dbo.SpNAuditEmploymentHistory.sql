SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEmploymentHistory]
	@StampUser varchar (255),
	@EmploymentHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmploymentHistoryAudit 
(CRMContactId, Employer, StartDate, EndDate, [GrossAnnualEarnings], ConcurrencyId,
	EmploymentHistoryId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, Employer, StartDate, EndDate, [GrossAnnualEarnings], ConcurrencyId,
	EmploymentHistoryId, @StampAction, GetDate(), @StampUser
FROM TEmploymentHistory
WHERE EmploymentHistoryId = @EmploymentHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
