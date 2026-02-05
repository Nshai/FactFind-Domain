SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[SpCustomNioCreateAuditRecordsForParty]
	@CrmcontactId bigint,
    @StampAction char(1),
    @StampUser bigint

As

Declare @PersonId bigint, @CorporateId bigint, @TrustId bigint

Select @PersonId = PersonId, @CorporateId = CorporateId, @TrustId = TrustId
From TCrmContact
Where CrmcontactId = @CrmcontactId


-- Exec SpNAuditCrmContact @StampUser = @StampUser, @CRMContactId = @CRMContactId, @StampAction = @StampAction

If IsNull(@PersonId, 0) > 0
Begin
	Exec SpNAuditPerson @StampUser = @StampUser, @PersonId = @PersonId, @StampAction = @StampAction
End
Else If IsNull(@CorporateId, 0) > 0
Begin
	Exec SpNAuditCorporate @StampUser = @StampUser, @CorporateId = @CorporateId, @StampAction = @StampAction
End
Else If IsNull(@TrustId, 0) > 0
Begin
	Exec SpNAuditTrust @StampUser = @StampUser, @TrustId = @TrustId, @StampAction = @StampAction
End





GO
