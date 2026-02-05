SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spCustomRetrieveAddressByCRMContactOrderByAddressStatus]  
  
@CRMContactId bigint  
  
as  
BEGIN  
SELECT  
    1 AS Tag,  
    NULL AS Parent,  
    T1.AddressId AS [Address!1!AddressId],   
    T1.IndClientId AS [Address!1!IndClientId],   
    ISNULL(T1.CRMContactId, '') AS [Address!1!CRMContactId],   
    ISNULL(T1.AddressStoreId, '') AS [Address!1!AddressStoreId],   
    T1.RefAddressTypeId AS [Address!1!RefAddressTypeId],   
    ISNULL(T2.AddressTypeName, T1.AddressTypeName) AS [Address!1!AddressTypeName], 
	ISNULL(T1.AddressTypeName, '') AS [Address!1!OtherAddressTypeName], 
    T1.DefaultFg AS [Address!1!DefaultFg],   
    isnull(T1.RefAddressStatusId,99) AS [Address!1!RefAddressStatusId],   
    CONVERT(varchar(24), T1.ResidentFromDate, 120) AS [Address!1!ResidentFromDate],   
	case when DATEDIFF(yyyy,T1.ResidentFromDate,GETDATE()) > 0 then DATEDIFF(yyyy,T1.ResidentFromDate,GETDATE()) -1
