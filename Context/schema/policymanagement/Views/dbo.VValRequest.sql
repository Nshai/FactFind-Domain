SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VValRequest]
AS

Select	
A.ValRequestId, A.PractitionerId, B.CRMContactId AS AdviserCRMContactId, A.CRMContactId, A.PolicyBusinessId, A.PlanValuationId, 
A.ValuationType, A.RequestXML, A.RequestedUserId, RU.CRMContactId AS RequestedUserCRMContactId, A.RequestedDate, A.RequestStatus, A.ConcurrencyId

From 
PolicyManagement.dbo.TValRequest A
LEFT JOIN CRM.dbo.VAdviser AS B ON A.PractitionerId = B.PractitionerId 
LEFT JOIN Administration.dbo.TUser AS RU ON RU.UserId = A.RequestedUserId



GO
