SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Siarhei Salokha
-- Create date: 10/06/2022
-- Description:	Stored procedure for updating clients group by party id.
-- =============================================

CREATE PROCEDURE [dbo].[SpUpdateClientsGroupByPartyId]
@PartyId INT,
@GroupId INT,
@TenantId INT,
@StampUser VARCHAR (255) = '0'

AS

SET NOCOUNT ON

BEGIN
    UPDATE T1
    SET
        T1.GroupId = @GroupId

        OUTPUT DELETED.RefCRMContactStatusId, DELETED.PersonId, DELETED.CorporateId, DELETED.TrustId,
        DELETED.AdvisorRef, DELETED.RefSourceOfClientId, DELETED.SourceValue, DELETED.Notes,
        DELETED.ArchiveFg, DELETED.LastName, DELETED.FirstName, DELETED.CorporateName,
        DELETED.AdviserAssignedByUserId, DELETED.DOB, DELETED.Postcode, DELETED.OriginalAdviserCRMId,
        DELETED.CurrentAdviserCRMId, DELETED.CurrentAdviserName, DELETED.CRMContactType, DELETED.IndClientId,
        DELETED.FactFindId, DELETED.InternalContactFG, DELETED.RefServiceStatusId, DELETED.MigrationRef,
        DELETED.CreatedDate, DELETED.ExternalReference, DELETED.CampaignDataId, DELETED.AdditionalRef,
        DELETED._ParentId, DELETED._ParentTable, DELETED._ParentDb, DELETED._OwnerId,
        DELETED.ConcurrencyId, DELETED.CRMContactId, DELETED.FeeModelId, 'U',
        GETUTCDATE(), @StampUser, DELETED.ClientTypeId, DELETED.IsHeadOfFamilyGroup,
        DELETED.FamilyGroupCreationDate, DELETED.IsDeleted, DELETED.ServiceStatusStartDate, DELETED.GroupId

        INTO crm.dbo.TCRMContactAudit
        (RefCRMContactStatusId, PersonId, CorporateId, TrustId,
        AdvisorRef, RefSourceOfClientId, SourceValue, Notes,
        ArchiveFg, LastName, FirstName, CorporateName,
        AdviserAssignedByUserId, DOB, Postcode, OriginalAdviserCRMId,
        CurrentAdviserCRMId, CurrentAdviserName, CRMContactType, IndClientId,
        FactFindId, InternalContactFG, RefServiceStatusId, MigrationRef,
        CreatedDate, ExternalReference, CampaignDataId, AdditionalRef,
        _ParentId, _ParentTable, _ParentDb, _OwnerId,
        ConcurrencyId, CRMContactId, FeeModelId, StampAction,
        StampDateTime, StampUser, ClientTypeId, IsHeadOfFamilyGroup,
        FamilyGroupCreationDate, IsDeleted, ServiceStatusStartDate, GroupId)

    FROM crm.dbo.TCRMContact AS T1
    WHERE IndClientId = @TenantId AND CurrentAdviserCRMId = @PartyId

END