SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCCJDefault]
	@StampUser varchar (255),
	@CCJDefaultId bigint,
	@StampAction char(1)
AS

INSERT INTO TCCJDefaultAudit 
( CRMContactId, ccjType, ccjDateReg, ccjAmount, 
		ccjDateSatisf, ccjApp1, ccjApp2, ConcurrencyId, 
		
	CCJDefaultId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ccjType, ccjDateReg, ccjAmount, 
		ccjDateSatisf, ccjApp1, ccjApp2, ConcurrencyId, 
		
	CCJDefaultId, @StampAction, GetDate(), @StampUser
FROM TCCJDefault
WHERE CCJDefaultId = @CCJDefaultId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
