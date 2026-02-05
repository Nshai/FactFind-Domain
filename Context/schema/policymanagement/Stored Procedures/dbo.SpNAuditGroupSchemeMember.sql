SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGroupSchemeMember]
	@StampUser varchar (255),
	@GroupSchemeMemberId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeMemberAudit 
( GroupSchemeId, TenantId, CRMContactId, GroupSchemeCategoryId, 
		PolicyBusinessId, JoiningDate, LeavingDate, IsLeaver, NominatedBeneficiary,
		ConcurrencyId, 
	GroupSchemeMemberId, StampAction, StampDateTime, StampUser) 
Select GroupSchemeId, TenantId, CRMContactId, GroupSchemeCategoryId, 
		PolicyBusinessId, JoiningDate, LeavingDate, IsLeaver, NominatedBeneficiary,
		ConcurrencyId, 
	GroupSchemeMemberId, @StampAction, GetDate(), @StampUser
FROM TGroupSchemeMember
WHERE GroupSchemeMemberId = @GroupSchemeMemberId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
