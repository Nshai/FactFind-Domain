USE [crm]
GO

/****** Object:  StoredProcedure [dbo].[pGatewayClientSearch]    Script Date: 09/02/2024 12:11:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pGatewayClientSearch] 
	 @tenantId INT
	,@top INT = 100
	,@skip INT = 0
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

ORDER BY C.CRMContactId    
OFFSET @Skip ROWS FETCH NEXT @top ROWS ONLY;'

PRINT @sql

-- Populate with just the relevant Ids to filter the main query below.        
INSERT @CRMContactIds
EXEC sp_executesql @SQL
	,N'@tenantId INT, @top INT = 100, @skip INT = 0, @CallerUserId INT'
	,@tenantId
	,@top
	,@skip
	,@CallerUserId;

-- Main query split into 2 for performance.      
SELECT DISTINCT C.CRMContactId AS C_CRMContactId
	,C.CRMContactType AS C_CRMContactType
	,C.ClientTypeId AS C_ClientTypeId
	,C.PersonId AS C_PersonId
	,C.CorporateId AS C_CorporateId
	,C.TrustId AS C_TrustId
	,C.ArchiveFg AS C_ArchiveFg
	,C.OriginalAdviserCRMId AS C_OriginalAdviserCRMId
	,C.CurrentAdviserCRMId AS C_CurrentAdviserCRMId
	,C.IndClientId AS C_IndClientId
	,C.IsDeleted AS C_IsDeleted
	,C.GroupId AS C_GroupId
	,C.IsHeadOfFamilyGroup AS C_IsHeadOfFamilyGroup
	,C.CreatedDate AS C_CreatedDate
	,C.ExternalReference AS C_ExternalReference
	,C.MigrationRef AS C_MigrationRef
	,C.AdditionalRef AS C_AdditionalRef
	,C.CampaignDataId AS C_CampaignDataId
	,C.RefServiceStatusId AS C_RefServiceStatusId
	,C.ServiceStatusStartDate AS C_ServiceStatusStartDate
	,CE.ParaplannerUserId AS CE_ParaplannerUserId
	,CE.ServicingAdminUserId AS CE_ServicingAdminUserId
	,CE.TaxReferenceNumber AS CE_TaxReferenceNumber
	,AO.PractitionerId AS AO_AdviserId
	,AOP.FirstName AS AOP_FirstName
	,AOP.LastName AS AOP_LastName
	,AC.PractitionerId AS AC_AdviserId
	,ACP.FirstName AS ACP_FirstName
	,ACP.LastName AS ACP_LastName
	,S.ServiceStatusName AS S_ServiceStatusName
	,U.UserId AS U_UserId
	,U.IndigoClientId AS U_TenantId
	,A.HasValidWill AS A_HasValidWill
	,A.IsWillUptoDate AS A_IsWillUptoDate
	,V.CountryOfOrigin AS V_CountryOfOrigin
	,V.PlaceOfBirth AS V_PlaceOfBirth
	,V.PlaceOfBirthOther AS V_PlaceOfBirthOther
	,V.CountryOfBirth AS V_CountryOfBirth
	,D.DeceasedFG AS D_DeceasedFG
	,D.DeceasedDate AS D_DeceasedDate
INTO #One
FROM CRM..TCRMContact C
LEFT OUTER JOIN CRM..TCRMContactExt CE ON CE.CRMContactId = C.CRMContactId
LEFT OUTER JOIN Administration..TUser U ON U.CRMContactId = C.CRMContactId
LEFT OUTER JOIN Crm..TDeceased D ON D.CRMContactId = C.CRMContactId
LEFT OUTER JOIN FactFind..TAdviceareas A ON A.CRMContactId = C.CRMContactId
LEFT OUTER JOIN CRM..TVerification V ON V.CRMContactId = C.CRMContactId
LEFT OUTER JOIN CRM..TPractitioner AC ON AC.CRMContactId = C.CurrentAdviserCRMId
	AND ac.IndClientId = c.IndClientId
LEFT OUTER JOIN CRM..TCRMContact ACP ON ACP.CRMContactId = C.CurrentAdviserCRMId
LEFT OUTER JOIN CRM..TPractitioner AO ON AO.CRMContactId = C.OriginalAdviserCRMId
LEFT OUTER JOIN CRM..TCRMContact AOP ON AOP.CRMContactId = C.OriginalAdviserCRMId
LEFT OUTER JOIN CRM..TRefServiceStatus S ON S.RefServiceStatusId = C.RefServiceStatusId
WHERE C.CrmContactId IN (
		SELECT CrmContactId
		FROM @CRMContactIds
		)
ORDER BY C.CRMContactId;

SELECT DISTINCT C.C_CRMContactId
	,C.C_CRMContactType
	,C.C_ClientTypeId
	,C.C_PersonId
	,C.C_CorporateId
	,C.C_TrustId
	,C.C_ArchiveFg
	,C.C_OriginalAdviserCRMId
	,C.C_CurrentAdviserCRMId
	,C.C_IndClientId
	,C.C_IsDeleted
	,C.C_GroupId
	,C.C_IsHeadOfFamilyGroup
	,C.C_CreatedDate
	,C.C_ExternalReference
	,C.C_MigrationRef
	,C.C_AdditionalRef
	,C.C_CampaignDataId
	,C.C_RefServiceStatusId
	,C.C_ServiceStatusStartDate
	,C.CE_ParaplannerUserId
	,C.CE_ServicingAdminUserId
	,C.CE_TaxReferenceNumber
	,CA.Description AS CA_Reference
	,CAM.CampaignName AS CAM_CampaignName
	,CT.CampaignType AS CT_CampaignType
	,C.AO_AdviserId
	,C.AOP_FirstName
	,C.AOP_LastName
	,C.AC_AdviserId
	,C.ACP_FirstName
	,C.ACP_LastName
	,c.S_ServiceStatusName
	,c.U_UserId
	,c.U_TenantId
	,P.PersonId AS P_PersonId
	,P.Title AS P_Title
	,P.FirstName AS P_FirstName
	,P.MiddleName AS P_MiddleName
	,P.LastName AS P_LastName
	,P.MaidenName AS P_MaidenName
	,P.DOB AS P_DateOfBirth
	,P.GenderType AS P_GenderType
	,P.NINumber AS P_NINumber
	,P.IsSmoker AS P_IsSmoker
	,P.UKResident AS P_UKResident
	,P.ResidentIn AS P_ResidentIn
	,P.Salutation AS P_Salutation
	,P.RefSourceTypeId AS P_RefSourceTypeId
	,P.IntroducerSource AS P_IntroducerSource
	,P.MaritalStatus AS P_MaritalStatus
	,P.MarriedOn AS P_MarriedOn
	,P.Residency AS P_Residency
	,P.UKDomicile AS P_UKDomicile
	,P.Domicile AS P_Domicile
	,P.TaxCode AS P_TaxCode
	,P.Nationality AS P_Nationality
	,P.ArchiveFG AS P_ArchiveFG
	,P.IndClientId AS P_TenantId
	,P.Salary AS P_Salary
	,P.RefNationalityId AS P_RefNationalityId
	,ISNULL(TT.RefTitleId, 0) AS RefTitleId
	,P.Expatriate AS P_Expatriate
	,P.HasSmokedInLast12Months AS P_HasSmokedInLast12Months
	,P.IsInGoodHealth AS P_IsInGoodHealth
	,P.IsPowerOfAttorneyGranted AS P_IsPowerOfAttorneyGranted
	,P.AttorneyName AS P_AttorneyName
	,P.IsDisplayTitle AS P_IsDisplayTitle
	,P.MaritalStatusSince AS P_MaritalStatusSince
	,P.UpdatedOn AS P_UpdatedOn
	,P.CreatedOn AS P_CreatedOn
	,P.CreatedByUserId AS P_CreatedByUserId
	,P.UpdatedByUserId AS P_UpdatedByUserId
	,p.NationalClientIdentifier AS P_NationalClientIdentifier
	,p.CountryCodeOfResidence AS P_CountryCodeOfResidence
	,p.CountryCodeOfDomicile AS P_CountryCodeOfDomicile
	,C.A_HasValidWill
	,C.A_IsWillUptoDate
	,N.ISOAlpha2Code AS N_ISOAlpha2Code
	,N.ISOAlpha3Code AS N_ISOAlpha3Code
	,NN.CountryName AS NN_CountryName
	,C.V_CountryOfOrigin
	,C.V_PlaceOfBirth
	,C.V_PlaceOfBirthOther
	,C.V_CountryOfBirth
	,COO.CountryName AS COO_CountryName
	,COO.CountryCode AS COO_CountryCode
	,COB.CountryName AS COB_CountryName
	,COB.CountryCode AS COB_CountryCode
	,CR.CountryCode AS CR_CountryCode
	,CR.CountryName AS CR_CountryName
	,CD.CountryCode AS CD_CountryCode
	,CD.CountryName AS CD_CountryName
	,C.D_DeceasedFG
	,C.D_DeceasedDate
	,T.RefTrustTypeId AS T_RefTrustTypeId
	,T.IndClientId AS T_TenantId
	,T.TrustName AS T_TrustName
	,T.EstDate AS T_EstDate
	,T.ArchiveFG AS T_ArchiveFG
	,T.UpdatedOn AS T_UpdatedOn
	,T.CreatedOn AS T_CreatedOn
	,T.CreatedByUserId AS T_CreatedByUserId
	,T.UpdatedByUserId AS T_UpdatedByUserId
	,T.LEI AS T_LegalEntity
	,T.LEIExpiryDate AS T_LegalEntityExpiryDate
	,T.RegistrationNumber AS T_RegistrationNumber
	,T.RegistrationDate AS T_RegistrationDate
	,T.Instrument AS T_Instrument
	,T.BusinessRegistrationNumber AS T_BusinessRegistrationNumber
	,T.NatureOfTrust AS T_NatureOfTrust
	,T.VatRegNo AS T_VatRegNo
	,T.EstablishmentCountryId AS T_EstablishmentCountryId
	,T.ResidenceCountryId AS T_ResidenceCountryId
	,TRT.TrustTypeName AS TRT_TrustTypeName
	,CO.IndClientId AS CO_TenantId
	,CO.CorporateName AS CO_CorporateName
	,CO.ArchiveFg AS CO_ArchiveFg
	,CO.BusinessType AS CO_BusinessType
	,CO.RefCorporateTypeId AS CO_RefCorporateTypeId
	,CO.CompanyRegNo AS CO_CompanyRegNo
	,CO.EstIncorpDate AS CO_EstIncorpDate
	,CO.YearEnd AS CO_YearEnd
	,CO.VatRegFg AS CO_VatRegFg
	,CO.VatRegNo AS CO_VatRegNo
	,CO.UpdatedOn AS CO_UpdatedOn
	,CO.CreatedOn AS CO_CreatedOn
	,CO.CreatedByUserId AS CO_CreatedByUserId
	,CO.UpdatedByUserId AS CO_UpdatedByUserId
	,CO.LEI AS CO_LegalEntity
	,CO.LEIExpiryDate AS CO_LegalEntityExpiryDate
	,CO.BusinessRegistrationNumber AS CO_BusinessRegistrationNumber
	,COT.TypeName AS COT_TypeName
FROM #One c
LEFT OUTER JOIN CRM..TCampaignData CA ON CA.CampaignDataId = C.C_CampaignDataId
LEFT OUTER JOIN CRM..TCampaign CAM ON CAM.CampaignId = CA.CampaignId
LEFT OUTER JOIN CRM..TCampaignType CT ON CT.CampaignTypeId = CAM.CampaignTypeId
LEFT OUTER JOIN CRM..TPerson P ON P.PersonId = C.C_PersonId
LEFT OUTER JOIN CRM..TRefTitle TT ON TT.TitleName = P.Title
LEFT OUTER JOIN CRM..TRefCountry CR ON CR.CountryCode = P.CountryCodeOfResidence
	AND CR.ArchiveFG = 0
LEFT OUTER JOIN CRM..TRefCountry CD ON CD.CountryCode = P.CountryCodeOfDomicile
	AND CD.ArchiveFG = 0
LEFT OUTER JOIN CRM..TPersonCitizenship Z ON Z.PersonId = P.PersonId
LEFT OUTER JOIN CRM..TRefNationality2RefCountry N ON N.RefNationalityId = P.RefNationalityId
LEFT OUTER JOIN CRM..TRefCountry NN ON NN.RefCountryId = N.RefCountryId
LEFT OUTER JOIN CRM..TRefCountry COO ON COO.CountryName = C.V_CountryOfOrigin
	AND COO.ArchiveFG = 0
LEFT OUTER JOIN CRM..TRefCountry COB ON COB.CountryCode = C.V_CountryOfBirth
	AND COB.ArchiveFG = 0
LEFT OUTER JOIN CRM..TTrust T ON T.TrustId = C.C_TrustId
LEFT OUTER JOIN CRM..TRefTrustType TRT ON TRT.RefTrustTypeId = T.RefTrustTypeId
LEFT OUTER JOIN CRM..TCorporate CO ON CO.CorporateId = C.C_CorporateId
LEFT OUTER JOIN CRM..TRefCorporateType COT ON COT.RefCorporateTypeId = CO.RefCorporateTypeId
ORDER BY C.C_CRMContactId

GO