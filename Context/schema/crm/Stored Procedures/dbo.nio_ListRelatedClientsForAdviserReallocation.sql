SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ListRelatedClientsForAdviserReallocation]
	@AdviserReallocateStatsId bigint
AS

BEGIN


SELECT DISTINCT 
	Rel.CRMContactToId AS [TempDataId],    
	C.AdviserReallocateStatsId AS [ReallocateStatsId],
	'RelatedClient' AS [RecordType]
 FROM    
	TAdviserReallocateClientDetails C    
	JOIN TRelationShip Rel ON Rel.CRMContactFromId = C.ClientPartyId      
	JOIN TCRMContact RelCon ON RelCon.CRMContactId = Rel.CRMContactToId    
	LEFT JOIN TAdviserReallocateClientDetails CExists ON CExists.ClientPartyId = Rel.CRMContactToId    
		AND CExists.AdviserReallocateStatsId = @AdviserReallocateStatsId
 WHERE    
	CExists.ClientPartyId IS NULL 
	AND C.AdviserReallocateStatsId = @AdviserReallocateStatsId
ORDER BY Rel.CRMContactToId

END
GO
