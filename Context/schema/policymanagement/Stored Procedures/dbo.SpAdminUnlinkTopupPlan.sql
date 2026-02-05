SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpAdminUnlinkTopupPlan]
	@TenantId int,
	@MasterPlanIOBRef varchar(50),
	@TopupPlanIOBRef varchar(50),
	@StampUser varchar(255) = '0'
AS
-----------------------------------
-- Declarations
-----------------------------------
DECLARE @StampDateTime datetime = GETDATE()
DECLARE @PlanDescriptionId int, @PlanDescriptionIdNew int, @PolicyDetailIdNew int
DECLARE @MasterPolicyBusinessId int, @MasterPolicyDetailId int
DECLARE @TopupPolicyBusinessId int, @PolicyDetailId int, @TopupMasterPolicyBusinessId int

-------------------------------------------------------
-- Data checks
-------------------------------------------------------
SELECT @MasterPolicyBusinessId = PolicyBusinessId, @MasterPolicyDetailId = PolicyDetailId
FROM TPolicyBusiness
WHERE IndigoClientId = @TenantId AND SequentialRef = @MasterPlanIOBRef

IF @MasterPolicyBusinessId IS NULL
	THROW 51000, 'Master plan not found', 1;

SELECT @TopupPolicyBusinessId = PolicyBusinessId, @PolicyDetailId = PolicyDetailId, @TopupMasterPolicyBusinessId = TopupMasterPolicyBusinessId
FROM TPolicyBusiness
WHERE IndigoClientId = @TenantId AND SequentialRef = @TopupPlanIOBRef

IF @TopupPolicyBusinessId IS NULL
	THROW 51000, 'Topup plan not found', 1;

IF @TopupMasterPolicyBusinessId IS NULL
	THROW 51000, 'Topup specified is not linked to a master plan', 1;

IF @TopupMasterPolicyBusinessId != @MasterPolicyBusinessId
	THROW 51000, 'Topup is not linked to the master plan specified', 1;

IF @PolicyDetailId != @MasterPolicyDetailId
	THROW 51000, 'Master and Topup have different Policy Detail information', 1;

-------------------------------------------------------
-- Create new Plan Description for the topup.
-------------------------------------------------------
SET XACT_ABORT ON
BEGIN TRAN

SELECT @PlanDescriptionId = PlanDescriptionId
FROM TPolicyDetail
WHERE PolicyDetailId = @PolicyDetailId

INSERT INTO TPlanDescription (
	RefPlanType2ProdSubTypeId, RefProdProviderId, SchemeOwnerCRMContactId, SchemeStatus, SchemeNumber, SchemeName, SchemeStatusDate, SchemeSellingAdvisorPractitionerId, MaturityDate, ConcurrencyId, PlanMigrationRef)
SELECT
	RefPlanType2ProdSubTypeId, RefProdProviderId, SchemeOwnerCRMContactId, SchemeStatus, SchemeNumber, SchemeName, SchemeStatusDate, SchemeSellingAdvisorPractitionerId, MaturityDate, ConcurrencyId, PlanMigrationRef
FROM
	TPlanDescription
WHERE
	PlanDescriptionId = @PlanDescriptionId

-- Audit
SET @PlanDescriptionIdNew = SCOPE_IDENTITY()
EXEC SpNAuditPlanDescription @StampUser, @PlanDescriptionIdNew, 'C'

-------------------------------------------------------
-- Create new PolicyDetail information for the topup.
-------------------------------------------------------
INSERT INTO TPolicyDetail (
	PlanDescriptionId, TermYears, WholeOfLifeFg, LetterOfAuthorityFg, ContractOutOfSERPSFg, ContractOutStartDate, ContractOutStopDate, AssignedCRMContactId, JoiningDate, LeavingDate, IndigoClientId, Extensible, ConcurrencyId, PlanMigrationRef, GrossAnnualIncome, RefAnnuityPaymentTypeId, CapitalElement, AssumedGrowthRatePercentage)
SELECT
	@PlanDescriptionIdNew, TermYears, WholeOfLifeFg, LetterOfAuthorityFg, ContractOutOfSERPSFg, ContractOutStartDate, ContractOutStopDate, AssignedCRMContactId, JoiningDate, LeavingDate, IndigoClientId, Extensible, ConcurrencyId, PlanMigrationRef, GrossAnnualIncome, RefAnnuityPaymentTypeId, CapitalElement, AssumedGrowthRatePercentage
FROM
	TPolicyDetail 
WHERE 
	PolicyDetailId = @PolicyDetailId

SELECT @PolicyDetailIdNew = SCOPE_IDENTITY()
-- Audit
EXEC SpNAuditPolicyDetail @StampUser, @PolicyDetailIdNew, 'C'

-------------------------------------------------------
-- Create new PolicyOwner information for the topup.
-------------------------------------------------------
INSERT INTO TPolicyOwner (
	CRMContactId, PolicyDetailId, ConcurrencyId, PlanMigrationRef)
OUTPUT
	inserted.CRMContactId, inserted.PolicyDetailId, inserted.ConcurrencyId, inserted.PolicyOwnerId, 'C', @StampDateTime, @StampUser, inserted.PlanMigrationRef
INTO 
	TPolicyOwnerAudit (CRMContactId, PolicyDetailId, ConcurrencyId, PolicyOwnerId, StampAction, StampDateTime, StampUser, PlanMigrationRef)
SELECT
	CRMContactId, @PolicyDetailIdNew, ConcurrencyId, PlanMigrationRef
FROM
	TPolicyOwner
WHERE
	PolicyDetailId = @PolicyDetailId
ORDER BY
	PolicyOwnerId

-------------------------------------------------------
-- Update TPolicyBusiness with new PolicyDetail information
-------------------------------------------------------
EXEC SpNAuditPolicyBusiness @StampUser, @TopupPolicyBusinessId, 'U'

UPDATE 
	TPolicyBusiness
SET
	PolicyDetailId = @PolicyDetailIdNew,
	TopupMasterPolicyBusinessId = NULL
WHERE
	PolicyBusinessId = @TopupPolicyBusinessId

-------------------------------------------------------
-- Update TDNPolicyMatching with new details
-------------------------------------------------------
INSERT INTO Commissions..TDnPolicyMatchingAudit (
	IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, RefProdProviderId, ProviderName, BandingTemplateId, RefComTypeId, RefComTypeName, PractitionerId, PractUserId, PractName, ClientId, ClientFirstName, ClientLastName, PreSubmissionFG, StatusId, StatusDate, SubmittedDate, RefPlanType2ProdSubTypeId, GroupId, ConcurrencyId, DnPolicyMatchingId, StampAction, StampDateTime, StampUser, TopupMasterPolicyId)
SELECT
	IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, RefProdProviderId, ProviderName, BandingTemplateId, RefComTypeId, RefComTypeName, PractitionerId, PractUserId, PractName, ClientId, ClientFirstName, ClientLastName, PreSubmissionFG, StatusId, StatusDate, SubmittedDate, RefPlanType2ProdSubTypeId, GroupId, ConcurrencyId, DnPolicyMatchingId, 'U', @StampDateTime, @StampUser, TopupMasterPolicyId
FROM
	Commissions..TDnPolicyMatching
WHERE
	PolicyId = @TopupPolicyBusinessId

UPDATE
	Commissions..TDnPolicyMatching
SET
	TopupMasterPolicyId = NULL
WHERE
	PolicyId = @TopupPolicyBusinessId

-------------------------------------------------------
-- Complete
-------------------------------------------------------
COMMIT TRAN
SET XACT_ABORT OFF

PRINT 'Topup successfully unlinked from its master plan :)'