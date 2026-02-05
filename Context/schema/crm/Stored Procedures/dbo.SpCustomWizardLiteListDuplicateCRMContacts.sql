SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomWizardLiteListDuplicateCRMContacts]  
@IndigoClientId bigint,  
@FirstName varchar(50) = '',  
@LastName varchar(50) = '',  
@CorporateName varchar(50) = '',  
@DOB varchar(20) = '',  
@RefCRMContactStatusId bigint = 0,
@UserId bigint

AS  
BEGIN  

	declare @UserGroupId bigint
	declare @UserLegalEntityId bigint
	declare @DuplicatesOption varchar(50)

	set @DuplicatesOption = 
	(
		select [Value]
		FROM Administration..TIndigoClientPreference 
		WHERE IndigoClientId = @IndigoCLientId 
		AND PreferenceName = 'AddClient_DuplicateChecking'
	)

	IF @DuplicatesOption IS NULL
		set @DuplicatesOption = 'EntireCompany'

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
  1 AS Tag,  
  NULL AS Parent,  
  ISNULL(C.CorporateName, '') + ISNULL(C.FirstName + ' ' + C.LastName, '') AS [CRM!1!Client],  
  CONVERT(VARCHAR(12), C.DOB, 106) AS [CRM!1!DOB],  
  C.CurrentAdviserName AS [CRM!1!Adviser],  
  CASE RefCRMContactStatusId  
   WHEN 1 THEN 'Client'  
   ELSE 'Lead'  
  END AS [CRM!1!Type],  
  ast.AddressLine1 as [CRM!1!AddressLine1]

 FROM  
  TCRMContact C  
  LEFT JOIN TAddress a ON a.CRMContactId = C.CRMContactId AND a.DefaultFg = 1  
  LEFT JOIN TAddressStore ast ON a.AddressStoreId = ast.AddressStoreId  

-- group heirarchy
  JOIN Administration..TUser adviserUser ON adviserUser.CRMContactId = c.CurrentAdviserCRMId
  JOIN Administration..TGroup adviserGroup ON adviserGroup.GroupId = adviserUser.GroupId
  LEFT JOIN Administration..TGroup adviserGroup2 on adviserGroup2.groupId = adviserGroup.parentId
  LEFT JOIN Administration..TGroup adviserGroup3 on adviserGroup3.groupId = adviserGroup2.parentId
  LEFT JOIN Administration..TGroup adviserGroup4 on adviserGroup4.groupId = adviserGroup3.parentId
  LEFT JOIN Administration..TGroup adviserGroup5 on adviserGroup5.groupId = adviserGroup4.parentId
  
 WHERE  
  c.IndClientId = @IndigoClientId   
  AND (  
  (@CorporateName = '' AND FirstName = @FirstName AND LastName = @LastName) OR  
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
  AND (@DOB='' OR DOB = convert(datetime,@DOB))  
  AND RefCRMContactStatusId < 3   
  AND (@RefCRMContactStatusId = 0 OR RefCRMContactStatusId = @RefCRMContactStatusId)  
  
 FOR XML EXPLICIT  
    
END  
RETURN(0)  
GO
