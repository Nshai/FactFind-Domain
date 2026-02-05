SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFamilyMembers]
	@StampUser varchar (255),
	@FamilyMembersId bigint,
	@StampAction char(1)
AS

INSERT INTO TFamilyMembersAudit 
( CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	FamilyMembersId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	FamilyMembersId, @StampAction, GetDate(), @StampUser
FROM TFamilyMembers
WHERE FamilyMembersId = @FamilyMembersId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
