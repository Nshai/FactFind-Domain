SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveGroupById]
	@GroupId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.GroupId AS [Group!1!GroupId], 
	T1.Identifier AS [Group!1!Identifier], 
	T1.GroupingId AS [Group!1!GroupingId], 
	ISNULL(T1.ParentId, '') AS [Group!1!ParentId], 
	ISNULL(T1.CRMContactId, '') AS [Group!1!CRMContactId], 
	T1.IndigoClientId AS [Group!1!IndigoClientId], 
	T1.LegalEntity AS [Group!1!LegalEntity], 
	ISNULL(T1.GroupImageLocation, '') AS [Group!1!GroupImageLocation], 
	ISNULL(T1.AcknowledgementsLocation, '') AS [Group!1!AcknowledgementsLocation], 
	ISNULL(CONVERT(varchar(24), T1.FinancialYearEnd, 120), '') AS [Group!1!FinancialYearEnd], 
	T1.ApplyFactFindBranding AS [Group!1!ApplyFactFindBranding], 
	ISNULL(T1.VatRegNbr, '') AS [Group!1!VatRegNbr], 
	ISNULL(T1.AuthorisationText, '') AS [Group!1!AuthorisationText], 
	T1.ConcurrencyId AS [Group!1!ConcurrencyId]
	FROM TGroup T1
	
	WHERE T1.GroupId = @GroupId
	ORDER BY [Group!1!GroupId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
