SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAccountJobDetail]
	@StampUser varchar (255),
	@AccountJobDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TAccountJobDetailAudit 
( AccountId, JobTitle, EmployerCRMId, ConcurrencyId, 
		
	AccountJobDetailId, StampAction, StampDateTime, StampUser) 
Select AccountId, JobTitle, EmployerCRMId, ConcurrencyId, 
		
	AccountJobDetailId, @StampAction, GetDate(), @StampUser
FROM TAccountJobDetail
WHERE AccountJobDetailId = @AccountJobDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
