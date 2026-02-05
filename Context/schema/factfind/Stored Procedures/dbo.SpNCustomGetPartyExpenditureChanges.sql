CREATE PROCEDURE [dbo].[SpNCustomGetPartyExpenditureChanges] 
(
  @CRMContactId INT,                            
  @CRMContactId2 INT,                       
  @TenantId INT
)
AS

--DECLARE @CRMContactId INT = 4670733
--DECLARE @CRMContactId2 INT = 4670731
--DECLARE @TenantId INT = 10155

SELECT
i.ExpenditureChangeId									Id,
i.CRMContactId											PartyId,
i.CRMContactId2											RelatedPartyId,
ISNULL(c.CorporateName, c.FirstName +' '+c.LastName)	[Owner],
i.StartDate												[date],
CASE WHEN i.IsRise = 1 THEN 'Rise' ELSE 'Fall' END		ChangeType,
i.Amount												NetAmountPerMonth,
i.[Description]											ReasonForChange,
i.Frequency												Frequency,
CASE WHEN(ff.CRMContactId2 IS NOT NULL AND 
              (
                (i.CRMContactId = ff.CRMContactId1 AND 
                 i.CRMContactId2 = ff.CRMContactId2) 
                 OR
                (i.CRMContactId = ff.CRMContactId2 AND 
                i.CRMContactId2 = ff.CRMContactId1)
              )
         ) THEN 1 ELSE 0 END IsJoint
FROM factfind..TExpenditureChange i
JOIN crm..TCRMContact c ON c.CRMContactId = i.CRMContactId
JOIN factfind..TFactFind ff ON (@CRMContactId = ff.CRMContactId1 OR @CRMContactId = ISNULL(ff.CRMContactId2,0)) AND ff.IndigoClientId = @TenantId
WHERE (i.CRMContactId IN (@CRMContactId, @CRMContactId2) OR i.CRMContactId2 IN (@CRMContactId, @CRMContactId2)) AND c.IndClientId = @TenantId
ORDER BY i.ExpenditureChangeId