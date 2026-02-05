SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomNIOSearchActiveIntroducersAdvanced      
 @UserId BIGINT,      
 @FirstName VARCHAR(255) = '%',       
 @LastNameOrCorporateName VARCHAR(255) = '%',       
 @RefIntroducerTypeId  BIGINT=-1,      
 @PractitionerId BIGINT = 0,      
 @Identifier VARCHAR(50) = '%'      
      
AS      
      
if @FirstName <> '%'      
 Select @FirstName = @FirstName + '%'      
      
if @LastNameOrCorporateName <> '%'      
 Select @LastNameOrCorporateName = @LastNameOrCorporateName + '%'      
      
if @Identifier <> '%'      
 Select @Identifier = @Identifier + '%'      
      
Declare @IndigoClientId Bigint, @GroupId Bigint      
Select @IndigoClientId = IndigoClientId, @GroupId = GroupId        
From Administration.dbo.TUser       
Where UserId = @UserId      
      
      
BEGIN      
 SELECT      
  A.CRMContactId AS [CRMContactId],      
  A.IntroducerId AS [IntroducerId],      
  A.RefIntroducerTypeId AS [RefIntroducerTypeId],      
  A.ArchiveFg AS [IsArchived],      
  ~A.ArchiveFg AS [IsActive],      
  A.Identifier AS [Identifier],      
  ISNULL(A.[UniqueIdentifier],'') AS [UniqueIdentifier],      
  A.ConcurrencyId AS [ConcurrencyId],      
  B.LongName AS [IntroducerTypeLongName],      
  B.RenewalsFG AS [IntroducerTypeCanReceiveRenewals],      
  B.DefaultSplit AS [IntroducerTypeDefaultSplitPercentage],      
  Case When ISNULL(C.CRMContactType,0) = 1 then      
   ISNULL(C.FirstName,'') + ' ' + ISNULL(C.LastName,'')      
  Else      
   ISNULL(C.CorporateName,'')       
  End AS [IntroducerName],      
  ISNULL(C.CRMContactType,0) AS [CRMContactType],      
  A.PractitionerId AS [AssignedAdviserId],      
  ISNULL(E.FirstName,'')  + ' ' + ISNULL(E.LastName,'') AS [AssignedAdviserFullName]  ,    
  '' As UserFullName,    
  '' As UserName,    
  '' AS UserStatusDisplay,  
  '' AS BranchNameDisplay   ,
  '' AS UserEmail,
  '' AS UserRole,
  '' AS AssociatedGroups,
  '' AS IntroducerClientOrUser      
      
 FROM TIntroducer A      
       
 INNER JOIN TRefIntroducerType B ON A.RefIntroducerTypeId = B.RefIntroducerTypeId      
 INNER JOIN TCRMContact C ON A.CRMContactId = C.CRMContactId      
 LEFT JOIN TPractitioner D ON D.PractitionerId = A.PractitionerId      
 LEFT JOIN TCRMContact E ON E.CRMContactId = D.CRMContactId      
      
 INNER JOIN dbo.TIntroducerGroup F      
  On F.IntroducerId = A.IntroducerId And F.GroupId = @GroupId      
 WHERE 1=1      
  And A.IndClientid = @IndigoClientId      
  And  IsNull(C.FirstName,'') Like @FirstName       
  AND IsNull(C.LastName,'') + IsNull(C.CorporateName,'') Like @LastNameOrCorporateName      
  AND IsNull(A.Identifier,'') LIKE @Identifier      
  AND ( (A.RefIntroducerTypeId = @RefIntroducerTypeId) OR (@RefIntroducerTypeId = -1) )      
  AND (A.ArchiveFG = 0)      
      
END 
GO
