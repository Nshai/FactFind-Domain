SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPartnershipdetailsgeneral]
	@StampUser varchar (255),
	@PartnershipdetailsgeneralId bigint,
	@StampAction char(1)
AS

INSERT INTO TPartnershipdetailsgeneralAudit 
( CRMContactId, PartnershipYesNo, partnershipdetailsgeneralYesNo, partnershipdetailsgeneralType, 
		plansToIncorporateYesNo, Notes, ConcurrencyId, 
	PartnershipdetailsgeneralId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, PartnershipYesNo, partnershipdetailsgeneralYesNo, partnershipdetailsgeneralType, 
		plansToIncorporateYesNo, Notes, ConcurrencyId, 
	PartnershipdetailsgeneralId, @StampAction, GetDate(), @StampUser
FROM TPartnershipdetailsgeneral
WHERE PartnershipdetailsgeneralId = @PartnershipdetailsgeneralId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
