SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientByNameExportSecure]
	@IndigoClientId bigint,
	@CorporateName varchar(255) = NULL,
	@Firstname varchar(255) = NULL,
	@LastName varchar(255) = NULL, 
	@PrimaryRef varchar(50) = NULL,
	@IncludeDeleted bit = 0,
	@AdviserId bigint = NULL,
	@AdviserGroupId bigint = NULL,
	@CreditedGroupId bigint = NULL,
	@SecondaryRef varchar(50) = NULL,
	@ServiceStatus varchar(50) = NULL,
	@Postcode varchar(50) = NULL,
	@_UserId bigint,
	@_TopN int = 0
AS
BEGIN

-- Limit rows returned?
IF (@_TopN > 0) SET ROWCOUNT @_TopN

DECLARE @spacer varchar(10)
SELECT @spacer = '00000000'

SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CRMContactId AS [CRMContact!1!CRMContactId], 
	ISNULL(T1.RefCRMContactStatusId, '') AS [CRMContact!1!RefCRMContactStatusId], 
	ISNULL(rss.ServiceStatusName, '') AS [CRMContact!1!ServiceStatus], 	
	ISNULL(T1.PersonId, '') AS [CRMContact!1!PersonId], 
	ISNULL(T1.CorporateId, '') AS [CRMContact!1!CorporateId], 
	ISNULL(T1.TrustId, '') AS [CRMContact!1!TrustId], 
	ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef], 
	ISNULL(T1.Notes, '') AS [CRMContact!1!Notes], 
	ISNULL(T1.ArchiveFg, '') AS [CRMContact!1!ArchiveFg], 
	ISNULL(T1.LastName, '') AS [CRMContact!1!LastName], 
	ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName], 
	ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName], 
	ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!LastOrCorporateName],
	ISNULL(CONVERT(varchar(24), T1.DOB, 120),'') AS [CRMContact!1!DOB], 
	ISNULL(T1.Postcode, '') AS [CRMContact!1!Postcode], 
	T1.OriginalAdviserCRMId AS [CRMContact!1!OriginalAdviserCRMId], 
	T1.CurrentAdviserCRMId AS [CRMContact!1!CurrentAdviserCRMId], 
	ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName], 
	T1.CRMContactType AS [CRMContact!1!CRMContactType], 
	CASE
		WHEN T1.CRMContactType = 1 THEN 'Person'
		WHEN T1.CRMContactType = 2 THEN 'Trust'
		WHEN T1.CRMContactType = 3 THEN 'Corporate'
		WHEN T1.CRMContactType = 4 THEN 'Group'
	END AS  [CRMContact!1!CRMContactTypeName],
	CASE
		WHEN T1.CRMContactType = 1 THEN (T1.FirstName + ' ' + T1.LastName)
		WHEN T1.CRMContactType in (2,3,4) THEN (T1.CorporateName)
	END AS  [CRMContact!1!CRMContactFullName],
	CASE
		WHEN T1.CRMContactType = 1 THEN (T1.LastName)
		WHEN T1.CRMContactType in (2,3,4) THEN (T1.CorporateName)
	END AS  [CRMContact!1!CRMContactLastNameCorporateName],
	ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference], 
	ISNULL(T1.AdditionalRef, '') AS [CRMContact!1!SecondaryReference], 
	T1.AdvisorRef + '-' + (left(@spacer,8-(len(Convert(varChar(10),T1.CRMContactId))))) + Convert(varChar(10),T1.CRMContactId) AS [CRMContact!1!ClientRef],
	T1.IndClientId AS [CRMContact!1!IndClientId], 
	T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId], 
	ISNULL(T2.StatusName, '') AS [CRMContact!1!StatusName], 
	ISNULL(T2.OrderNo, '') AS [CRMContact!1!OrderNo], 
	ISNULL(T2.InternalFG, '') AS [CRMContact!1!InternalFG],
	ISNULL(T4.AddressLine1, '') AS [CRMContact!1!AddressLine1],
	ISNULL(T4.AddressLine2, '') AS [CRMContact!1!AddressLine2],
	ISNULL(T4.AddressLine3, '') AS [CRMContact!1!AddressLine3],
	ISNULL(T4.AddressLine4, '') AS [CRMContact!1!AddressLine4],
	ISNULL(T4.CityTown, '') AS [CRMContact!1!CityTown],
	ISNULL(T4.PostCode, '') AS [CRMContact!1!PostCode],
	ISNULL(T5.CountyName, '') AS [CRMContact!1!County],
	ISNULL(T6.CountryName, '') AS [CRMContact!1!Country],
	ISNULL(T8.Title, '') AS [CRMContact!1!Title],
	ISNULL(T9.Value, '') AS [CRMContact!1!Telephone],
	ISNULL(T10.Value, '') AS [CRMContact!1!Mobile],
	ISNULL(T11.Value, '') AS [CRMContact!1!Fax],
	ISNULL(T12.Value, '') AS [CRMContact!1!E-Mail],
	ISNULL(T13.Value, '') AS [CRMContact!1!Web],
	ISNULL(Cg.Identifier, '') AS [CRMContact!1!CreditedGroup]
