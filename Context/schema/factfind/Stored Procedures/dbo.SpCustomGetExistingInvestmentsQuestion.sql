SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetExistingInvestmentsQuestion]
	@PartyId BIGINT
AS

DECLARE @ExistingOtherInvestments BIT
DECLARE @NonDisclosure BIT

SELECT @ExistingOtherInvestments = ExistingOtherInvestments FROM TPreExistingOtherInvestmentPlansQuestions Where CRMContactId = @PartyId

SELECT @NonDisclosure =  NonDisclosure FROM TPostExistingOtherInvestmentPlansQuestions Where CRMContactId = @PartyId

Select @ExistingOtherInvestments AS HasExisting, @NonDisclosure AS WishesToDisclose, CAST( 1 AS INT) PreferenceType -- Investments