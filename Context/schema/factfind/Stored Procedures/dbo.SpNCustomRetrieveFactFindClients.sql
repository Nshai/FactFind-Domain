SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFactFindClients]
	@FactFindId bigint
AS
DECLARE
	@CRMContactId1 bigint,
	@CRMContactId2 bigint,
	@IndigoClientId bigint
	
SELECT 
	@CRMContactId1 = CRMContactId1,
	@CRMContactId2 = CRMContactId2,
	@IndigoClientId = @IndigoClientId
FROM
	TFactFind
WHERE
	FactFindId = @FactFindId

-- Get Client Details
SELECT
	CRMContactId,
	CRMContactType,
	FirstName,
	LastName,
	CorporateName,
	CASE CRMContactId WHEN @CRMContactId1 THEN 'true' ELSE 'false' END AS PrimaryClient,
	CASE CRMContactType
		WHEN 1 THEN FirstName + ' ' + LastName
		ELSE CorporateName
	END AS ClientName
FROM
	CRM..TCRMContact
WHERE
	CRMContactId IN (@CRMContactId1,@CRMContactId2)
GO
