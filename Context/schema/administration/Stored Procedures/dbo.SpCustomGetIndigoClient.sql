SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetIndigoClient]
	@IndigoClientId bigint    
AS  
SELECT  
    T1.IndigoClientId AS [IndigoClientId],   
    T1.Identifier AS [Identifier],   
    T1.Status AS [Status],   
    T1.PrimaryContact AS [PrimaryContact],   
    ISNULL(T1.ContactId, '') AS [ContactId],   
    T1.PhoneNumber AS [PhoneNumber],   
    T1.EmailAddress AS [EmailAddress],   
    ISNULL(T1.PrimaryGroupId, '') AS [PrimaryGroupId],   
    ISNULL(T1.NetworkId, '') AS [NetworkId],   
    ISNULL(T1.SIB, '') AS [SIB],   
    ISNULL(T1.MCCB, '') AS [MCCB],   
    ISNULL(T1.FSA, '') AS [FSA],   
    T1.IOProductType AS [IOProductType],   
    CONVERT(varchar(24), T1.ExpiryDate, 120) AS [ExpiryDate],   
    T1.AddressLine1 AS [AddressLine1],   
    ISNULL(T1.AddressLine2, '') AS [AddressLine2],   
    ISNULL(T1.AddressLine3, '') AS [AddressLine3],   
    ISNULL(T1.AddressLine4, '') AS [AddressLine4],   
    ISNULL(T1.CityTown, '') AS [CityTown],   
    ISNULL(T1.County, '') AS [County],   
    T1.Postcode AS [Postcode],   
    T1.Country AS [Country],   
    T1.IsNetwork AS [IsNetwork],   
    ISNULL(T1.SupportServiceId, '') AS [SupportServiceId],   
    T1.FirmSize AS [FirmSize],   
    T1.Specialism AS [Specialism],   
    ISNULL(T1.OtherSpecialism, '') AS [OtherSpecialism],   
    T1.ServiceLevel AS [ServiceLevel],   
    T1.EmailSupOptn AS [EmailSupOptn],   
    T1.SupportEmail AS [SupportEmail],   
    T1.TelSupOptn AS [TelSupOptn],   
    T1.SupportTelephone AS [SupportTelephone],   
    T1.AllowPasswordEmail AS [AllowPasswordEmail],   
    T1.SessionTimeout AS [SessionTimeout],   
    T1.LicenceType AS [LicenceType],   
    T1.MaxConUsers AS [MaxConUsers],   
    T1.MaxULAGCount AS [MaxULAGCount],   
    T1.UADRestriction AS [UADRestriction],   
    T1.MaxULADCount AS [MaxULADCount],   
    T1.AdviserCountRestrict AS [AdviserCountRestrict],   
    T1.MaxAdviserCount AS [MaxAdviserCount],   
	T1.MaxFinancialPlanningUsers As [MaxFinancialPlanningUsers],   
	T1.MaxAdvisaCentaCoreUsers As [MaxAdvisaCentaCoreUsers],
	T1.MaxAdvisaCentaCorePlusLifetimePlannerUsers As [MaxAdvisaCentaCorePlusLifetimePlannerUsers],
	T1.MaxAdvisaCentaFullUsers As [MaxAdvisaCentaFullUsers],
	T1.MaxAdvisaCentaFullPlusLifetimePlannerUsers As [MaxAdvisaCentaFullPlusLifetimePlannerUsers],
	T1.MaxFeAnalyticsCoreUsers As [MaxFeAnalyticsCoreUsers],
	T1.MaxPensionFreedomPlannerUsers As [MaxPensionFreedomPlannerUsers],
	T1.MaxVoyantUsers As [MaxVoyantUsers],
    ISNULL(T1.EmailFormat, '') AS [EmailFormat],   
    ISNULL(T1.UserNameFormat, '') AS [UserNameFormat],   
    ISNULL(T1.NTDomain, '') AS [NTDomain],   
    CAST(CASE WHEN NetworkId IS NOT NULL THEN 1 ELSE 0 END as bit) AS IsMember,
    (-- Country data
	SELECT  
		T3.RefCountryId AS [RefCountryId],  
		T3.CountryName AS [CountryName]
	FROM 
		CRM..TRefCountry T3  
	WHERE 
		T3.RefCountryId = T1.Country
	FOR XML RAW('RefCountry'), TYPE),
	(-- Service Level
	SELECT  
		T4.ServiceLevelId AS [ServiceLevelId],  
		T4.Identifier AS [Identifier]
	FROM TServiceLevel T4  
	WHERE T4.ServiceLevelId = T1.ServiceLevel
	FOR XML RAW('ServiceLevel'), TYPE),
	(-- Linked tenants
	SELECT
		T5.IndigoClientId AS [IndigoClientId],  
		T5.Identifier AS [Identifier]
	FROM TIndigoClient T5  
	WHERE T5.IndigoClientId = T1.NetworkId
	FOR XML RAW('IndigoClient'), TYPE),
	(-- Ref Country data
	SELECT  
		T6.RefCountyId AS [RefCountyId],  
		T6.CountyName AS [CountyName]  
	FROM CRM..TRefCounty T6  
	WHERE T6.RefCountyId = T1.County
	FOR XML RAW('RefCounty'), TYPE)
FROM 
	TIndigoClient T1
WHERE 
	T1.IndigoClientId = @IndigoClientId
FOR XML RAW('IndigoClient')
GO
