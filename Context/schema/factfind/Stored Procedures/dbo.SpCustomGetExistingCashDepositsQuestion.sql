SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetExistingCashDepositsQuestion]
	@PartyId BIGINT
AS

DECLARE @ExistingCashDepositAccounts BIT
DECLARE @NonDisclosure BIT

SELECT @ExistingCashDepositAccounts = ExistingCashDepositAccounts FROM TPreExistingCashDepositPlansQuestions Where CRMContactId = @PartyId

SELECT @NonDisclosure =  NonDisclosure FROM TPostExistingCashDepositPlansQuestions Where CRMContactId = @PartyId

Select @ExistingCashDepositAccounts AS HasExisting, @NonDisclosure AS WishesToDisclose, CAST( 3 AS INT) PreferenceType -- Cash Deposits