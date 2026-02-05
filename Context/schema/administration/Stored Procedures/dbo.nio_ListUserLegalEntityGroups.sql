SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[nio_ListUserLegalEntityGroups]  
@TenantId bigint,    
@UserId bigint  
  
AS    
BEGIN  
   
--Declarations  
DECLARE @entityFlag bit  
Declare @GroupId bigint  
  
--Initialize variables .  
select @GroupId = GroupId from TUser where UserId = @UserId  
SET @entityFlag = 0  
  
--Find the Legal Entity Group Id.  
WHILE (@entityFlag = 0)  
BEGIN  
 select @entityFlag = G.LegalEntity from TGroup G where G.GroupId = @GroupId  
  
 if (@entityFlag != 1)  
   select @GroupId = G.ParentId from TGroup G where G.GroupId = @GroupId  
END  
  
--Create a Temp Table to store the group ids.  
Create Table #LegalEntityGroups  
(  
 GroupId bigint  
)  
  
--Next, Find all the groups in the Legal Entity  
--and insert into #LegalEntityGroups  
exec TraverseHierarchy @GroupId  
  
--Select the Groups in the Legal Entity.  
SELECT  
T1.GroupId,   
T1.Identifier,  
T1.GroupingId,   
ISNULL(T1.ParentId, '') AS [ParentId],   
ISNULL(T1.CRMContactId, '') AS [CRMContactId],   
T1.IndigoClientId,   
T1.LegalEntity AS [LegalEntity],   
T1.DocumentFileReference,
ISNULL(T1.GroupImageLocation, '') AS [GroupImageLocation],   
ISNULL(T1.AcknowledgementsLocation, '') AS [AcknowledgementsLocation],   
T1.FinancialYearEnd,   
T1.ApplyFactFindBranding,   
ISNULL(T1.VatRegNbr, '') AS [VatRegNbr],  
ISNULL(T1.FsaRegNbr, '') AS [FsaRegNbr],    
ISNULL(T1.FSARegNbr,'') AS [FSARegNbr],  
ISNULL(T1.AuthorisationText, '') AS [AuthorisationText],   
T1.ConcurrencyId,
ISNULL(IsFSAPassport,0) As IsFSAPassport,
ISNULL(FRNNumber,'') AS   FRNNumber,
T1.MigrationRef
FROM TGroup T1  
Where T1.IndigoClientId = @TenantId  
and T1.GroupId in (select GroupId from #LegalEntityGroups)  
  
--Drop the Temp Table  
drop table #LegalEntityGroups  
   
END  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
GO
