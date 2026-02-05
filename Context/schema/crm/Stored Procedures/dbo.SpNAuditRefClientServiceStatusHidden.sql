SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefClientServiceStatusHidden]
	@StampUser varchar (255),
	@RefClientServiceStatusHiddenId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefClientServiceStatusHiddenAudit 
( RefServiceStatusId, GroupId, TenantId, ConcurrencyId, 
		
	RefClientServiceStatusHiddenId, StampAction, StampDateTime, StampUser) 
Select RefServiceStatusId, GroupId, TenantId, ConcurrencyId, 
		
	RefClientServiceStatusHiddenId, @StampAction, GetDate(), @StampUser
FROM TRefClientServiceStatusHidden
WHERE RefClientServiceStatusHiddenId = @RefClientServiceStatusHiddenId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
