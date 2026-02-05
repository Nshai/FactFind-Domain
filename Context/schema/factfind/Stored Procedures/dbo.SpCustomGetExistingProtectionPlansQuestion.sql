SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetExistingProtectionPlansQuestion]
	@PartyId BIGINT
AS

DECLARE @ExistingProtectionPlans BIT
DECLARE @NonDisclosure BIT

SELECT @ExistingProtectionPlans = HasExistingProvision,
	@NonDisclosure = NonDisclosure
FROM TProtectionMiscellaneous Where CRMContactId = @PartyId

SELECT @ExistingProtectionPlans AS HasExisting, @NonDisclosure AS WishesToDisclose, CAST( 6 AS INT) PreferenceType -- Protection