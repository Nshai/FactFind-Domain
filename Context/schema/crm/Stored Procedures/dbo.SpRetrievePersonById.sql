SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePersonById]
	@PersonId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PersonId AS [Person!1!PersonId], 
	ISNULL(T1.Title, '') AS [Person!1!Title], 
	T1.FirstName AS [Person!1!FirstName], 
	ISNULL(T1.MiddleName, '') AS [Person!1!MiddleName], 
	T1.LastName AS [Person!1!LastName], 
	ISNULL(T1.MaidenName, '') AS [Person!1!MaidenName], 
	ISNULL(CONVERT(varchar(24), T1.DOB, 120), '') AS [Person!1!DOB], 
	ISNULL(T1.GenderType, '') AS [Person!1!GenderType], 
	ISNULL(T1.NINumber, '') AS [Person!1!NINumber], 
	ISNULL(T1.IsSmoker, '') AS [Person!1!IsSmoker], 
	ISNULL(T1.UKResident, '') AS [Person!1!UKResident], 
	ISNULL(T1.ResidentIn, '') AS [Person!1!ResidentIn], 
	ISNULL(T1.Salutation, '') AS [Person!1!Salutation], 
	ISNULL(T1.MaritalStatus, '') AS [Person!1!MaritalStatus], 
	ISNULL(CONVERT(varchar(24), T1.MarriedOn, 120), '') AS [Person!1!MarriedOn], 
	ISNULL(T1.Residency, '') AS [Person!1!Residency], 
	ISNULL(T1.Domicile, '') AS [Person!1!Domicile], 
	ISNULL(T1.TaxCode, '') AS [Person!1!TaxCode], 
	T1.ArchiveFG AS [Person!1!ArchiveFG], 
	T1.IndClientId AS [Person!1!IndClientId], 
	T1.ConcurrencyId AS [Person!1!ConcurrencyId]
	FROM TPerson T1
	
	WHERE PersonId = @PersonId
	ORDER BY [Person!1!PersonId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
