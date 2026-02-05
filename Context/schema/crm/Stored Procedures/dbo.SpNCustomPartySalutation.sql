SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomPartySalutation]	
	@PartyId bigint,
	@RelatedPartyId bigint = 0,
	@TenantId bigint
AS

--DECLARE @TenantId bigint = 10155
--DECLARE @PartyId bigint = 4670733
--DECLARE @RelatedPartyId bigint = 4670731

IF OBJECT_ID('tempdb..#partySalutation') IS NOT NULL
	DROP TABLE #partySalutation

SELECT 
	c.CRMContactId CRMContactId,
	p.Salutation Salutation,
	ISNULL(p.Title,'') Title,
	SUBSTRING(ISNULL(p.FirstName,''), 1, 1) Initial,
	p.LastName LastName,
	1 as JoinId,
	CASE WHEN ISNULL(c.CorporateName, '') <> ''
		THEN 1 ELSE 0
	END IsCorporate,	
	CASE WHEN c.CRMContactId = @PartyId
		THEN 1 ELSE 0
	END IsPrimary
INTO #partySalutation
FROM crm..TCRMContact c
		LEFT JOIN crm..TPerson p 
		ON p.PersonId = c.PersonId
WHERE c.IndClientId = @TenantId and c.CRMContactId in(@PartyId, @RelatedPartyId)

SELECT  
cl1.CRMContactId Party1Id,
cl1.Salutation Party1Salutation,
cl1.Title Party1Title,
cl1.Initial Party1Initial,
cl1.LastName Party1LastName,
cl1.IsCorporate Party1IsCorporate,
cl2.CRMContactId Party2Id,
cl2.Salutation Party2Salutation,
cl2.Title Party2Title,
cl2.Initial Party2Initial,
cl2.LastName Party2LastName,
cl2.IsCorporate Party2IsCorporate
FROM #partySalutation cl1
		LEFT JOIN #partySalutation cl2 
		ON cl1.JoinId = cl2.JoinId and cl1.CRMContactId <> cl2.CRMContactId
WHERE cl1.IsPrimary = 1

