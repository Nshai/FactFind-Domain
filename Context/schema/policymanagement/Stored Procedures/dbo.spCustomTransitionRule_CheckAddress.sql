SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckAddress]
  @PolicyBusinessId BIGINT,
  @ResponseCode VARCHAR(1024) OUTPUT
AS
BEGIN

DECLARE @Owners TABLE 
(
	OwnerNumber INT IDENTITY(1,1) PRIMARY KEY,
	CRMContactId BIGINT, 
	Name VARCHAR(255),
	HasValidAddress BIT
)

--Get Policy Owners
INSERT INTO @Owners (CRMContactId, HasValidAddress)
SELECT PO.CRMContactId, 0
FROM TPolicyOwner PO
JOIN TPolicyDetail PD ON PO.PolicyDetailId = PD.PolicyDetailId
JOIN PolicyManagement..TPolicyBusiness PB ON PD.PolicyDetailId = PB.PolicyDetailId
WHERE PB.PolicyBusinessId = @PolicyBusinessId
ORDER BY PO.PolicyOwnerId

--Get Policy Additional Owners
INSERT INTO @Owners (CRMContactId, HasValidAddress)
SELECT AO.CRMContactId, 0
FROM PolicyManagement..TAdditionalOwner AO
WHERE AO.PolicyBusinessId = @PolicyBusinessId
ORDER BY AO.AdditionalOwnerId

UPDATE O
SET HasValidAddress = 1
FROM @Owners O
JOIN CRM..TAddress A ON O.CRMContactId = A.CRMContactId
JOIN CRM..TAddressStore S on A.AddressStoreId = S.AddressStoreId
LEFT JOIN CRM..TRefCountry C ON S.RefCountryId = C.RefCountryId
WHERE
LEN(S.AddressLine1) > 0 AND 
LEN(S.CityTown) > 0 AND 
LEN(C.CountryName) > 0 AND
(LEN(S.PostCode) > 0 OR C.CountryName NOT IN ('Scotland', 'United Kingdom'))

-- Update CRMContact Names --
UPDATE O
SET Name = ISNULL(C.CorporateName, '') + ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, '')
FROM @Owners O
JOIN CRM..TCRMContact C ON O.CRMContactId = C.CRMContactId
--WHERE O.HasValidAddress = 0


DECLARE @OwnerNumberCounter INT = 0,
		@RemainingCount INT = 0,
		@Subcode VARCHAR(100) = '',
		@Data VARCHAR(1024) = ''

WHILE (1 = 1)
BEGIN
	SET @OwnerNumberCounter = (SELECT MIN(OwnerNumber) FROM @Owners WHERE HasValidAddress = 0 AND OwnerNumber > @OwnerNumberCounter)
	
	IF(@OwnerNumberCounter IS NULL)
		BREAK
	
	IF(LEN(@Subcode) > 0)
		SET @Subcode = @Subcode + '+'
		
	SET @Subcode = @Subcode + 'OWNER' + CONVERT(VARCHAR, @OwnerNumberCounter)
	
	UPDATE O
	SET @Data = @Data + 
				'::Owner' + CONVERT(VARCHAR, @OwnerNumberCounter) + 'Id=' + CONVERT(VARCHAR, O.CRMContactId) +
				'::Owner' + CONVERT(VARCHAR, @OwnerNumberCounter) + 'Name=' + ISNULL(O.Name, '')
	FROM @Owners O
	WHERE OwnerNumber = @OwnerNumberCounter
END 

IF(LEN(@Subcode) > 0 AND LEN(@Data) > 0)
	SET @ResponseCode = @Subcode + '_' + @Data
		
END


