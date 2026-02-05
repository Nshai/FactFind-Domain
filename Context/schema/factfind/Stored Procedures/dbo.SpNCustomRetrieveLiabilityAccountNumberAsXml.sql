SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLiabilityAccountNumberAsXml]
	@CRMContactId1 bigint,
	@CRMContactId2 bigint 

AS
SELECT
	LiabilitiesId,
	LTRIM(
		ISNULL(LenderName, '') + 
		ISNULL(' ' + CommitedOutgoings,'') + 
		ISNULL(' ' + CONVERT(VARCHAR(25),LiabilityAccountNumber),'') + 
		ISNULL(' ' + CONVERT(VARCHAR(25),Amount),'')
	) AS [Name]
FROM
	factfind..TLiabilities
WHERE 
	CRMContactId IN (@CRMContactId1, @CRMContactId2)
	AND CRMContactId != 0 
	AND NOT (LenderName IS NULL AND CommitedOutgoings IS NULL 
		AND LiabilityAccountNumber IS NULL AND Amount IS NULL)
FOR XML RAW('Liability')
GO
