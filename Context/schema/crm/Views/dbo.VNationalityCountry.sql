SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VNationalityCountry]

AS

SELECT DISTINCT 
	C.RefCountryId, 
	C.CountryName, 
	NC.ISOAlpha3Code, 
	NC.RefNationalityId, 
	C.ArchiveFG
	FROM dbo.TRefCountry C
	INNER JOIN dbo.TRefNationality2RefCountry NC ON C.RefCountryId = NC.RefCountryId