SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveServiceLevelWithActiveIndigoClient]
@Status varchar (24),
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ServiceLevelId AS [ServiceLevel!1!ServiceLevelId], 
    T1.Identifier AS [ServiceLevel!1!Identifier], 
    T1.IndigoClientId AS [ServiceLevel!1!IndigoClientId], 
    T1.ContractHostFg AS [ServiceLevel!1!ContractHostFg], 
    T1.UseNetworkAuthorDocs AS [ServiceLevel!1!UseNetworkAuthorDocs], 
    T1.ConcurrencyId AS [ServiceLevel!1!ConcurrencyId], 
    NULL AS [IndigoClient!2!IndigoClientId], 
    NULL AS [IndigoClient!2!Identifier], 
    NULL AS [IndigoClient!2!Status], 
    NULL AS [IndigoClient!2!PrimaryContact], 
    NULL AS [IndigoClient!2!ContactId], 
    NULL AS [IndigoClient!2!PhoneNumber], 
    NULL AS [IndigoClient!2!EmailAddress], 
    NULL AS [IndigoClient!2!PrimaryGroupId], 
    NULL AS [IndigoClient!2!NetworkId], 
    NULL AS [IndigoClient!2!SIB], 
    NULL AS [IndigoClient!2!MCCB], 
    NULL AS [IndigoClient!2!FSA], 
    NULL AS [IndigoClient!2!IOProductType], 
    NULL AS [IndigoClient!2!ExpiryDate], 
    NULL AS [IndigoClient!2!AddressLine1], 
    NULL AS [IndigoClient!2!AddressLine2], 
    NULL AS [IndigoClient!2!AddressLine3], 
    NULL AS [IndigoClient!2!AddressLine4], 
    NULL AS [IndigoClient!2!CityTown], 
    NULL AS [IndigoClient!2!County], 
    NULL AS [IndigoClient!2!Postcode], 
    NULL AS [IndigoClient!2!Country], 
    NULL AS [IndigoClient!2!IsNetwork], 
    NULL AS [IndigoClient!2!SupportServiceId], 
    NULL AS [IndigoClient!2!FirmSize], 
    NULL AS [IndigoClient!2!Specialism], 
    NULL AS [IndigoClient!2!OtherSpecialism], 
    NULL AS [IndigoClient!2!SupportLevel], 
    NULL AS [IndigoClient!2!EmailSupOptn], 
    NULL AS [IndigoClient!2!SupportEmail], 
    NULL AS [IndigoClient!2!TelSupOptn], 
    NULL AS [IndigoClient!2!SupportTelephone], 
    NULL AS [IndigoClient!2!AllowPasswordEmail], 
    NULL AS [IndigoClient!2!SessionTimeout], 
    NULL AS [IndigoClient!2!LicenceType], 
    NULL AS [IndigoClient!2!MaxConUsers], 
    NULL AS [IndigoClient!2!MaxULAGCount], 
    NULL AS [IndigoClient!2!UADRestriction], 
    NULL AS [IndigoClient!2!MaxULADCount], 
    NULL AS [IndigoClient!2!AdviserCountRestrict], 
    NULL AS [IndigoClient!2!MaxAdviserCount], 
    NULL AS [IndigoClient!2!EmailFormat], 
    NULL AS [IndigoClient!2!UserNameFormat], 
    NULL AS [IndigoClient!2!NTDomain], 
    NULL AS [IndigoClient!2!IsIndependent], 
    NULL AS [IndigoClient!2!BrandDescriptor], 
    NULL AS [IndigoClient!2!ServiceLevel], 
    NULL AS [IndigoClient!2!HostingFg], 
    NULL AS [IndigoClient!2!ConcurrencyId]
  FROM TServiceLevel T1
  WHERE T1.IndigoClientId = @IndigoClientId

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.ServiceLevelId, 
    T1.Identifier, 
    T1.IndigoClientId, 
    T1.ContractHostFg, 
    T1.UseNetworkAuthorDocs,
    T1.ConcurrencyId, 
    T2.IndigoClientId, 
    T2.Identifier, 
    T2.Status, 
    T2.PrimaryContact, 
    ISNULL(T2.ContactId, ''), 
    T2.PhoneNumber, 
    T2.EmailAddress, 
    ISNULL(T2.PrimaryGroupId, ''), 
    ISNULL(T2.NetworkId, ''), 
    ISNULL(T2.SIB, ''), 
    ISNULL(T2.MCCB, ''), 
    ISNULL(T2.FSA, ''), 
    T2.IOProductType, 
    CONVERT(varchar(24), T2.ExpiryDate, 120), 
    T2.AddressLine1, 
    ISNULL(T2.AddressLine2, ''), 
    ISNULL(T2.AddressLine3, ''), 
    ISNULL(T2.AddressLine4, ''), 
    ISNULL(T2.CityTown, ''), 
    ISNULL(T2.County, ''), 
    T2.Postcode, 
    T2.Country, 
    T2.IsNetwork, 
    ISNULL(T2.SupportServiceId, ''), 
    T2.FirmSize, 
    T2.Specialism, 
    ISNULL(T2.OtherSpecialism, ''), 
    T2.SupportLevel, 
    T2.EmailSupOptn, 
    T2.SupportEmail, 
    T2.TelSupOptn, 
    T2.SupportTelephone, 
    T2.AllowPasswordEmail, 
    T2.SessionTimeout, 
    T2.LicenceType, 
    ISNULL(T2.MaxConUsers, ''), 
    ISNULL(T2.MaxULAGCount, ''), 
    T2.UADRestriction, 
    ISNULL(T2.MaxULADCount, ''), 
    T2.AdviserCountRestrict, 
    ISNULL(T2.MaxAdviserCount, ''), 
    ISNULL(T2.EmailFormat, ''), 
    ISNULL(T2.UserNameFormat, ''), 
    ISNULL(T2.NTDomain, ''), 
    T2.IsIndependent, 
    ISNULL(T2.BrandDescriptor, ''), 
    ISNULL(T2.ServiceLevel, ''), 
    T2.HostingFg, 
    T2.ConcurrencyId
  FROM TIndigoClient T2
   INNER JOIN TServiceLevel T1
  ON T1.ServiceLevelId = T2.ServiceLevel
  WHERE (T2.Status != @Status) 
  AND T1.IndigoClientId = @IndigoClientId
  ORDER BY [ServiceLevel!1!ServiceLevelId], [IndigoClient!2!IndigoClientId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
