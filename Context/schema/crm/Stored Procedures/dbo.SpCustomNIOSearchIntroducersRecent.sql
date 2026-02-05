SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomNIOSearchIntroducersRecent      
 @ListOfIds varchar(2000),      
 @UserId bigint      
 --@TenantId bigint      
As      
      
Declare @IndigoClientId Bigint, @GroupId Bigint      
Select @IndigoClientId = IndigoClientId, @GroupId = GroupId        
From Administration.dbo.TUser       
Where UserId = @UserId      
      
If object_id('tempdb..#Tally') Is Null      
Begin      
	Select Top 11000 Identity(int,1,1) AS N         
	Into #Tally      
	From master.dbo.SysColumns sc1,              
	master.dbo.SysColumns sc2      
      
	declare @sql nvarchar(255) = N'
	Alter Table #Tally
	Add Constraint PK_Tally_N' + cast(@@spid as nvarchar) + N'
	Primary Key Clustered (N) With FillFactor = 100'
	exec sp_executesql @sql
End      
      
Declare @InternalListOfIds varchar(2000)      
Select @InternalListOfIds = LTrim(RTrim(@ListOfIds))      
If Right(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = @InternalListOfIds + ','      
If Left(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = ',' + @InternalListOfIds      
      
Declare @RecentIds Table ( RecentId int )      
      
Insert Into @RecentIds      
( RecentId )       
Select substring(@InternalListOfIds, N+1, CHARINDEX(',', @InternalListOfIds, N+1) -N -1)         
FROM #Tally        
WHERE N < LEN(@InternalListOfIds)      
 AND SUBSTRING(@InternalListOfIds, N, 1) = ','      
      
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
  ISNULL(E.FirstName,'')  + ' ' + ISNULL(E.LastName,'') AS [AssignedAdviserFullName] ,    
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
  and A.IntroducerId in (Select RecentId From @RecentIds)      
      
END 
GO
