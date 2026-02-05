SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveCorporateById]
	@CorporateId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CorporateId AS [Corporate!1!CorporateId], 
	ISNULL(T1.IndClientId, '') AS [Corporate!1!IndClientId], 
	ISNULL(T1.CorporateName, '') AS [Corporate!1!CorporateName], 
	ISNULL(T1.ArchiveFg, '') AS [Corporate!1!ArchiveFg], 
	ISNULL(T1.BusinessType, '') AS [Corporate!1!BusinessType], 
	ISNULL(T1.RefCorporateTypeId, '') AS [Corporate!1!RefCorporateTypeId], 
	ISNULL(T1.CompanyRegNo, '') AS [Corporate!1!CompanyRegNo], 
	ISNULL(CONVERT(varchar(24), T1.EstIncorpDate, 120), '') AS [Corporate!1!EstIncorpDate], 
	ISNULL(CONVERT(varchar(24), T1.YearEnd, 120), '') AS [Corporate!1!YearEnd], 
	ISNULL(T1.VatRegFg, '') AS [Corporate!1!VatRegFg], 
	ISNULL(T1.VatRegNo, '') AS [Corporate!1!VatRegNo], 
	T1.ConcurrencyId AS [Corporate!1!ConcurrencyId]
	FROM TCorporate T1
	
	WHERE T1.CorporateId = @CorporateId
	ORDER BY [Corporate!1!CorporateId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
