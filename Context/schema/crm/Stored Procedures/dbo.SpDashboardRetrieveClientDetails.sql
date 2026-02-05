SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpDashboardRetrieveClientDetails]
				@UserId bigint,
				@cid bigint,
				@CurrentUserDate datetime

AS

DECLARE @Telephone varchar(25)
		, @Mobile varchar(25)
		, @Work varchar(25)
		, @Fax varchar(25)
		, @Email varchar(100)
		, @Website varchar(100)
		, @Facebook varchar(100)
		, @LinkedIn varchar(100)
		, @Twitter varchar(100)
		, @PointOfContact varchar(500)
		, @IndigoClientId bigint
		, @IsSuperUserOrSuperViewer bit

SET @Telephone=(SELECT top(1) Value FROM TContact where CRMContactId = @cid and DefaultFg = 1 and RefContactType='Telephone')
SET @Mobile=(SELECT top(1) Value FROM TContact where CRMContactId = @cid and DefaultFg = 1 and RefContactType='Mobile')
SET @Work=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and DefaultFg = 1 and RefContactType='Business')
SET @Fax=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and DefaultFg = 1 and RefContactType='Fax')
SET @Email=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and DefaultFg = 1 and RefContactType='E-Mail')
SET @Website=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and DefaultFg = 1 and RefContactType='Web Site')

SET @Facebook=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and RefContactType='Social Media' and Value Like'%facebook%' order by ContactId desc)
SET @LinkedIn=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and RefContactType='Social Media'and Value Like'%Linkedin%' order by ContactId desc)
SET @Twitter=(SELECT top(1) Value FROM TContact  where CRMContactId = @cid and RefContactType='Social Media'and Value Like'%Twitter%' order by ContactId desc)

SELECT
	@IsSuperUserOrSuperViewer = SuperUser | SuperViewer,
	@IndigoClientId = IndigoClientId
FROM administration..TUser
WHERE UserId = @UserId

SET @PointOfContact = (
	Select ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName,'') + ' (' + ISNULL(reltype.RelationshipTypeName, '') + ')'
	From TRelationship rel 
	Left Join TRefRelationshipType relType on rel.RefRelTypeId = reltype.RefRelationshipTypeId
	Left Join TCRMContact pc on pc.CRMContactId = rel.CRMContactToId
	Where rel.CRMContactFromId = @cid
	and rel.IsPointOfContactFg = 1
	)

