SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveIntroducerById]
	@IntroducerId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.IntroducerId AS [Introducer!1!IntroducerId], 
	T1.IndClientId AS [Introducer!1!IndClientId], 
	T1.CRMContactId AS [Introducer!1!CRMContactId], 
	ISNULL(CONVERT(varchar(24), T1.AgreementDate, 120), '') AS [Introducer!1!AgreementDate], 
	T1.RefIntroducerTypeId AS [Introducer!1!RefIntroducerTypeId], 
	ISNULL(T1.PractitionerId, '') AS [Introducer!1!PractitionerId], 
	T1.ArchiveFG AS [Introducer!1!ArchiveFG], 
	ISNULL(T1.Identifier, '') AS [Introducer!1!Identifier], 
	ISNULL(T1.UniqueIdentifier, '') AS [Introducer!1!UniqueIdentifier], 
	T1.ConcurrencyId AS [Introducer!1!ConcurrencyId]
	FROM TIntroducer T1
	
	WHERE T1.IntroducerId = @IntroducerId
	ORDER BY [Introducer!1!IntroducerId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
