SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNioCustomTrustByCustomerStatus]
	@CRMContactIds VARCHAR(8000) , @TenantId INT, @CRMContactStatusId INT
AS
BEGIN
SET NOCOUNT ON;

	SELECT	
		t.TrustName AS TrustName,
		rtt.TrustTypeName AS TrustTypeName,
		t.EstDate AS EstablishedDate,
		t.Instrument AS Instrument,
		t.NatureOfTrust AS NatureOfTrust, 
		t.LEI AS LEI,
		t.LEIExpiryDate AS LEIExpiryDate,
		t.RegistrationNumber AS RegistrationNumber,
		t.RegistrationDate AS RegistrationDate,
		t.EstablishmentCountryId AS EstablishmentCountryId,
		t.ResidenceCountryId AS ResidenceCountryId
	FROM crm..TCRMContact ct
	INNER JOIN STRING_SPLIT(@CRMContactIds, ',') parslist   
				ON ct.CRMContactId = parslist.Value
	INNER JOIN crm..TTrust t on t.TrustId = ct.TrustId
	INNER JOIN crm..TRefTrustType rtt on t.RefTrustTypeId = rtt.RefTrustTypeId
	WHERE ct.IndClientId = @TenantId and 
		  ct.RefCRMContactStatusId = @CRMContactStatusId

SET NOCOUNT OFF
END