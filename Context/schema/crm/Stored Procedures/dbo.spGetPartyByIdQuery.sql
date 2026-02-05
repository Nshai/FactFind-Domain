SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 15/05/2020
-- Description:	Stored procedure for getting party by Id
-- =============================================
CREATE PROCEDURE [dbo].[spGetPartyByIdQuery] 
    @partyId INT
AS
BEGIN
    SELECT 	
        -- Party
        contact.CRMContactId AS Id,
        contact.ExternalReference,
        COALESCE(contact.CorporateName, contact.FirstName + ' ' + contact.LastName) AS ClientName,
        CASE 
            WHEN contact.RefCRMContactStatusId IS NOT NULL THEN contact.RefCRMContactStatusId
            WHEN persContact.PersonalContactId IS NOT NULL THEN 3 -- PersonalContact
            ELSE NULL
        END as CustomerType,
        CASE 
            WHEN contact.PersonId IS NOT NULL THEN 1 --Person
            WHEN account.AccountId IS NULL AND contact.TrustId IS NOT NULL THEN 2 --Trust
            WHEN contact.CorporateId IS NOT NULL THEN 3 --Corporate
            ELSE 0 --INVALID
        END as PartyType,
        lead.LeadId,
        NULL AS CanBeUpdated,
        -- Account
        account.AccountId,
        CASE WHEN contact.CorporateId IS NULL THEN 1 ELSE 0 END AS IsPerson
    FROM TCRMContact contact 
    LEFT OUTER JOIN TAccount account ON account.CRMContactId = contact.CRMContactId
    LEFT OUTER JOIN TLead lead ON lead.CRMContactId = contact.CRMContactId
    LEFT OUTER JOIN TPersonalContact persContact ON persContact.CRMContactId = contact.CRMContactId
    WHERE contact.CRMContactId = @partyId
END
GO