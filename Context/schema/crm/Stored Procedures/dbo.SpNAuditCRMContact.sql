SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCRMContact]
	@StampUser varchar (255),
	@CRMContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TCRMContactAudit 
( RefCRMContactStatusId, PersonId, CorporateId, TrustId, 
		AdvisorRef, RefSourceOfClientId, SourceValue, Notes, 
		ArchiveFg, LastName, FirstName, CorporateName, AdviserAssignedByUserId,
		DOB, Postcode, OriginalAdviserCRMId, CurrentAdviserCRMId, 
		CurrentAdviserName, CRMContactType, IndClientId, FactFindId, 
		InternalContactFG, RefServiceStatusId, MigrationRef, CreatedDate, 
		ExternalReference, CampaignDataId, AdditionalRef, _ParentId, 
		_ParentTable, _ParentDb, _OwnerId, ConcurrencyId,		
	    CRMContactId, FeeModelId, StampAction, StampDateTime, 
	    StampUser, ClientTypeId,IsHeadOfFamilyGroup, FamilyGroupCreationDate, 
		IsDeleted,GroupId,RefClientSegmentId,ClientSegmentStartDate) 
Select RefCRMContactStatusId, PersonId, CorporateId, TrustId, 
		AdvisorRef, RefSourceOfClientId, SourceValue, Notes, 
		ArchiveFg, LastName, FirstName, CorporateName, AdviserAssignedByUserId,
		DOB, Postcode, OriginalAdviserCRMId, CurrentAdviserCRMId, 
		CurrentAdviserName, CRMContactType, IndClientId, FactFindId, 
		InternalContactFG, RefServiceStatusId, MigrationRef, CreatedDate, 
		ExternalReference, CampaignDataId, AdditionalRef, _ParentId, 
		_ParentTable, _ParentDb, _OwnerId, ConcurrencyId,		
	    CRMContactId, FeeModelId, @StampAction, GetDate(), 
	    @StampUser, ClientTypeId, IsHeadOfFamilyGroup, FamilyGroupCreationDate, 
		IsDeleted,GroupId,RefClientSegmentId,ClientSegmentStartDate
FROM TCRMContact
WHERE CRMContactId = @CRMContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
