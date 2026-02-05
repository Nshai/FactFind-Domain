SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.SpCustomNIOSearchIntroducerUsersAdvanced    
@UserId BIGINT,    
 @UserFirstName VARCHAR(255) = '%',     
 @UserLastName VARCHAR(255) = '%',     
 @CorporateName VARCHAR(255) = '%',    
 @BranchName VARCHAR(255) = '%',    
 @RefIntroducerTypeId  BIGINT=-1,    
 @UserStatus VARCHAR(255) = '%'    
    
AS    
    
Declare @IndigoClientId Bigint, @GroupId Bigint      
Select @IndigoClientId = IndigoClientId, @GroupId = GroupId        
From Administration.dbo.TUser       
Where UserId = @UserId      
  
BEGIN    

-- Select the query first on the criteria.
SELECT      
	DISTINCT
  I.CRMContactId AS [CRMContactId],      
  I.IntroducerId AS [IntroducerId],      
  I.RefIntroducerTypeId AS [RefIntroducerTypeId],      
  I.ArchiveFg AS [IsArchived],      
  ~I.ArchiveFg AS [IsActive],      
  I.Identifier AS [Identifier],      
  ISNULL(I.[UniqueIdentifier],'') AS [UniqueIdentifier],      
  I.ConcurrencyId AS [ConcurrencyId],      
  IT.LongName AS [IntroducerTypeLongName],      
  IT.RenewalsFG AS [IntroducerTypeCanReceiveRenewals],      
  IT.DefaultSplit AS [IntroducerTypeDefaultSplitPercentage],      
  ISNULL(C2.CorporateName,'') AS [IntroducerName],      
  ISNULL(C2.CRMContactType,0) AS [CRMContactType],      
  I.PractitionerId AS [AssignedAdviserId],      
  '' AS [AssignedAdviserFullName]  ,    
  ISNULL(C1.FirstName,'')  + ' ' + ISNULL(C1.LastName,'') As UserFullName,    
  U.Identifier As UserName,    
  U.Status AS UserStatusDisplay,  
  CONVERT(varchar(1000), '') AS BranchNameDisplay,  
  EB.IntroducerEmployeeId,
  U.Email AS UserEmail,  
  R.Identifier AS UserRole,  
 STUFF((  
 SELECT ',' + G.Identifier  
   FROM TIntroducerGroup t1   
   INNER JOIN administration..tgroup G  
   ON G.GroupId = T1.GroupId  
  WHERE T1.IntroducerId = I.IntroducerId  
 FOR XML PATH('')),1,1,'') AssociatedGroups, -- Get the comma seperated associated groups for this introducer.  
  '' AS IntroducerClientOrUser      
  
  INTO #TempTABLE
  
  FROM TIntroducerEmployee E  
			INNER JOIN CRM..TIntroducerEmployeeBranch EB ON EB.IntroducerEmployeeId = E.IntroducerEmployeeId
 INNER JOIN TIntroducer I ON I.IntroducerId = E.IntroducerId  
 INNER JOIN Administration..TUser U ON U.UserId = E.UserId  
 INNER JOIN TCRMContact C1 ON C1.CRMContactId = U.CRMContactId  
 INNER JOIN TCRMContact C2 ON C2.CRMContactId = I.CRMContactId  
 INNER JOIN TRefIntroducerType IT ON IT.RefIntroducerTypeId = I.RefIntroducerTypeId      
 LEFT  JOIN TPractitioner P ON P.PractitionerId = I.PractitionerId      
			INNER JOIN TIntroducerBranch B ON B.IntroducerBranchId = EB.IntroducerBranchId  
 INNER JOIN Administration..TRole R ON R.RoleId = U.ActiveRole  
  
 WHERE 1=1      
  And E.TenantId = @IndigoClientId      
  AND (@UserFirstName IS NULL OR C1.FirstName LIKE @UserFirstName + '%')     
  AND (@UserLastName IS NULL OR C1.LastName LIKE @UserLastName + '%')     
  AND (@CorporateName IS NULL OR C2.CorporateName LIKE @CorporateName + '%')  
  AND (@BranchName IS NULL OR B.BranchName LIKE @BranchName + '%')  
  AND ( (I.RefIntroducerTypeId = @RefIntroducerTypeId) OR (@RefIntroducerTypeId = -1) )      
  AND (@UserStatus IS NULL OR U.Status LIKE @UserStatus + '%')  
    
 -- Update the Temp Table for comma seperated Branch Names
 UPDATE A 
	SET BranchNameDisplay = 
	STUFF((  
		 SELECT ',' + C.BranchName  
		   From CRM..TIntroducerEmployeeBranch b 
		Join TIntroducerBranch C ON B.IntroducerBranchId = C.IntroducerBranchId
		  WHERE A.IntroducerEmployeeId = b.IntroducerEmployeeId
		 FOR XML PATH('')),1,1,'')
 From #TempTABLE A
    
    
 -- Return the searched data in Select Query
 SELECT * FROM #TempTABLE
    
END    
    