SELECT	TOP 1
	c.CRMContactId as [CRMContactId],
	ISNULL(c.CorporateName,'') + ISNULL(p.Title,'') + ' ' + ISNULL(c.FirstName,'') + ' ' + ISNULL(p.MiddleName,'') + ' ' + ISNULL(c.LastName,'') as [FullName],
	c.DOB as [DateOfBirth],
	
	ISNULL(CONVERT(varchar(3),
		CASE WHEN DATEADD(YEAR, DATEDIFF (YEAR, c.dob, @CurrentUserDate), c.dob) > @CurrentUserDate
			THEN DATEDIFF (YEAR, c.dob, @CurrentUserDate) - 1
			ELSE DATEDIFF (YEAR, c.dob, @CurrentUserDate)
		END)
	,'') as [CurrentAge],

	ISNULL(p.Salutation,'') as [Salutation],
	ISNULL(p.MaidenName,'') as [MaidenName],
	ISNULL(p.MaritalStatus,'') as [MaritalStatus],
	ISNULL(ast.AddressLine1,'') as [AddressLine1],
	ISNULL(ast.AddressLine2,'') as [AddressLine2],
	ISNULL(ast.AddressLine3,'') as [AddressLine3],
	ISNULL(ast.AddressLine4,'') as [AddressLine4],
	ISNULL(ast.CityTown,'') as [CityTown],
	ISNULL(ast.PostCode,'') as [PostCode],
	ISNULL(county.CountyCode,'') as [CountyCode],
	ISNULL(country.CountryCode,'') as [CountryCode],
	ISNULL(p.NINumber,'') as [NINumber],
	CASE
		WHEN ISNULL(cv.Categories,'') != '' and cv.HasVulnerability = 'Yes'
		THEN cv.Type + ' (' + REPLACE(REPLACE(cv.Categories, ',', ', '), 'LifeEvent', 'Life Event') + ')'
		WHEN ISNULL(cv.Categories,'') != '' and cv.HasVulnerability = 'Potential' 
		THEN 'Potential (' + REPLACE(REPLACE(cv.Categories, ',', ', '), 'LifeEvent', 'Life Event') + ')'
		ELSE NULL
	END AS [VulnerabilityDetails],
	ISNULL(@Telephone,'') as [Tel],
	ISNULL(@Mobile,'') as [Mobile],
	ISNULL(@Work,'') as [Work],
	ISNULL(@Fax,'') as [Fax],
	ISNULL(@Email,'') as [E-Mail],
	ISNULL(@Website,'') as [Website],
	ISNULL(@LinkedIn,'') as [LinkedIn],
	ISNULL(@Facebook,'') as [Facebook],
	ISNULL(@Twitter,'') as [Twitter],
	CASE WHEN c.CorporateId IS NOT NULL
		 THEN 'True'
		 ELSE 'False'
	END AS [IsCorporate],
	CASE WHEN c.TrustId IS NOT NULL
		 THEN 'True'
		 ELSE 'False'
	END AS [IsTrust],
	CASE WHEN c.PersonId IS NOT NULL
		 THEN 'True'
		 ELSE 'False'
	END AS [IsPerson],

	copType.TypeName AS [CorporateType],
	cop.BusinessType AS [BusinessType],
	cop.CompanyRegNo AS [CompanyRegNo],
	ISNULL(@PointOfContact,'') as [PointofContact],

	trustType.TrustTypeName AS [TrustType],
	t.EstDate AS [EstablishedDate],

	--PFP Fields from SDB
	CASE ISNULL(cc.HasPfpRegistered, 0)
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END AS PfpIsRegistered,
	cc.PfpUserEmail AS PfpUserEmail,
	cc.LastLoginDate AS PfpLastLoginDate,
	CASE
		WHEN c.CorporateId IS NOT NULL THEN cop.LEI
		WHEN c.TrustId IS NOT NULL THEN t.LEI
		ELSE NULL
	END AS [LEI],
	CASE
		WHEN c.CorporateId IS NOT NULL THEN cop.LEIExpiryDate
		WHEN c.TrustId IS NOT NULL THEN t.LEIExpiryDate
		ELSE NULL
	END AS [LEIExpiryDate],
	cc.InvitationSendDate

FROM
	TCRMContact c
LEFT JOIN
	TClientVulnerability cv on cv.CRMContactId = c.CRMContactId and cv.IsCurrent = 1
LEFT JOIN
	TAddress a ON a.CRMContactId = c.CRMContactId AND a.DefaultFg = 1
LEFT JOIN
	TAddressStore ast ON ast.AddressStoreId = a.AddressStoreId
LEFT JOIN
	TRefCounty county ON county.RefCountyId = ast.RefCountyId
LEFT JOIN
	TRefCountry country ON country.RefCountryId = ast.RefCountryId
LEFT JOIN
	TPerson p ON c.PersonId = p.PersonId
LEFT JOIN
	SDB..[Client] cc ON c.IndClientId = cc.TenantId AND c.CRMContactId = cc.ClientId

--Corporate Details
LEFT JOIN TCorporate cop on c.CorporateId = cop.CorporateId
LEFT JOIN TRefCorporateType copType on copType.RefCorporateTypeId = cop.RefCorporateTypeId

--Trust Details
LEFT JOIN TTrust t on c.TrustId = t.TrustId
LEFT JOIN TRefTrustType trustType on trustType.RefTrustTypeId = t.RefTrustTypeId

-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)  
LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = c._OwnerId  
LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = c.CRMContactId

WHERE
	c.CRMContactId = @cid
	AND c.IndClientId = @IndigoClientId
	AND (@IsSuperUserOrSuperViewer = 1 OR (c._OwnerId = @UserId OR TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))

GO
