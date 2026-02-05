SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetRetirementPlanPreferenceQuestions]
	@PartyId BIGINT
AS

--DECLARE	@PartyId BIGINT = 4670733
DECLARE @ExistingMoneyPurchasePlans BIT
DECLARE @NonDisclosureMoneyPurchase BIT
DECLARE @ExistingAnnuityPlans BIT
DECLARE @NonDisclosureAnnuity BIT
DECLARE @ExistingPersonalPensionPlans BIT
DECLARE @NonDisclosurePersonalPension BIT
DECLARE @ExistingFinalSalaryPlans BIT
DECLARE @NonDisclosureFinalSalary BIT

SELECT 
	@ExistingMoneyPurchasePlans = ExistingMoneyPurchaseSchemes
,	@ExistingAnnuityPlans= HasAnnuities
,	@NonDisclosureAnnuity = IsAnnuityNonDisclosed
,	@ExistingPersonalPensionPlans = HasPersonalPensions
,	@NonDisclosurePersonalPension = IsPersonalPensionNonDisclosed
FROM factfind..TPreExistingMoneyPurchasePlansQuestions 
WHERE CRMContactId = @PartyId

SELECT 
	@NonDisclosureMoneyPurchase = NonDisclosure 
FROM factfind..TPostExistingMoneyPurchasePlansQuestions 
WHERE CRMContactId = @PartyId

SELECT 
	@ExistingFinalSalaryPlans = HasExistingSchemesFg 
FROM TPreExistingFinalSalaryPensionPlansQuestions 
WHERE CRMContactId = @PartyId


SELECT 
	@NonDisclosureFinalSalary = NonDisclosure 
FROM TPostExistingFinalSalaryPensionPlansQuestions 
WHERE CRMContactId = @PartyId


SELECT 
	@ExistingMoneyPurchasePlans AS HasExisting
,	@NonDisclosureMoneyPurchase AS WishesToDisclose
,	CAST( 4 AS INT) PreferenceType -- Money Purchase
UNION ALL
SELECT 
	@ExistingAnnuityPlans AS HasExisting
,	@NonDisclosureAnnuity AS WishesToDisclose
,	CAST( 7 AS INT) PreferenceType -- Annuity
UNION ALL
SELECT 
	@ExistingPersonalPensionPlans AS HasExisting
,	@NonDisclosurePersonalPension AS WishesToDisclose
,	CAST( 5 AS INT) PreferenceType -- Personal Pension
UNION ALL
SELECT 
	@ExistingFinalSalaryPlans AS HasExisting
,	@NonDisclosureFinalSalary AS WishesToDisclose
,	CAST( 2 AS INT) PreferenceType -- Final salary
