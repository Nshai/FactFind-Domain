SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpGetServiceCaseQuery]
    @ClientId       INT,
    @ServiceCaseId  INT
  
AS  
    SELECT ac.AdviceCaseId                AS Id,
           ac.CaseName                    AS [Name],
           ac.SequentialRef               AS SequentialReference,
           ac.StartDate                   AS StartDate,
           ac.IsJoint                     AS IsJoint,
           ac.CaseRef                     AS Reference,
           ac.ServicingAdminUserId        AS ServicingAdministratorId,
           ac.ParaplannerUserId           AS ParaplannerId,
           ac.RecommendationId            AS RecommendationId, 
           ac.BinderId                    AS DocumentBinderId,
           ac.BinderDescription           AS DocumentBinderName,
           ac.BinderOwnerId               AS DocumentBinderOwnerId,
           ac.Owner1Vulnerability         AS IsVulnerableOwner1,
           ac.Owner1VulnerabilityNotes    AS VulnerabilityNotesOwner1,
           ac.Owner2Vulnerability         AS IsVulnerableOwner2,
           ac.Owner2VulnerabilityNotes    AS VulnerabilityNotesOwner2,
           ac.Owner1VulnerabilityId,
           ac.Owner2VulnerabilityId,

           acs.AdviceCaseStatusId         AS Id,
           acs.TenantId                   AS TenantId,
           acs.Descriptor                 AS [Description],
           acs.IsDefault                  AS IsDefault,
           acs.IsComplete                 AS IsComplete,
           acs.IsAutoClose                AS IsAutoClose,
           acs.ConcurrencyId              AS ConcurrencyId,

           --c.CRMContactId,
           c.CRMContactId                 AS Id,
           c.IndClientId                  AS TenantId,
           c.CRMContactType               AS PartyType,
           CASE 
              WHEN c.CRMContactType       = 3
              THEN cc.CorporateName
              WHEN c.CRMContactType       = 2
              THEN ct.TrustName
              ELSE CONCAT_WS(' ', cp.FirstName, cp.LastName) 
           END                            AS PartyName,

           --ac.Owner2PartyId,
           jc.CRMContactId                AS Id,
           jc.IndClientId                 AS TenantId,
           jc.CRMContactType              AS PartyType,
           CASE 
              WHEN jc.CRMContactType       = 3
              THEN jcc.CorporateName
              WHEN jc.CRMContactType       = 2
              THEN jct.TrustName
              ELSE CONCAT_WS(' ', jcp.FirstName, jcp.LastName) 
           END                            AS PartyName,

           --ac.PractitionerId,
           ac.PractitionerId              AS Id,
           CONCAT_WS(' ', ap.FirstName, ap.LastName) 
                                          AS PartyName,

           --ac.AdviseCategoryId,
           ac.AdviseCategoryId            AS Id,
           pmac.Name

      FROM CRM..TAdviceCase               ac 
      LEFT 
      JOIN Crm.dbo.TAdviceCaseStatus      acs 
        ON acs.AdviceCaseStatusId         = ac.StatusId

      LEFT
      JOIN Crm.dbo.TCRMContact            c 
        ON c.CRMContactId                 = ac.CRMContactId 

      LEFT
      JOIN CRM.dbo.VPerson                cp
        ON cp.CRMContactId                = c.CRMContactId
      LEFT
      JOIN CRM.dbo.VTrust                 ct
        ON ct.CRMContactId                = c.CRMContactId
      LEFT
      JOIN CRM.dbo.VCorporate             cc
        ON cc.CRMContactId                = c.CRMContactId

      LEFT
      JOIN Crm.dbo.TCRMContact            jc 
        ON jc.CRMContactId                = ac.Owner2PartyId

      LEFT
      JOIN CRM.dbo.VPerson                jcp
        ON jcp.CRMContactId               = jc.CRMContactId
      LEFT
      JOIN CRM.dbo.VTrust                 jct
        ON jct.CRMContactId               = jc.CRMContactId
      LEFT
      JOIN CRM.dbo.VCorporate             jcc
        ON jcc.CRMContactId               = jc.CRMContactId

      LEFT
      JOIN Crm.dbo.VAdviser               a
      JOIN CRM.dbo.VPerson                ap 
        ON a.CRMContactId                 = ap.CRMContactId 
        ON ac.PractitionerId              = a.PractitionerId
      
      LEFT
      JOIN PolicyManagement.dbo.TAdviseCategory pmac
        ON pmac.AdviseCategoryId                = ac.AdviseCategoryId

     WHERE ac.AdviceCaseId                = @ServiceCaseId 
       AND (ac.CRMContactId               = @ClientId 
        OR ac.Owner2PartyId               = @ClientId)

    SELECT AdviceCaseId, 
           PolicyBusinessId
      FROM Crm.dbo.TAdviceCasePlan
     WHERE AdviceCaseId                   = @ServiceCaseId 


    SELECT AdviceCaseId, 
           ObjectiveId
      FROM Crm.dbo.TAdviceCaseObjective
     WHERE AdviceCaseId                   = @ServiceCaseId 

    SELECT AdviceCaseId                   AS ServiceCaseId,
           OpportunityId,
           TenantId,
           ConcurrencyId
      FROM Crm.dbo.TServiceCaseToOpportunity
     WHERE AdviceCaseId                   = @ServiceCaseId 

    SELECT AdviceCasePropertyId           AS Id,
           AdviceCaseId,
           [Key],
           [Value],
           CreatedOn,
           LastUpdatedOn
      FROM Crm.dbo.TAdviceCaseProperty
     WHERE AdviceCaseId                   = @ServiceCaseId 
GO