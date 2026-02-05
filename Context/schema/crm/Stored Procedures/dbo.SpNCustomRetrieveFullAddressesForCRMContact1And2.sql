SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFullAddressesForCRMContact1And2]   

  @CRMContactId1 bigint,  

  @CRMContactId2 bigint      

AS          

  
 DECLARE @AddressDetail Table
 (
 PropertyDetailId BIGINT NOT NULL,
 [Address] varchar(MAX) NULL,
 AddressStoreId bigint null
 )
  
INSERT into @AddressDetail  (PropertyDetailId, [Address] , AddressStoreId )
   SELECT  
	   D.PropertyDetailId AS [FullAddress!1!AddressStoreId],   

	   CASE WHEN ISNULL(S.AddressLine1,'') = '' THEN '' ELSE S.AddressLine1 + ',' END +  
	   CASE WHEN ISNULL(S.AddressLine2,'') = '' THEN '' ELSE S.AddressLine2 + ',' END +  
	   CASE WHEN ISNULL(S.CityTown,'') = '' THEN '' ELSE S.CityTown + ',' END +  
	   CASE WHEN ISNULL(C.CountyName,'') = '' THEN '' ELSE C.CountyName + ',' END +  
	   CASE WHEN ISNULL(S.Postcode,'') = '' THEN '' ELSE S.Postcode  END AS FullAddress, 

	   S.AddressStoreId as AddressStoreId
	FROM factfind..TPropertyDetail AS D 
			INNER JOIN CRM..TAddressStore S ON  S.AddressStoreId = D.RelatedAddressStoreId 
			INNER JOIN CRM..TAddress A ON A.AddressStoreId = S.AddressStoreId
			LEFT JOIN CRM..TRefCounty C ON C .RefCountyId=S.RefCountyId
	WHERE ((A.CRMContactId IN (@CRMContactId1, @CRMContactId2)) AND NOT A.CRMContactId = 0)
				AND (datalength(S.AddressLine1) != 0 OR S.AddressLine1 is not null)

   SELECT DISTINCT 1 AS TAG,    
   NULL AS Parent, 
   PropertyDetailId AS [FullAddress!1!AddressStoreId],
   CASE 
	WHEN RIGHT(RTRIM([Address]),1) = ',' THEN LEFT([Address],LEN([Address])-1)
	ELSE [Address]
	END AS [FullAddress!1!FullAddress]  
   FROM  @AddressDetail 

FOR XML EXPLICIT  
GO
