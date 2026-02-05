SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchClientBasicSecure]
	(
		@CorporateName VARCHAR(255) = NULL,
		@FirstName VARCHAR(255) = NULL,    
		@MiddleName VARCHAR(200) = NULL,
		@LastName VARCHAR(255) = NULL,
		@PolicyNumber VARCHAR(50) = NULL,
		@RefProdProviderId BIGINT = 0,    
		@ServicingAdviserPartyId BIGINT = 0,
		@SequentialRefType varchar(50) = NULL,
		@SequentialRef varchar(50) = NULL,
		@Postcode VARCHAR(10)= NULL,
		@ExcludeDeceased bit = 0,
		@_TenantId BIGINT,
		@_UserId BIGINT,    
		@_TopN INT = 0 
	)
	
WITH RECOMPILE
AS

---------------------------------------------------------------------------------------------------------------------------------------    
-- PLEASE NOTE!!!!:
---------------------------------------------------------------------------------------------------------------------------------------
-- This stored procedure is for the sole purpose of serving as a backup search if the Search Database is unavailable for some reason
-- All the Search Permutations have purposefully been included in this one stored procedure (as opposed to spliiting permutations up 
-- into seperate optimised Stored Procedures. The reason for this is maintenance. Because this is only a backup,
--		1. It will most probably not be used for long periods
--		2. It will most probably be forgotten about if any changes are made to the main search and if more than one sp was used, it
--		   will take longer to bring them up to scratch when an emergency requires it. (and let's face it, this search will only be required in an emergency)
---------------------------------------------------------------------------------------------------------------------------------------
      
/*     
dbo.nio_SpCustomSearchClientBasicSecure 
	@_TenantId = 99, 
	@_UserId = 14665,
	@PolicyNumber = NULL, 
	@RefProdProviderId = NULL, 
	@ServicingAdviserPartyId = NULL,
	@SequentialRefType = 'AdviceCaseRef',
	@SequentialRef  = '5216546',
	@CorporateName = NULL,    
	@FirstName = 'Fred',    
	@LastName = 'Dun',
	@Postcode = NULL
*/   
DECLARE @IncludeDeceased bit
SET @IncludeDeceased = CASE @ExcludeDeceased
						WHEN 0 THEN 1
						ELSE 0
						END

SELECT @FirstName = REPLACE(@FirstName, '''', '''''') 
SELECT @MiddleName = REPLACE(@MiddleName, '''', '''''') 
SELECT @LastName = REPLACE(@LastName, '''', '''''') 
SELECT @PolicyNumber = REPLACE(@PolicyNumber, '''', '''''') 
SELECT @CorporateName = REPLACE(@CorporateName, '''', '''''') 

DECLARE @_TenantId2 BIGINT  
SET @_TenantId2 = @_TenantId   
  
-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
DECLARE @LighthousePreExistingAdviceType BIGINT    
    
SELECT @RightMask = 1, @AdvancedMask = 0    
SELECT @LighthousePreExistingAdviceType = 3151

SET NOCOUNT ON

-- SuperUser and SuperViewer processing 
-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers
-- A negative Id results in Entity Security being overridden
IF(@_UserId > 0) BEGIN

	IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1)) 
		SET @_UserId = @_UserId * -1

END

-- If the SequentialRef is not for an Advice Case and has been passed in without the Prefix (IOB, IOR, IOF)...
IF (@SequentialRefType != 'AdviceCaseRef' AND ISNUMERIC(@SequentialRef) = 1) BEGIN

	-- ...Pad the number so that the total length is 8 digits...
	SET @SequentialRef = RIGHT(REPLICATE('0', 8) + @SequentialRef, 8)
	
	-- ...And append the relevant prefix.
	IF @SequentialRefType = 'PlanIOBRef' BEGIN  
		SELECT @SequentialRef = 'IOB' + @SequentialRef
	END
	---------------------------------------------------
	ELSE IF @SequentialRefType = 'FeeIOFRef' BEGIN
		SELECT @SequentialRef = 'IOF' + @SequentialRef
	END
	---------------------------------------------------  
	ELSE IF @SequentialRefType= 'RetainerIORRef' BEGIN
		SELECT @SequentialRef = 'IOR' + @SequentialRef
	END 
	
END

---------------------------------------------------------------------------------------    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
  EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT
    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
    
DECLARE @SqlScript1 VARCHAR(8000)  
  
CREATE TABLE #TmpSearchClientBasicSecureDefault 
(  
	CRMContactId VARCHAR(20),    
	CRMContactType VARCHAR(3),    
	AdvisorRef VARCHAR(50),    
	CurrentAdvisername VARCHAR(255),
	Title VARCHAR(50),
	LastName VARCHAR(150),  
	MiddleName VARCHAR(200),  
	FirstName VARCHAR(150),    
	CorporateName VARCHAR(255),    
	PolicyBusinessId BIGINT,    
	ChangedToDate VARCHAR(10),    
	PolicyNumber  VARCHAR(255),    
	ProductName VARCHAR(255),    
	ProviderName VARCHAR(128),
	PolicyStatus VARCHAR(50),    
	PolicyType VARCHAR(255),    
	ExternalReference VARCHAR(255),
	AdditionalRef VARCHAR(255),
	CreditedGroup VARCHAR(255),
	[Group] VARCHAR(255),
	UserGroupId BIGINT,    
	OrganisationGroupId BIGINT,    
	IOBReference VARCHAR(50),
	IsDeceased bit
)

DECLARE @TPostCodeSearch TABLE
(
	CRMContactId BIGINT NOT NULL PRIMARY KEY,
	AddressStoreId BIGINT
)

-- Don't allow a '%' search on Postcode which is pointless anyway
IF (ISNULL(@Postcode, '%') != '%') BEGIN

	INSERT 
		@TPostCodeSearch
	SELECT
		DISTINCT
		CRMContactId,
		AD.AddressStoreId
	FROM
		TAddress AD
		JOIN TAddressStore ADS ON ADS.AddressStoreId = AD.AddressStoreId
	WHERE
		AD.IndClientId = @_TenantId
		AND
		ADS.PostCode like @Postcode

END
  
BEGIN    
SELECT @SqlScript1 = 
'INSERT INTO
	#TmpSearchClientBasicSecureDefault    
	(
		CRMContactId,		
		CRMContactType,    
		AdvisorRef,    
		CurrentAdviserName,    
		Title,
		LastName,  
		MiddleName,  
		FirstName,    
		CorporateName,     
		PolicyBusinessId,    
		ChangedToDate,    
		PolicyNumber,
		ProductName,   
		ProviderName, 
		PolicyStatus, 
		PolicyType,    
		ExternalReference, 
		AdditionalRef,
		CreditedGroup,
		[Group],		
		IOBReference,
		IsDeceased
	)  
SELECT    
	T1.CRMContactId,     
	T1.CRMContactType,     
	ISNULL(T1.AdvisorRef, ''''),     
	ISNULL(T1.CurrentAdviserName, ''''), 
	ISNULL(P.Title, ''''),
	ISNULL(T1.LastName, ''''), 
	ISNULL(T1.MiddleName, ''''),    
	ISNULL(T1.FirstName, ''''),     
	ISNULL(T1.CorporateName, ''''),     
	ISNULL(Plans.PolicyBusinessId, 0),    
	Plans.ChangedToDate,    
	ISNULL(Plans.PolicyNumber, ''''),    
	ISNULL(Plans.ProductName, ''''),   
	ISNULL(Plans.CorporateName, ''''),  
	ISNULL(Plans.[Name], ''''),    
	ISNULL(Plans.PlanTypeName, ''''),    
	ISNULL(T1.ExternalReference, ''''),
	ISNULL(T1.AdditionalRef, ''''),
	ISNULL(G.Identifier, ''''),
	ISNULL(Plans.[SequentialRef], ''''),
	CASE ss.ServiceStatusName 
		WHEN ''''Deceased'''' THEN 1 
		ELSE 0
	END AS IsDeceased
FROM     
	TCRMContact T1  WITH(NOLOCK)
	LEFT JOIN CRM..TPerson P ON P.PersonId = T1.PersonId
	LEFT JOIN TCRMContactExt T1Ext ON T1Ext.CRMContactId = T1.CRMContactId
	LEFT JOIN Administration..TGroup G ON G.GroupId = T1Ext.CreditedGroupId
	LEFT JOIN TRefServiceStatus ss ON T1.RefServiceStatusId = ss.RefServiceStatusId
	LEFT JOIN administration..TGroup GR ON T1.GroupId = GR.GroupId
	LEFT JOIN
	(    
		SELECT    
			T2.CRMContactId,    
			T7.PolicyNumber,    
			T7.ProductName,    
			T6.RefPlanTypeId,    
			T6.PlanTypeName,    
			T8.RefProdProviderId,    
			ISNULL(CONVERT(VARCHAR,T10.ChangedToDate,103),''n/a'') ChangedToDate,    
			T9.CorporateName,  --Provider Name    
			T11.[Name],   
			T7.PolicyBusinessId,  
			T7.SequentialRef		  
		FROM   
			PolicyManagement..TPolicyDetail T3  WITH(NOLOCK)
			JOIN PolicyManagement..TPolicyBusiness T7 WITH(NOLOCK) ON T3.PolicyDetailId = T7.PolicyDetailId   
				AND T3.IndigoClientId = '+CONVERT(VARCHAR(50), @_TenantId2)+'  
				AND T7.IndigoClientId = '+CONVERT(VARCHAR(50), @_TenantId2)+'  
			JOIN PolicyManagement..TPolicyOwner T2  WITH(NOLOCK)  ON T2.PolicyDetailId = T3.PolicyDetailId    
			JOIN PolicyManagement..TPlanDescription T4  WITH(NOLOCK)  ON T3.PlanDescriptionId = T4.PlanDescriptionId    
			JOIN PolicyManagement..TRefPlanType2ProdSubType T5  WITH(NOLOCK)  ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId    
			JOIN PolicyManagement..TRefPlanType T6  WITH(NOLOCK)  ON T5.RefPlanTypeId = T6.RefPlanTypeId     
			JOIN PolicyManagement..TRefProdProvider T8  WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId    
			JOIN TCRMContact T9 WITH(NOLOCK) ON T9.CRMContactId = T8.CRMContactId    
			JOIN PolicyManagement..TStatusHistory T10  WITH(NOLOCK) ON  T10.PolicyBusinessId = T7.PolicyBusinessId  
				AND T10.CurrentStatusFG = 1    
			JOIN PolicyManagement..TStatus T11 WITH(NOLOCK) ON T11.StatusId = T10.StatusId 
				AND ISNULL(T11.IntelligentOfficeStatusType, '''') != ''Deleted'' 
				AND T11.IndigoClientId = ' + CONVERT(VARCHAR(50), @_TenantId2)+'
		WHERE    
			T3.IndigoClientId = ' + CONVERT(VARCHAR(50), @_TenantId2)
			
	IF @SequentialRefType = 'PlanIOBRef' SELECT @SqlScript1 = @SqlScript1+'
			AND T7.SequentialRef = ''' + @SequentialRef + ''''
			
	IF @PolicyNumber IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
			AND T7.PolicyNumber LIKE ''' + @PolicyNumber + '%'''
			
	IF ISNULL(@RefProdProviderId, 0) > 0 SELECT @SqlScript1 = @SqlScript1+'
			AND T4.RefProdProviderId = ' + CONVERT(VARCHAR(50), @RefProdProviderId )
			
SELECT @SqlScript1 = @SqlScript1 +'
	) AS Plans ON Plans.CRMContactId = T1.CRMContactId'
	
IF (@SequentialRefType = 'FeeIOFRef' 
	OR @SequentialRefType = 'RetainerIORRef' 
	OR @SequentialRefType = 'AdviceCaseRef') SELECT @SqlScript1 = @SqlScript1+' AND 1 = 2 '

SELECT @SqlScript1 = @SqlScript1 +'
	LEFT JOIN TPractitioner T12  WITH(NOLOCK)  ON T12.CRMContactId = T1.CurrentAdviserCRMId'
	
IF @SequentialRefType = 'FeeIOFRef' SELECT @SqlScript1 = @SqlScript1+'
	JOIN PolicyManagement..TFeeRetainerOwner FeeOwner WITH(NOLOCK) ON FeeOwner.CRMContactId = T1.CRMContactId
	JOIN PolicyManagement..TFee Fee WITH(NOLOCK) ON Fee.FeeId = FeeOwner.FeeId 
			AND Fee.SequentialRef = ''' + @SequentialRef + ''''

IF @SequentialRefType = 'RetainerIORRef' SELECT @SqlScript1 = @SqlScript1+'
	JOIN PolicyManagement..TFeeRetainerOwner RetainerOwner WITH(NOLOCK) ON RetainerOwner.CRMContactId = T1.CRMContactId
	JOIN PolicyManagement..TRetainer Retainer WITH(NOLOCK) ON Retainer.RetainerId = RetainerOwner.RetainerId 
			AND Retainer.SequentialRef = ''' + @SequentialRef + ''''

IF @SequentialRefType = 'AdviceCaseRef' SELECT @SqlScript1 = @SqlScript1+'
	JOIN CRM..TAdviceCase AC WITH(NOLOCK) ON AC.CRMContactId = T1.CRMContactId
		AND AC.CaseRef = ''' + @SequentialRef + ''''

SELECT @SqlScript1 = @SqlScript1 +'
	-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = ' + CONVERT(VARCHAR(50), @_UserId) + ' AND TCKey.CreatorId = T1._OwnerId    
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = ' + CONVERT(VARCHAR(50), @_UserId) + ' AND TEKey.EntityId = T1.CRMContactId    
WHERE     
	T1.IndClientId = ' + CONVERT(VARCHAR(50), @_TenantId2)+'
	AND ISNULL(T1.RefCRMContactStatusId,0) = 1 
	AND T1.ArchiveFG = 0'
		
IF ISNULL(@ServicingAdviserPartyId, 0) > 0 SELECT @SqlScript1 = @SqlScript1+'
	AND T12.CRMContactId = ' + CONVERT(VARCHAR(50), @ServicingAdviserPartyId)
	  
IF @CorporateName IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
	AND T1.CorporateName LIKE ''' + @CorporateName +  '%'''  
	
IF @FirstName IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
	AND T1.FirstName LIKE ''' + @FirstName +  '%''' 
	 
IF @MiddleName IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
	AND T1.MiddleName LIKE ''' + @MiddleName + '%'''	
	
IF @LastName IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
	AND T1.LastName LIKE ''' + @LastName + '%'''
	
IF @PolicyNumber IS NOT NULL SELECT @SqlScript1 = @SqlScript1+'
	AND Plans.PolicyNumber LIKE ''' + @PolicyNumber + '%'''
	  
IF ISNULL(@RefProdProviderId, 0) > 0 SELECT @SqlScript1 = @SqlScript1+'
	AND Plans.RefProdProviderId = ' + CONVERT(VARCHAR(50), @RefProdProviderId)
	
IF ISNULL(@_UserId, 0) > 0 SELECT @SqlScript1 = @SqlScript1+'
	AND (T1._OwnerId = ' + CONVERT(VARCHAR(50), @_UserId) + ' OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))'  
 
--SELECT @SqlScript1  
EXECUTE (@SqlScript1)  
    
SELECT
	DISTINCT
	T1.CRMContactId AS [Owner 1.Id],     
	ISNULL(T1.CurrentAdviserName, '') AS [Owner 1.Servicing Adviser.Full Name],
	ISNULL(LastName, '') +  ISNULL(CorporateName, '') AS [Owner 1.Last Name],    
	MiddleName AS [Owner 1.Middle Name], 
	FirstName AS [Owner 1.First Name],
	CorporateName AS [Owner 1.Corporate Name],     
	PolicyBusinessId AS [Id],    
	PolicyNumber AS [Policy Number],    
	ProductName AS [Product Name],    
	PolicyType AS [Plan Type],    
	ExternalReference AS [Owner 1.Client Reference], 
	IOBReference AS [SequentialRef],     
	AdditionalRef AS [Owner 1.Client Secondary Reference],
	PolicyStatus AS [Plan Status],    
	CRMContactType AS [Owner 1.Client Type],     
	CreditedGroup AS [Owner 1.Credited Group],
	[Group] AS [Owner 1.Group],
	CASE PolicyStatus    
		WHEN 'In Force' THEN ChangedToDate    
		ELSE ''    
	END AS [In Force Date],
	Title AS [Owner 1.Title],
	ISNULL(ASTFilter.AddressLine1, ASTDefault.AddressLine1) AS [Owner 1.Address Line 1],
	ISNULL(ASTFilter.AddressLine2, ASTDefault.AddressLine2) AS [Owner 1.Address Line 2],
	ISNULL(ASTFilter.AddressLine3, ASTDefault.AddressLine2) AS [Owner 1.Address Line 3],
	ISNULL(ASTFilter.AddressLine4, ASTDefault.AddressLine4) AS [Owner 1.Address Line 4],
	ISNULL(ASTFilter.CityTown, ASTDefault.CityTown) AS [Owner 1.City / Town],
	ISNULL(ASTFilterCounty.CountyName, ASTDefaultCounty.CountyName) AS [Owner 1.County],
	ISNULL(ASTFilterCountry.CountryName, ASTDefaultCountry.CountryName) AS [Owner 1.Country],
	ISNULL(ASTFilter.Postcode, ASTDefault.Postcode) AS [Owner 1.PostCode],
	HomePhone.Value AS [Owner 1.Home Telephone Number],
	Mobile.Value AS [Owner 1.Mobile Number],
	Fax.Value AS [Owner 1.Fax Number],
	Email.Value AS [Owner 1.Email Address],
	WebSite.Value AS [Owner 1.WebSite],
	ProviderName AS [Provider.Name],
	ChangedToDate AS [Plan Status Date],
	IsDeceased
FROM 
	#TmpSearchClientBasicSecureDefault t1    
	LEFT JOIN     
	(      
		SELECT   
			A.CRMContactId,   
			MAX(A.AddressStoreId) AS AddressStoreId      
		FROM 
			TAddress A WITH(NOLOCK)     
			JOIN #TmpSearchClientBasicSecureDefault B ON A.CRMContactId = B.CRMContactId    
		WHERE 
			DefaultFG = 1    
			AND A.IndClientId = @_TenantId2      
		GROUP BY 
			A.CRMContactId    
	) [AddressDefault] ON [AddressDefault].CRMContactid = t1.CRMContactid      
	LEFT JOIN CRM..TAddressStore ASTDefault WITH(NOLOCK) ON ASTDefault.AddressStoreId = [AddressDefault].AddressStoreId
	LEFT JOIN CRM..TRefCounty ASTDefaultCounty  WITH(NOLOCK) ON ASTDefaultCounty.RefCountyId = ASTDefault.RefCountyId
	LEFT JOIN CRM..TRefCountry ASTDefaultCountry  WITH(NOLOCK) ON ASTDefaultCountry.RefCountryId = ASTDefault.RefCountryId
	LEFT JOIN @TPostCodeSearch TS ON TS.CRMContactId = T1.CRMContactId
	LEFT JOIN TAddressStore ASTFilter WITH(NOLOCK) ON ASTFilter.AddressStoreId = TS.AddressStoreId
	LEFT JOIN CRM..TRefCounty ASTFilterCounty  WITH(NOLOCK) ON ASTFilterCounty.RefCountyId = ASTFilter.RefCountyId
	LEFT JOIN CRM..TRefCountry ASTFilterCountry WITH(NOLOCK) ON ASTFilterCountry.RefCountryId = ASTFilter.RefCountryId
	LEFT JOIN CRM..TContact HomePhone WITH(NOLOCK) ON HomePhone.CRMContactId = T1.CRMContactId 
		AND HomePhone.DefaultFG = 1
		AND HomePhone.RefContactType = 'Home'
	LEFT JOIN CRM..TContact Mobile WITH(NOLOCK) ON Mobile.CRMContactId = T1.CRMContactId 
		AND Mobile.DefaultFG = 1
		AND Mobile.RefContactType = 'Mobile'
	LEFT JOIN CRM..TContact Fax WITH(NOLOCK) ON Fax.CRMContactId = T1.CRMContactId 
		AND Fax.DefaultFG = 1
		AND Fax.RefContactType = 'Fax'
	LEFT JOIN CRM..TContact Email WITH(NOLOCK) ON Email.CRMContactId = T1.CRMContactId 
		AND Email.DefaultFG = 1
		AND (Email.RefContactType = 'Email' OR Email.RefContactType = 'E-Mail')
	LEFT JOIN CRM..TContact WebSite WITH(NOLOCK) ON WebSite.CRMContactId = T1.CRMContactId 
		AND WebSite.DefaultFG = 1
		AND WebSite.RefContactType = 'Web Site'
WHERE
	ISNULL(@Postcode, '%') != '%' AND TS.CRMContactId IS NOT NULL OR (ISNULL(@Postcode, '%') = '%' AND 1 = 1)
	AND (IsDeceased = 0 OR IsDeceased = @IncludeDeceased)
ORDER BY 
	[FirstName] ASC, [CorporateName] ASC    
     
 IF (@_TopN > 0) SET ROWCOUNT 0    
  
DROP TABLE #TmpSearchClientBasicSecureDefault  
  
END
GO
