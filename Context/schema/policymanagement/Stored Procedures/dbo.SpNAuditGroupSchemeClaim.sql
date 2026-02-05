SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGroupSchemeClaim]
	@StampUser varchar (255),
	@GroupSchemeClaimId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeClaimAudit 
( GroupSchemeId, TenantId, ClaimDescription, MemberPartyId, 
		MemberName, MemberGender, IsSpousesPension, StartDate, 
		EndDate, Amount, ConcurrencyId, 
	GroupSchemeClaimId, StampAction, StampDateTime, StampUser) 
Select GroupSchemeId, TenantId, ClaimDescription, MemberPartyId, 
		MemberName, MemberGender, IsSpousesPension, StartDate, 
		EndDate, Amount, ConcurrencyId, 
	GroupSchemeClaimId, @StampAction, GetDate(), @StampUser
FROM TGroupSchemeClaim
WHERE GroupSchemeClaimId = @GroupSchemeClaimId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
