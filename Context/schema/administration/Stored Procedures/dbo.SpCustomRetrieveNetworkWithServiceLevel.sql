SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveNetworkWithServiceLevel]
AS

SET NOCOUNT ON


BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.IndigoClientId AS [IndigoClient!1!IndigoClientId], 
    T1.Identifier AS [IndigoClient!1!Identifier], 
    T1.Status AS [IndigoClient!1!Status], 
    T1.PrimaryContact AS [IndigoClient!1!PrimaryContact], 
    ISNULL(T1.ContactId, '') AS [IndigoClient!1!ContactId], 
    T1.PhoneNumber AS [IndigoClient!1!PhoneNumber], 
    T1.EmailAddress AS [IndigoClient!1!EmailAddress], 
    ISNULL(T1.PrimaryGroupId, '') AS [IndigoClient!1!PrimaryGroupId], 
    ISNULL(T1.NetworkId, '') AS [IndigoClient!1!NetworkId], 
    ISNULL(T1.SIB, '') AS [IndigoClient!1!SIB], 
    ISNULL(T1.MCCB, '') AS [IndigoClient!1!MCCB], 
    ISNULL(T1.FSA, '') AS [IndigoClient!1!FSA], 
    T1.IOProductType AS [IndigoClient!1!IOProductType], 
    CONVERT(varchar(24), T1.ExpiryDate, 120) AS [IndigoClient!1!ExpiryDate], 
    T1.AddressLine1 AS [IndigoClient!1!AddressLine1], 
    ISNULL(T1.AddressLine2, '') AS [IndigoClient!1!AddressLine2], 
    ISNULL(T1.AddressLine3, '') AS [IndigoClient!1!AddressLine3], 
    ISNULL(T1.AddressLine4, '') AS [IndigoClient!1!AddressLine4], 
    ISNULL(T1.CityTown, '') AS [IndigoClient!1!CityTown], 
    ISNULL(T1.County, '') AS [IndigoClient!1!County], 
    T1.Postcode AS [IndigoClient!1!Postcode], 
    T1.Country AS [IndigoClient!1!Country], 
    T1.IsNetwork AS [IndigoClient!1!IsNetwork], 
    ISNULL(T1.SupportServiceId, '') AS [IndigoClient!1!SupportServiceId], 
    T1.FirmSize AS [IndigoClient!1!FirmSize], 
    T1.Specialism AS [IndigoClient!1!Specialism], 
    ISNULL(T1.OtherSpecialism, '') AS [IndigoClient!1!OtherSpecialism], 
    T1.ServiceLevel AS [IndigoClient!1!ServiceLevel], 
    T1.EmailSupOptn AS [IndigoClient!1!EmailSupOptn], 
    T1.SupportEmail AS [IndigoClient!1!SupportEmail], 
    T1.TelSupOptn AS [IndigoClient!1!TelSupOptn], 
    T1.SupportTelephone AS [IndigoClient!1!SupportTelephone], 
    T1.AllowPasswordEmail AS [IndigoClient!1!AllowPasswordEmail], 
    T1.SessionTimeout AS [IndigoClient!1!SessionTimeout], 
    T1.LicenceType AS [IndigoClient!1!LicenceType], 
    ISNULL(T1.MaxConUsers, '') AS [IndigoClient!1!MaxConUsers], 
    ISNULL(T1.MaxULAGCount, '') AS [IndigoClient!1!MaxULAGCount], 
    T1.UADRestriction AS [IndigoClient!1!UADRestriction], 
    ISNULL(T1.MaxULADCount, '') AS [IndigoClient!1!MaxULADCount], 
    T1.AdviserCountRestrict AS [IndigoClient!1!AdviserCountRestrict], 
    ISNULL(T1.MaxAdviserCount, '') AS [IndigoClient!1!MaxAdviserCount], 
    ISNULL(T1.EmailFormat, '') AS [IndigoClient!1!EmailFormat], 
    ISNULL(T1.UserNameFormat, '') AS [IndigoClient!1!UserNameFormat], 
    ISNULL(T1.NTDomain, '') AS [IndigoClient!1!NTDomain], 
    T1.IsIndependent AS [IndigoClient!1!IsIndependent], 
    ISNULL(T1.BrandDescriptor, '') AS [IndigoClient!1!BrandDescriptor], 
    T1.ConcurrencyId AS [IndigoClient!1!ConcurrencyId], 
    NULL AS [ServiceLevel!2!ServiceLevelId], 
    NULL AS [ServiceLevel!2!Identifier], 
    NULL AS [ServiceLevel!2!IndigoClientId], 
    NULL AS [ServiceLevel!2!ContractHostFg], 
    NULL AS [ServiceLevel!2!ConcurrencyId]
  FROM TIndigoClient T1

  WHERE (T1.IsNetwork = 1)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.IndigoClientId, 
    T1.Identifier, 
    T1.Status, 
    T1.PrimaryContact, 
    ISNULL(T1.ContactId, ''), 
    T1.PhoneNumber, 
    T1.EmailAddress, 
    ISNULL(T1.PrimaryGroupId, ''), 
    ISNULL(T1.NetworkId, ''), 
    ISNULL(T1.SIB, ''), 
    ISNULL(T1.MCCB, ''), 
    ISNULL(T1.FSA, ''), 
    T1.IOProductType, 
    CONVERT(varchar(24), T1.ExpiryDate, 120), 
    T1.AddressLine1, 
    ISNULL(T1.AddressLine2, ''), 
    ISNULL(T1.AddressLine3, ''), 
    ISNULL(T1.AddressLine4, ''), 
    ISNULL(T1.CityTown, ''), 
    ISNULL(T1.County, ''), 
    T1.Postcode, 
    T1.Country, 
    T1.IsNetwork, 
    ISNULL(T1.SupportServiceId, ''), 
    T1.FirmSize, 
    T1.Specialism, 
    ISNULL(T1.OtherSpecialism, ''), 
    T1.ServiceLevel, 
    T1.EmailSupOptn, 
    T1.SupportEmail, 
    T1.TelSupOptn, 
    T1.SupportTelephone, 
    T1.AllowPasswordEmail, 
    T1.SessionTimeout, 
    T1.LicenceType, 
    ISNULL(T1.MaxConUsers, ''), 
    ISNULL(T1.MaxULAGCount, ''), 
    T1.UADRestriction, 
    ISNULL(T1.MaxULADCount, ''), 
    T1.AdviserCountRestrict, 
    ISNULL(T1.MaxAdviserCount, ''), 
    ISNULL(T1.EmailFormat, ''), 
    ISNULL(T1.UserNameFormat, ''), 
    ISNULL(T1.NTDomain, ''), 
    T1.IsIndependent, 
    ISNULL(T1.BrandDescriptor, ''), 
    T1.ConcurrencyId, 
    T2.ServiceLevelId, 
    T2.Identifier, 
    T2.IndigoClientId, 
    T2.ContractHostFg, 
    T2.ConcurrencyId
  FROM TServiceLevel T2
  INNER JOIN TIndigoClient T1
  ON T2.IndigoClientId = T1.IndigoClientId
  
  WHERE (T1.IsNetwork = 1)
  AND ((T1.HostingFg = 1) OR (T1.HostingFg = 0 AND T2.ContractHostFg = 0))

  ORDER BY [IndigoClient!1!IndigoClientId], [ServiceLevel!2!ServiceLevelId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
