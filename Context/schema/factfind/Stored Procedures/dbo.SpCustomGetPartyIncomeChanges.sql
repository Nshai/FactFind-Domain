
CREATE PROCEDURE [dbo].[SpNCustomGetPartyIncomeChanges] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint
)
AS

--DECLARE @CRMContactId BIGINT = 4670733
--DECLARE @CRMContactId2 BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155

SELECT
i.IncomeChangeId										Id,
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
FROM factfind..TIncomeChange i
JOIN crm..TCRMContact c ON c.CRMContactId = i.CRMContactId
JOIN factfind..TFactFind ff ON (@CRMContactId = ff.CRMContactId1 OR @CRMContactId = ff.CRMContactId2) AND ff.IndigoClientId = @TenantId
WHERE (i.CRMContactId IN (@CRMContactId, @CRMContactId2) OR i.CRMContactId2 IN (@CRMContactId, @CRMContactId2)) AND c.IndClientId = @TenantId
ORDER BY i.IncomeChangeId