FROM 
	TCRMContact T1 WITH(NOLOCK)	
	JOIN TPractitioner A WITH(NOLOCK) ON A.CRMContactId = T1.CurrentAdviserCRMId AND A.IndClientId = @IndigoClientId
	LEFT JOIN TCRMContactExt Ce WITH(NOLOCK) ON Ce.CRMContactId = T1.CRMContactId
	LEFT JOIN Administration..TGroup Cg WITH(NOLOCK) ON Cg.GroupId = Ce.CreditedGroupId
	JOIN Administration..TUser U WITH(NOLOCK) ON U.CRMContactId = A.CRMContactId AND U.IndigoClientId = @IndigoClientId
	JOIN Administration..TGroup G WITH(NOLOCK) ON G.GroupId = U.GroupId
	LEFT JOIN Administration..TGroup G2 WITH(NOLOCK) ON G2.GroupId = G.ParentId
	LEFT JOIN Administration..TGroup G3 WITH(NOLOCK) ON G3.GroupId = G2.ParentId
  	LEFT JOIN TRefCRMContactStatus T2 WITH(NOLOCK) ON T2.RefCRMContactStatusId = T1.RefCRMContactStatusId	
	LEFT JOIN TAddress T3 WITH(NOLOCK) ON T3.CRMContactId = T1.CRMContactId AND T3.DefaultFG = 1
	LEFT JOIN TAddressStore T4 WITH(NOLOCK) ON T4.AddressStoreId = T3.AddressStoreId
	LEFT JOIN TRefCounty T5 WITH(NOLOCK) ON T5.RefCountyId = T4.RefCountyId
	LEFT JOIN TRefCountry T6 WITH(NOLOCK) ON T6.RefCountryId = T4.RefCountryId
	LEFT JOIN TPerson T8 WITH(NOLOCK) ON T8.PersonId = T1.PersonId
	LEFT JOIN TContact T9 WITH(NOLOCK) ON T9.CRMContactId = T1.CRMContactId AND T9.DefaultFG = 1 AND T9.RefContactType = 'Telephone'
	LEFT JOIN TContact T10 WITH(NOLOCK) ON T10.CRMContactId = T1.CRMContactId AND T10.DefaultFG = 1 AND T10.RefContactType = 'Mobile'
	LEFT JOIN TContact T11 WITH(NOLOCK) ON T11.CRMContactId = T1.CRMContactId AND T11.DefaultFG = 1 AND T11.RefContactType = 'Fax'
	LEFT JOIN TContact T12 WITH(NOLOCK) ON T12.CRMContactId = T1.CRMContactId AND T12.DefaultFG = 1 AND T12.RefContactType = 'E-Mail'
	LEFT JOIN TContact T13 WITH(NOLOCK) ON T13.CRMContactId = T1.CRMContactId AND T13.DefaultFG = 1 AND T13.RefContactType = 'Web Site'
	LEFT JOIN TAddress Ad WITH(NOLOCK) on Ad.CRMContactId = T1.CRMContactId
	LEFT JOIN TAddressStore Ads WITH (NOLOCK) on Ads.AddressStoreId = Ad.AddressStoreId
	LEFT JOIN TRefServiceStatus rss WITH (NOLOCK) on rss.RefServiceStatusId = T1.RefServiceStatusId
	-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId
WHERE 
	T1.IndClientId = @IndigoClientId 
    AND T1.RefCRMContactStatusId = 1
	AND (@CorporateName IS NULL OR T1.CorporateName LIKE @CorporateName + '%')
	AND (@FirstName IS NULL OR T1.FirstName LIKE @FirstName + '%')
	AND (@LastName IS NULL OR T1.LastName LIKE @LastName + '%')
	AND (@PrimaryRef IS NULL OR T1.ExternalReference LIKE '%' + @PrimaryRef + '%')
	AND (@IncludeDeleted = 1 OR (@IncludeDeleted = 0 AND (T1.ArchiveFg = 0 OR T1.ArchiveFg IS NULL)))
	AND (@AdviserId IS NULL OR A.PractitionerId = @AdviserId)
	AND (@AdviserGroupId IS NULL OR (G.GroupId = @AdviserGroupId OR G2.GroupId = @AdviserGroupId OR G3.GroupId = @AdviserGroupId))
	AND (@CreditedGroupId IS NULL OR Ce.CreditedGroupId = @CreditedGroupId)
	AND (@SecondaryRef IS NULL OR T1.AdditionalRef LIKE '%' + @SecondaryRef + '%')
	AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))
	AND (T1.RefServiceStatusId = @ServiceStatus Or @ServiceStatus IS NULL)
	AND (Ads.Postcode = @Postcode OR @Postcode IS NULL)    
ORDER BY 
	[CRMContact!1!LastOrCorporateName] ASC, [CRMContact!1!FirstName] ASC

FOR XML EXPLICIT

IF (@_TopN > 0) SET ROWCOUNT 0
END

RETURN (0)


GO
