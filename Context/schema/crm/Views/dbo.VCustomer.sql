SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VCustomer
AS
SELECT     A.CRMContactId, A.RefCRMContactStatusId, A.AdvisorRef, A.Postcode, A.OriginalAdviserCRMId, A.CurrentAdviserCRMId, A.CurrentAdviserName, A.IndClientId, 
                      A.ExternalReference, A.CampaignDataId, A.AdditionalRef, A.CRMContactId AS PartyCRMContactId, A.ConcurrencyId, A.RefServiceStatusId, B.LeadId, B.LeadSourceId, 
                      A.AdviserAssignedByUserId, B.IntroducerBranchId, B.IntroducerEmployeeId, B.IndividualName, A.ServiceStatusStartDate, E.CRMContactExtId, A.RefClientSegmentId, A.ClientSegmentStartDate
FROM         dbo.TCRMContact AS A 
LEFT JOIN dbo.TCRMContactExt E ON E.CRMContactId = A.CRMContactId
LEFT OUTER JOIN dbo.TLead AS B ON A.CRMContactId = B.CRMContactId

WHERE     (A.RefCRMContactStatusId IN (1, 2)) AND (ISNULL(A.InternalContactFG, 0) = 0)
GO