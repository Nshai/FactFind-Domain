SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateProtection]
	@StampUser varchar (255),
	@CorporateProtectionId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateProtectionAudit 
( CRMContactId, Objectives, LiabilitiesCovered, ReviewablePremiums, 
		RenewCoverOption, CriticalIllnessCover, WrittenInTrust, ExistingProvision, 
		ExistingContractsCancelled, ConcurrencyId, 
	CorporateProtectionId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Objectives, LiabilitiesCovered, ReviewablePremiums, 
		RenewCoverOption, CriticalIllnessCover, WrittenInTrust, ExistingProvision, 
		ExistingContractsCancelled, ConcurrencyId, 
	CorporateProtectionId, @StampAction, GetDate(), @StampUser
FROM TCorporateProtection
WHERE CorporateProtectionId = @CorporateProtectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
