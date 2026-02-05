SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SearchDuplicateParties]    
@TenantId bigint,    
@FirstName varchar(50) = '',    
@LastName varchar(50) = '',    
@CorporateName varchar(50) = '',    
@DOB DATETIME = null,    
@RefCRMContactStatusId bigint = 0,  
@UserId bigint
  
AS    
BEGIN    
  
 declare @UserGroupId bigint  
 declare @UserLegalEntityId bigint  
 declare @DuplicatesOption varchar(50)  
 declare @DuplicatesSearchTypeOption varchar(50)  
 
 SET @DuplicatesOption =   
 (  
	SELECT [Value]  
	FROM Administration..TIndigoClientPreference   
	WHERE IndigoClientId = @TenantId   
	AND PreferenceName = 'AddClient_DuplicateChecking'  
 )  
  
 IF @DuplicatesOption IS NULL  
  SET @DuplicatesOption = 'EntireCompany'  
  
 SET @DuplicatesSearchTypeOption=
 (
	SELECT [Value]  
	FROM Administration..TIndigoClientPreference   
	WHERE IndigoClientId = @TenantId   
	AND PreferenceName = 'AddClient_DuplicateChecking_SearchType'  
 )  
  
 IF @DuplicatesOption IS NULL  
  SET @DuplicatesOption = 'EntireCompany'  
  
 IF @DuplicatesSearchTypeOption = 'ByWildCardOnInitial' AND (@CorporateName = '' OR @CorporateName IS NULL)
	SET @FirstName = @FirstName +'%'
 ELSE IF @DuplicatesSearchTypeOption IS NULL AND (@CorporateName = '' OR @CorporateName IS NULL)
	SET @DuplicatesSearchTypeOption = 'ByExactFirstName'   
	
 set @UserGroupId =   
 (  
  select GroupId   
  FROM Administration..TUser   
  WHERE UserId = @UserId  
 )  
 
 set @UserLegalEntityId =   
 (  
  select GroupId   
  FROM administration..fnGetLegalEntityForUser(@UserId)  
 )   
      
  
 SELECT    
  C.CRMContactId AS [PartyId],
  C.CurrentAdviserName AS [CurrentAdviserName],    
  ISNULL(C.CorporateName, '') + ISNULL(C.FirstName + ' ' + C.LastName, '') AS [Name],    
  ast.Postcode AS [PostCode],
  CASE RefCRMContactStatusId    
   WHEN 1 THEN 'Client'    
   ELSE 'Lead'    
  END AS [ContactStatus],    
  0 AS [TypeId],
  '' AS [Type],
  ast.AddressLine1 as [AddressLine1],
  C.DOB AS [DOB],
  Cext.ExternalId AS ExternalId,
  CAST(C.ArchiveFg as bit) as IsDeleted,
  p.NINumber as NINumber

 FROM    
  TCRMContact C    
  LEFT JOIN TCRMContactExt Cext ON Cext.CRMContactId = C.CRMContactId      
  LEFT JOIN TAddress a ON a.CRMContactId = C.CRMContactId AND a.DefaultFg = 1    
  LEFT JOIN TAddressStore ast ON a.AddressStoreId = ast.AddressStoreId    
  
-- group heirarchy  
  JOIN Administration..TUser adviserUser ON adviserUser.CRMContactId = c.CurrentAdviserCRMId  
  JOIN Administration..TGroup adviserGroup ON adviserGroup.GroupId = adviserUser.GroupId  
  LEFT JOIN Administration..TGroup adviserGroup2 on adviserGroup2.groupId = adviserGroup.parentId  
  LEFT JOIN Administration..TGroup adviserGroup3 on adviserGroup3.groupId = adviserGroup2.parentId  
  LEFT JOIN Administration..TGroup adviserGroup4 on adviserGroup4.groupId = adviserGroup3.parentId  
  LEFT JOIN Administration..TGroup adviserGroup5 on adviserGroup5.groupId = adviserGroup4.parentId  

-- Ni number
  LEFT JOIN TPerson p ON c.PersonId = p.PersonId
    
 WHERE    
  c.IndClientId = @TenantId     
   AND 
  ( 
   (@DuplicatesSearchTypeOption = 'ByExactFirstName' AND @CorporateName = '' AND C.FirstName = @FirstName AND C.LastName = @LastName) 
    OR
   (@DuplicatesSearchTypeOption = 'ByWildCardOnInitial' AND @CorporateName = '' AND C.FirstName like @FirstName AND C.LastName = @LastName)
	OR    
   (@FirstName = '' AND @LastName = '' AND CorporateName=@CorporateName)    
  )  
  AND  
  (  
	@DuplicatesOption = 'EntireCompany'   
	OR   
	(@DuplicatesOption = 'LegalEntityOnly' AND ( (adviserGroup.LegalEntity = 1 and adviserGroup.GroupId = @UserLegalEntityId) OR (adviserGroup2.LegalEntity = 1 and adviserGroup2.GroupId = @UserLegalEntityId) OR (adviserGroup3.LegalEntity = 1 and adviserGroup3.GroupId = @UserLegalEntityId) OR (adviserGroup4.LegalEntity = 1 and adviserGroup4.GroupId = @UserLegalEntityId) OR (adviserGroup5.LegalEntity = 1 and adviserGroup5.GroupId = @UserLegalEntityId) ) )  
	OR  
	(@DuplicatesOption = 'GroupOnly' AND (adviserGroup.GroupId= @UserGroupId) )  
  )  
  AND (@DOB IS NULL OR C.DOB = @DOB)
  AND RefCRMContactStatusId < 3
  AND (@RefCRMContactStatusId = 0 OR RefCRMContactStatusId = @RefCRMContactStatusId)
  AND C.ArchiveFg = 0
         
END    
GO
