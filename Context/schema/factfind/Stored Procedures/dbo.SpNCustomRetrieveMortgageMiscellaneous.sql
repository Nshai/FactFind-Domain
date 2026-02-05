CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgageMiscellaneous]
(
	@CRMContactId BIGINT,
	@CRMContactId2 BIGINT,
	@TenantId BIGINT
)
As
BEGIN
	DECLARE @IsContact2MainClient BIT = 0

	SELECT @IsContact2MainClient = 1
	WHERE EXISTS(
		SELECT * FROM factfind..TFactFind
		WHERE IndigoClientId = @TenantID
		AND CRMContactId1 = @CRMContactId2
		AND CRMContactId2 = @CRMContactId)

	SELECT DISTINCT
		m.MortgageMiscellaneousId AS "Id",
		m.CRMContactId AS "PartyId",
		m.Notes AS "Notes",
		m.HasExistingProvision AS "HasExistingProvision",
		m.HasEquityRelease AS "HasEquityRelease"
	FROM factfind..TMortgageMiscellaneous AS m
	INNER JOIN crm..TCRMContact AS c
		ON m.CRMContactId = c.CRMContactId
	WHERE c.IndClientId = @TenantId
	AND m.CRMContactId = CASE @IsContact2MainClient WHEN 1 THEN @CRMContactId2 ELSE @CRMContactId END

END