else DATEDIFF(yyyy,T1.ResidentFromDate,GETDATE()) end  AS [Address!1!YrsAtAddress],
    T1.ConcurrencyId AS [Address!1!ConcurrencyId],   
    NULL AS [AddressStore!2!AddressStoreId],   
    NULL AS [AddressStore!2!IndClientId],   
    NULL AS [AddressStore!2!AddressLine1],   
    NULL AS [AddressStore!2!AddressLine2],   
    NULL AS [AddressStore!2!AddressLine3],   
    NULL AS [AddressStore!2!AddressLine4],   
    NULL AS [AddressStore!2!CityTown],   
    NULL AS [AddressStore!2!RefCountyId],   
    NULL AS [AddressStore!2!Postcode],   
    NULL AS [AddressStore!2!RefCountryId],   
    NULL AS [AddressStore!2!PostCodeX],   
    NULL AS [AddressStore!2!PostCodeY],   
    NULL AS [AddressStore!2!ConcurrencyId],   
    NULL AS [RefAddressStatus!3!RefAddressStatusId],   
    NULL AS [RefAddressStatus!3!AddressStatus],   
    NULL AS [RefCounty!4!RefCountyId],   
    NULL AS [RefCounty!4!CountyName],   
    NULL AS [RefCounty!4!RefCountryId],   
    NULL AS [RefCounty!4!ArchiveFG],   
    NULL AS [RefCounty!4!ConcurrencyId],   
    NULL AS [RefCountry!5!RefCountryId],   
    NULL AS [RefCountry!5!CountryName],   
    NULL AS [RefCountry!5!ArchiveFG],   
    NULL AS [RefCountry!5!ConcurrencyId]  
  FROM TAddress T1  
  JOIN TRefAddressType T2 ON T1.RefAddressTypeId=T2.RefAddressTypeId

  WHERE (T1.CRMContactId = @CRMContactId)  
  
  UNION ALL  
  
  SELECT  
    2 AS Tag,  
    1 AS Parent,  
    T1.AddressId,   
    T1.IndClientId,   
    ISNULL(T1.CRMContactId, ''),   
    ISNULL(T1.AddressStoreId, ''),   
    T1.RefAddressTypeId,   
    ISNULL(T3.AddressTypeName, ''),   
	ISNULL(T1.AddressTypeName, ''),   
    T1.DefaultFg,   
   isnull(T1.RefAddressStatusId,99) AS [Address!1!RefAddressStatusId],   
    CONVERT(varchar(24), T1.ResidentFromDate, 120),  
	DATEDIFF(yyyy,T1.ResidentFromDate,GETDATE()) AS [Address!1!YrsAtAddress], 
    T1.ConcurrencyId,   
    T2.AddressStoreId,   
    T2.IndClientId,   
    ISNULL(T2.AddressLine1, ''),   
    ISNULL(T2.AddressLine2, ''),   
    ISNULL(T2.AddressLine3, ''),   
    ISNULL(T2.AddressLine4, ''),   
    ISNULL(T2.CityTown, ''),   
    ISNULL(T2.RefCountyId, ''),   
    ISNULL(T2.Postcode, ''),   
    ISNULL(T2.RefCountryId, ''),   
    ISNULL(T2.PostCodeX, ''),   
    ISNULL(T2.PostCodeY, ''),   
    T2.ConcurrencyId,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL  
  FROM TAddressStore T2  
  INNER JOIN TAddress T1 ON T2.AddressStoreId = T1.AddressStoreId  
  INNER JOIN TRefAddressType T3 ON T1.RefAddressTypeId=T3.RefAddressTypeId
  
  WHERE (T1.CRMContactId = @CRMContactId)  
  
  UNION ALL  
  
  SELECT  
    3 AS Tag,  
    1 AS Parent,  
    T1.AddressId,   
    T1.IndClientId,   
    ISNULL(T1.CRMContactId, ''),   
    ISNULL(T1.AddressStoreId, ''),   
    T1.RefAddressTypeId,   
	ISNULL(T2.AddressTypeName, ''), 
    ISNULL(T1.AddressTypeName, ''),   
    T1.DefaultFg,   
    isnull(T1.RefAddressStatusId,99) AS [Address!1!RefAddressStatusId],   
    CONVERT(varchar(24), T1.ResidentFromDate, 120),   
	DATEDIFF(yyyy,T1.ResidentFromDate,GETDATE()) AS [Address!1!YrsAtAddress],
    T1.ConcurrencyId,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    T3.RefAddressStatusId,   
    ISNULL(T3.AddressStatus, ''),   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL  
  FROM TRefAddressStatus T3  
  INNER JOIN TAddress T1    ON T3.RefAddressStatusId = T1.RefAddressStatusId  
  INNER JOIN TRefAddressType T2 ON T1.RefAddressTypeId=T2.RefAddressTypeId 
  
  WHERE (T1.CRMContactId = @CRMContactId)  
  
  UNION ALL  
  
  SELECT  
    4 AS Tag,  
    2 AS Parent,  
    T1.AddressId,   
    NULL,   
    NULL,   
    NULL, 
    NULL,  
    NULL,   
    NULL,   
    NULL,   
    isnull(T1.RefAddressStatusId,99) AS [Address!1!RefAddressStatusId],   
    NULL,   
	NULL,
    NULL,   
    T2.AddressStoreId,   
    T2.IndClientId,   
    ISNULL(T2.AddressLine1, ''),   
    ISNULL(T2.AddressLine2, ''),   
    ISNULL(T2.AddressLine3, ''),   
    ISNULL(T2.AddressLine4, ''),   
    ISNULL(T2.CityTown, ''),   
    ISNULL(T2.RefCountyId, ''),   
    ISNULL(T2.Postcode, ''),   
    ISNULL(T2.RefCountryId, ''),   
    ISNULL(T2.PostCodeX, ''),   
    ISNULL(T2.PostCodeY, ''),   
    T2.ConcurrencyId,   
    NULL,   
    NULL,   
    T4.RefCountyId,   
    ISNULL(T4.CountyName, ''),   
    T4.RefCountryId,   
    T4.ArchiveFG,   
    T4.ConcurrencyId,   
    NULL,   
    NULL,   
    NULL,   
    NULL  
  FROM TRefCounty T4  
  INNER JOIN TAddressStore T2  
  ON T4.RefCountyId = T2.RefCountyId  
  INNER JOIN TAddress T1  
  ON T2.AddressStoreId = T1.AddressStoreId  
  
  WHERE (T1.CRMContactId = @CRMContactId)  
  
  UNION ALL  
  
  SELECT  
    5 AS Tag,  
    2 AS Parent,  
    T1.AddressId,   
    NULL,   
    NULL, 
    NULL,  
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    isnull(T1.RefAddressStatusId,99) AS [Address!1!RefAddressStatusId],   
    NULL, 
	NULL,  
    NULL,   
    T2.AddressStoreId,   
    T2.IndClientId,   
    ISNULL(T2.AddressLine1, ''),   
    ISNULL(T2.AddressLine2, ''),   
    ISNULL(T2.AddressLine3, ''),   
    ISNULL(T2.AddressLine4, ''),   
    ISNULL(T2.CityTown, ''),   
    ISNULL(T2.RefCountyId, ''),   
    ISNULL(T2.Postcode, ''),   
    ISNULL(T2.RefCountryId, ''),   
    ISNULL(T2.PostCodeX, ''),   
    ISNULL(T2.PostCodeY, ''),   
    T2.ConcurrencyId,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    NULL,   
    T5.RefCountryId,   
    T5.CountryName,   
    T5.ArchiveFG,   
    T5.ConcurrencyId  
  FROM TRefCountry T5  
  INNER JOIN TAddressStore T2  
  ON T5.RefCountryId = T2.RefCountryId  
  INNER JOIN TAddress T1  
  ON T2.AddressStoreId = T1.AddressStoreId  
  
  WHERE (T1.CRMContactId = @CRMContactId)  
  
  ORDER BY [Address!1!RefAddressStatusId],[Address!1!AddressId], [AddressStore!2!AddressStoreId], [RefCountry!5!RefCountryId], [RefCounty!4!RefCountyId],parent  
  
  FOR XML EXPLICIT  
  
  
END 

GO
