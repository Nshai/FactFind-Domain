CREATE VIEW [dbo].[VPlanOwnerExt]

AS

SELECT	
    o.PolicyOwnerId,
    o.CRMContactId,
    pb.PolicyBusinessId,
    p.Title,
    COALESCE(p.Firstname, corp.CorporateName, t.TrustName) AS FirstName,
    p.MiddleName,
    p.LastName,
    p.Salutation
FROM TPolicyOwner o
    INNER JOIN policymanagement.dbo.TPolicyBusiness pb on pb.PolicyDetailId = o.PolicyDetailId
    INNER JOIN crm.dbo.TCRMContact c on o.CRMContactId = c.CRMContactId
    LEFT JOIN crm.dbo.TPerson p ON p.PersonId = c.PersonId
    LEFT JOIN crm.dbo.TCorporate corp ON corp.CorporateId = c.CorporateId
    LEFT JOIN crm.dbo.TTrust t ON t.TrustId = c.TrustId
GO