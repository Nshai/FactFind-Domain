SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAddressesForCRMContact1And2] 
		@CRMContactId1 bigint,
		@CRMContactId2 bigint,
		@PropertyDetailCreation bit = 0,
		@ExcludeDuplicates bit = 0
AS
	SELECT 1 AS TAG,    
	NULL AS Parent,    
	A.AddressId AS [Address!1!AddressId],    
	B.AddressStoreId AS [Address!1!AddressStoreId],    
	ISNULL(B.AddressLine1,'')AS [Address!1!AddressLine1],    
	ISNULL(B.AddressLine2,'')AS [Address!1!AddressLine2],    
	ISNULL(B.AddressLine3,'')AS [Address!1!AddressLine3],    
	ISNULL(B.AddressLine4,'')AS [Address!1!AddressLine4],    
	ISNULL(B.CityTown,'')AS [Address!1!CityTown],    
	ISNULL(C.CountyName,'')AS [Address!1!County],    
	ISNULL(B.PostCode,'')AS [Address!1!PostCode],
	(ROW_NUMBER() OVER(PARTITION BY B.AddressLine1 ORDER BY B.AddressStoreId)) AS row_num
	INTO #DATA
	FROM TAddress A    
	JOIN TAddressStore B ON A.AddressStoreId=B.AddressStoreId    
	LEFT JOIN TRefCounty C ON B.RefCountyId=C.RefCountyId    
	LEFT JOIN factfind..TPropertyDetail PD ON (@PropertyDetailCreation = 1 AND PD.RelatedAddressStoreId = B.AddressStoreId)
	WHERE (A.CRMContactId IN (@CRMContactId1, @CRMContactId2)) AND NOT A.CRMContactId = 0 AND (@PropertyDetailCreation = 0 OR PD.PropertyDetailId IS NULL)
	ORDER BY [Address!1!AddressId] 

	SELECT 
	TAG,
	Parent,    
	[Address!1!AddressId],    
	[Address!1!AddressStoreId],    
	[Address!1!AddressLine1],    
	[Address!1!AddressLine2],    
	[Address!1!AddressLine3],    
	[Address!1!AddressLine4],    
	[Address!1!CityTown],    
	[Address!1!County],    
	[Address!1!PostCode]
	FROM #DATA 
	WHERE (@ExcludeDuplicates = 1 and row_num = 1) or @ExcludeDuplicates = 0
	FOR XML EXPLICIT  
GO 