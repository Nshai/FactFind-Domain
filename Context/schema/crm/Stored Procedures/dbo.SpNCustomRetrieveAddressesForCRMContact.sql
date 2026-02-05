SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAddressesForCRMContact] @CRMContactId bigint    
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
   ISNULL(B.PostCode,'')AS [Address!1!PostCode]        
    
         
FROM TAddress A    
JOIN TAddressStore B ON A.AddressStoreId=B.AddressStoreId    
LEFT JOIN TRefCounty C ON B.RefCountyId=C.RefCountyId    
WHERE (A.CRMContactId=@CRMContactId AND @CRMContactId > 0)
ORDER BY [Address!1!AddressId]    
    
FOR XML EXPLICIT
GO
