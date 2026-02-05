SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ListServiceCasesForAdviserReallocation]
	@AdviserReallocateStatsId bigint,
	@NewAdviserId bigint
AS

BEGIN

SELECT DISTINCT 
	AC.AdviceCaseId AS [TempDataId],
	RAll.AdviserReallocateStatsId AS [ReallocateStatsId],
	'ServiceCase' AS [RecordType],
	RAll.ClientPartyId AS [ReallocateClientId]

 FROM  
  TAdviceCase AC
  JOIN TAdviceCaseStatus ACS ON ACS.AdviceCaseStatusId = AC.StatusId
  JOIN TAdviserReallocateClientDetails RAll WITH(NoLock) ON RAll.ClientPartyId = AC.CRMContactId OR RAll.ClientPartyId = AC.Owner2PartyId
  JOIN TCRMContact CRM  WITH(NoLock) ON RAll.ClientPartyId = CRM.CRMContactId
  JOIN TPractitioner Prac ON Prac.PractitionerId = AC.PractitionerId
 WHERE     
  AC.PractitionerId != @NewAdviserId    
  AND ACS.IsComplete=0 
  AND RAll.AdviserReallocateStatsId = @AdviserReallocateStatsId 
  AND Prac.CRMContactId = CRM.CurrentAdviserCRMId -- update records that are assigned to the clients current adviser 

END
GO
