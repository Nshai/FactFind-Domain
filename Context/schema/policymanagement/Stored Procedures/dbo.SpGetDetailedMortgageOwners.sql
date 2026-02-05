USE [policymanagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpGetDetailedMortgageOwners]	
	@PolicyBusinessId  BIGINT,
	@TenantId BIGINT	
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @Owner1Id BIGINT,	@Owner2Id BIGINT,	@Owner3Id BIGINT,	@Owner4Id BIGINT
	DECLARE @OwnersInfo TABLE (Id BIGINT NULL, Name varchar(200), [Address] varchar(5000) NULL, Telephone varchar(1000) NULL, Mobile varchar(1000) NULL, Email varchar (255) NULL, DateOfBirth DATE NULL, ContactId bit NULL, PfpRegistered varchar (3) NULL)      


	;WITH PolicyOwnerData(policyOwner1Id, policyOwner2Id)
	AS
	(
		SELECT  MIN(po.PolicyOwnerId),
				MAX(po.PolicyOwnerId)
		FROM  TPolicyBusiness Pb   
			JOIN TPolicyDetail pd WITH(NOLOCK) ON pd.PolicyDetailId = pb.PolicyDetailId              
			JOIN TPolicyOwner po WITH(NOLOCK) ON po.PolicyDetailId = pd.PolicyDetailId
		WHERE PB.IndigoClientId = @TenantId AND PB.PolicyBusinessId = @PolicyBusinessId
		GROUP BY pb.PolicyBusinessId
	)
	SELECT @Owner1Id = po1.CRMContactId, @Owner2Id = po2.CRMContactId
	FROM PolicyOwnerData pod
		JOIN TPolicyOwner po1 ON po1.PolicyOwnerId=pod.policyOwner1Id
		JOIN TPolicyOwner po2 ON po2.PolicyOwnerId = pod.policyOwner2Id

	IF @Owner2Id = @Owner1Id  SET @Owner2Id = NULL 

	;WITH PolicyAdditionalOwnerData(policyOwner3Id, policyOwner4Id)
	AS
	(
		SELECT  MIN(ao.AdditionalOwnerId),
				MAX(ao.AdditionalOwnerId)
		FROM  TAdditionalOwner ao
			JOIN TPolicyBusiness pb ON ao.PolicyBusinessId = pb.PolicyBusinessId
		WHERE pb.IndigoClientId = @TenantId AND pb.PolicyBusinessId = @PolicyBusinessId
		GROUP BY pb.PolicyBusinessId
	)
	SELECT @Owner3Id = ao1.CRMContactId, @Owner4Id = ao2.CRMContactId
	FROM PolicyAdditionalOwnerData pod
		JOIN TAdditionalOwner ao1 ON ao1.AdditionalOwnerId=pod.policyOwner3Id
		JOIN TAdditionalOwner ao2 ON ao2.AdditionalOwnerId = pod.policyOwner4Id

	IF @Owner4Id = @Owner3Id  SET @Owner4Id = NULL 

	INSERT INTO @OwnersInfo (Id)
	VALUES( @Owner1Id), (@Owner2Id),(@Owner3Id), (@Owner4Id)

	UPDATE @OwnersInfo 
	SET Address =  (SELECT TOP 1 (STUFF(
								COALESCE(', ' + NULLIF(ads.AddressLine1, ''), '') +
								COALESCE(', ' + NULLIF(ads.AddressLine2, ''), '') +
								COALESCE(', ' + NULLIF(ads.AddressLine3, ''), '') +
								COALESCE(', ' + NULLIF(ads.AddressLine4, ''), '') +
								COALESCE(', ' + NULLIF(ads.CityTown, ''), '') +
								COALESCE(', ' + ct.CountyName, '') +
								COALESCE(', ' + ctr.CountryName, '') +
								COALESCE(', ' + NULLIF(ads.PostCode, ''), '') 
								,
							1, 2, '') 
							)
					FROM CRM..TCRMContact c WITH(NOLOCK)
					  JOIN CRM..TAddress a ON a.CRMContactId = c.CRMContactId
					  JOIN CRM..TAddressStore ads ON a.AddressStoreId = ads.AddressStoreId
					  LEFT JOIN CRM..TRefCountry ctr on ads.RefCountryId = ctr.RefCountryId
					  LEFT JOIN CRM..TRefCounty ct on ads.RefCountyId = ct.RefCountyId
					WHERE  c.CRMContactId = Id
					ORDER BY a.DefaultFg DESC, a.AddressId DESC)

	;WITH OwnerData(OwnerId, OwnerName, RefContactType, DOB,Title, RowNumber)
	AS
	(
		SELECT oi.Id, 
				CASE WHEN c.CorporateId IS NOT NULL THEN c.CorporateName
					WHEN c.TrustId IS NOT NULL THEN tr.TrustName
					ELSE LTRIM(RTRIM(ISNULL(p.FirstName, '') + ' ' +  ISNULL(p.MiddleName, '') + ' ' + ISNULL(p.LastName, ''))) END,
				tc.RefContactType, c.DOB,
				CASE tc.RefContactType 	WHEN 'E-Mail' THEN  tc.Value  ELSE 
																		STUFF(
																				COALESCE(' / ' + tc.Value, '') +
																				COALESCE(' / ' +  LEAD(tc.Value) OVER (Partition by c.CRMContactId, tc.RefContactType ORDER BY tc.DefaultFG DESC, tc.ContactId DESC) , '') 
																				,1, 3, '') END,
				Row_Number() OVER (Partition by  c.CRMContactId, tc.RefContactType ORDER BY tc.DefaultFG DESC, tc.ContactId DESC)
		FROM CRM..TCRMContact c WITH(NOLOCK)
			  LEFT JOIN CRM..TContact tc WITH(NOLOCK) ON c.CRMContactId = tc.CRMContactId
			  LEFT JOIN CRM..TTrust tr ON c.TrustId = tr.TrustId
			  LEFT JOIN CRM..TPerson p ON p.PersonId = c.PersonId 
			  JOIN @OwnersInfo oi on c.CRMContactId = oi.Id
	),
	OwnerDetailedData(OwnerId, OwnerName, DOB, Telephone, Mobile, Email, IsPFPRegistered)
	AS
	(
		SELECT od.OwnerId, od.OwnerName,od.DOB,
				(SELECT TOP 1 od1.Title FROM OwnerData od1 WHERE od1.RowNumber = 1 AND od1.OwnerId = od.OwnerId AND od1.RefContactType = 'Telephone'),
				(SELECT TOP 1 od1.Title FROM OwnerData od1 WHERE od1.RowNumber = 1 AND od1.OwnerId = od.OwnerId AND od1.RefContactType = 'Mobile'),
				(SELECT TOP 1 od1.Title FROM OwnerData od1 WHERE od1.RowNumber = 1 AND od1.OwnerId = od.OwnerId AND od1.RefContactType = 'E-Mail'),
				(SELECT TOP 1 sdbc.HasPfpRegistered FROM sdb..Client sdbc WHERE sdbc.ClientId = od.OwnerId) 
		FROM OwnerData od
		WHERE RowNumber = 1
	)
	UPDATE x 
	SET  x.Email = od.Email,
		x.Telephone = od.Telephone,
		x.Mobile = od.Mobile,
		x.Name = od.OwnerName,
		x.DateOfBirth = od.DOB,
		x.PFPRegistered = CASE WHEN od.IsPFPRegistered = 1 THEN 'Yes' ELSE 'No' END
	FROM OwnerDetailedData od
	JOIN @OwnersInfo x ON od.OwnerId = x.Id

	SELECT * FROM @OwnersInfo