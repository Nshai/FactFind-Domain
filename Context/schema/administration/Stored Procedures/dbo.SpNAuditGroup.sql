SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditGroup]
	@StampUser varchar (255),
	@GroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupAudit 
( Identifier, GroupingId, ParentId, CRMContactId, 
		IndigoClientId, LegalEntity, GroupImageLocation, AcknowledgementsLocation, 
		FinancialYearEnd, ApplyFactFindBranding, VatRegNbr, AuthorisationText, 
		ConcurrencyId, IsFSAPassport, FRNNumber,
	GroupId, StampAction, StampDateTime, StampUser, DocumentFileReference,
	AdminEmail, DefaultClientGroupId, ExternalRef) 
Select Identifier, GroupingId, ParentId, CRMContactId, 
		IndigoClientId, LegalEntity, GroupImageLocation, AcknowledgementsLocation, 
		FinancialYearEnd, ApplyFactFindBranding, VatRegNbr, AuthorisationText, 
		ConcurrencyId, IsFSAPassport, FRNNumber,
	GroupId, @StampAction, GetDate(), @StampUser,
	DocumentFileReference, AdminEmail, DefaultClientGroupId, ExternalRef
FROM TGroup
WHERE GroupId = @GroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
