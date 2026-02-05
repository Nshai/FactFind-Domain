USE [crm]
GO

/****** Object:  StoredProcedure [dbo].[pGatewayClientSearchCount]    Script Date: 09/02/2024 12:11:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pGatewayClientSearchCount] 
      @tenantId INT
     ,@SQLWhere NVARCHAR(max) = '1=1'
     ,@Reach NVARCHAR(max) = ''
     ,@CallerUserId INT = NULL
AS
-- ***************************************************************************************    
--      
-- NOTE ANY CHANGES TO THIS STORED PROC need to be repliacted in pGatewayClientSearchCount      
-- =======================================================================================      
--      
-- ***************************************************************************************      
/* Called from .NET with these restraints      
      
  /// * `id` (`eq`, `in`)      
  /// * `corporate.name` (`eq`, `startswith`)      
  /// * `currentAdviser.id` (`eq`, `in`)      
  /// * `group.id` (`eq`, `in`)      
  /// * `person.dateOfBirth` (`eq`)      
  /// * `person.firstName` (`eq`, `startswith`)      
  /// * `person.lastName` (`eq`, `startswith`)      
  /// * `person.niNumber` (`eq`, `startswith`, `in`)      
  /// * `externalReference` (`eq`, `startswith`)      
  /// * `secondaryReference` (`eq`, `startswith`)      
  /// * `trust.name` (`eq`, `startswith`)      
  /// * `tag` (`in`)      
      
  Related to pGatewayClientSearch but returns the total count      
*/

DECLARE @SQL NVARCHAR(max) = ''
DECLARE @CRMContactIds TABLE (CRMContactId INT NOT NULL PRIMARY KEY);

-- Check if the user exists and is neither a SuperUser nor a SuperViewer
DECLARE @IsRestrictedUserAccess BIT = 
    CASE 
        WHEN @Reach NOT IN ('system', 'tenant') AND 
             NOT EXISTS (
				SELECT 1
				FROM administration.dbo.TUser
				WHERE UserId = @CallerUserId
                  AND (SuperUser = 1 OR SuperViewer = 1)
			 )
		THEN 1
		ELSE 0
	END;

--Mappings from .Net field names to col names      
SET @SQLWhere = REPLACE(@SQLWhere, 'currentAdviser.id', 'Practitioner.PractitionerId')
SET @SQLWhere = REPLACE(@SQLWhere, 'group.id', 'C.groupid')
SET @SQLWhere = REPLACE(@SQLWhere, ' id', ' C.CRMContactId')
SET @SQLWhere = IIF(LEFT(@SQLWhere, 2) = 'id', REPLACE(@SQLWhere, 'id', 'C.CRMContactId'), @SQLWhere)
SET @SQLWhere = REPLACE(@SQLWhere, 'person.firstName', 'C.FirstName') -- NOTE this should be on the Person table, firstname is a dupliacate field and is not consistantly populated on TCRMContact      
SET @SQLWhere = REPLACE(@SQLWhere, 'person.lastName', 'C.LastName') -- NOTE this should be on the Person table, firstname is a dupliacate field and is not consistantly populated on TCRMContact      
SET @SQLWhere = REPLACE(@SQLWhere, 'person.dateOfBirth', 'C.DOB') -- Note there is a data inconsistancy between the DOB on TPerson and TCRMContact, this should probably be from C.Person      
SET @SQLWhere = REPLACE(@SQLWhere, 'externalReference', 'C.ExternalReference')
SET @SQLWhere = REPLACE(@SQLWhere, 'secondaryReference', 'C.AdditionalRef')
SET @SQLWhere = REPLACE(@SQLWhere, 'Corporate.Name', 'Corporate.CorporateName')
SET @SQLWhere = REPLACE(@SQLWhere, 'Tag IN', 'TG.Name IN')
SET @SQLWhere = REPLACE(@SQLWhere, 'Trust.Name', 'Trust.TrustName')

-- Build filter SQL      
SET @SQL = N'      
SELECT DISTINCT Id = C.CRMContactId      
FROM dbo.TCRMContact C       
' + IIF(@SQLWhere LIKE '%Practitioner.%', ' LEFT JOIN CRM..TPractitioner Practitioner ON Practitioner.CRMContactId = C.CurrentAdviserCRMId', '') 
  + IIF(@SQLWhere LIKE '%Person.%', ' LEFT JOIN CRM..TPerson Person ON Person.PersonId = C.PersonId', '') 
  + IIF(@SQLWhere LIKE '%Corporate.%', ' LEFT JOIN CRM..TCorporate Corporate ON Corporate.CorporateId = C.CorporateId', '') 
  + IIF(@SQLWhere LIKE '%Trust.%', ' LEFT JOIN CRM..TTrust Trust ON Trust.TrustId = C.TrustId', '') 
  + IIF(@SQLWhere LIKE '%TG.Name IN %(%', ' LEFT JOIN CRM..TTag TG ON TG.EntityType = ''Party'' AND TG.EntityId = C.CRMContactId', '')
  + IIF(@SQLWhere LIKE '%TC.%', ' LEFT JOIN CRM..TContact TC ON TC.CRMContactId = C.CRMContactId AND TC.RefContactType = ''E-Mail''', '')

	-- Additional logic for user reach    
	+ IIF(@IsRestrictedUserAccess = 1, ' LEFT OUTER JOIN Crm.dbo.VwCRMContactKeyByEntityId tekey1_     
         ON C.CRMContactId = tekey1_.EntityId     
         AND tekey1_.UserId = ' + CAST(@CallerUserId AS NVARCHAR(10)) + '     
       LEFT OUTER JOIN Crm.dbo.VwCRMContactKeyByCreatorId tckey2_     
         ON C._OwnerId = tckey2_.CreatorId     
         AND tckey2_.UserId = ' + CAST(@CallerUserId AS NVARCHAR(10)), '') + '     

WHERE C.RefCrmContactStatusId = 1  
  AND C.ArchiveFg = 0  
  AND (C.InternalContactFG = 0 OR C.InternalContactFG IS NULL)
  AND C.IndClientId = ' + CAST(@tenantId AS NVARCHAR(10)) + '     
  ' + IIF(@IsRestrictedUserAccess = 1, 'AND (C._OwnerId = ' + CAST(@CallerUserId AS NVARCHAR(10)) + '     
        OR (tckey2_.CreatorId IS NOT NULL OR tekey1_.EntityId IS NOT NULL))', '') + ' 
  AND ' + @SQLWhere + '
  
ORDER BY C.CRMContactId'

-- Populate with just the relevant Ids to filter the main query below.        
INSERT @CRMContactIds
EXEC sp_executesql @SQL
	,N'@tenantId INT, @CallerUserId INT'
	,@tenantId
	,@CallerUserId;

-- Just return the count      
SELECT CountOfSearchResults = @@Rowcount

GO