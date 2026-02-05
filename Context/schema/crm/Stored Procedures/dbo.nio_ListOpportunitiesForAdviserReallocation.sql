SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ListOpportunitiesForAdviserReallocation]
	@AdviserReallocateStatsId bigint,
	@NewAdviserId bigint
AS

BEGIN

SELECT DISTINCT 
	Opp.OpportunityId AS [TempDataId],    
	RAll.AdviserReallocateStatsId AS [ReallocateStatsId],
	'Opportunity' AS [RecordType]

 FROM     
  TOpportunity Opp
  JOIN TOpportunityCustomer OC ON OC.OpportunityId = Opp.OpportunityId
  JOIN TAdviserReallocateClientDetails RAll WITH(NoLock) ON RAll.ClientPartyId = OC.PartyId   
	JOIN TCRMContact CRM  WITH(NoLock) ON RAll.ClientPartyId = CRM.CRMContactId   
  JOIN TPractitioner Prac ON Prac.PractitionerId = Opp.PractitionerId    
 WHERE     
  Opp.PractitionerId != @NewAdviserId    
  AND IsClosed=0 -- Don't worry about records that closed    
  AND Prac.CRMContactId = CRM.CurrentAdviserCRMId --Only update records that are assigned to the clients current adviser    
	AND RAll.AdviserReallocateStatsId = @AdviserReallocateStatsId 

END
GO
