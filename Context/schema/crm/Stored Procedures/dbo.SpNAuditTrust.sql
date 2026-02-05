SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditTrust] @StampUser VARCHAR(255)
	,@TrustId BIGINT
	,@StampAction CHAR(1)
AS
INSERT INTO TTrustAudit (
	RefTrustTypeId
	,IndClientId
	,TrustName
	,EstDate
	,ArchiveFG
	,ConcurrencyId
	,TrustId
	,StampAction
	,StampDateTime
	,StampUser
	,[LEI]
	,[LEIExpiryDate]
	,[RegistrationNumber]
	,[RegistrationDate]
	,[Instrument]
	,[BusinessRegistrationNumber]
	,[NatureOfTrust]
	,[VatRegNo]
	,[EstablishmentCountryId]
	,[ResidenceCountryId]
	)
SELECT RefTrustTypeId
	,IndClientId
	,TrustName
	,EstDate
	,ArchiveFG
	,ConcurrencyId
	,TrustId
	,@StampAction
	,GetDate()
	,@StampUser
	,[LEI]
	,[LEIExpiryDate]
	,[RegistrationNumber]
	,[RegistrationDate]
	,[Instrument]
	,[BusinessRegistrationNumber]
	,[NatureOfTrust]
	,[VatRegNo]
	,[EstablishmentCountryId]
	,[ResidenceCountryId]
FROM TTrust
WHERE TrustId = @TrustId

IF @@ERROR != 0
	GOTO errh

RETURN (0)

errh:

RETURN (100)
GO