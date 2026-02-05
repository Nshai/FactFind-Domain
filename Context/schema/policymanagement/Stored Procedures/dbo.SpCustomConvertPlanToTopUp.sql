SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomConvertPlanToTopUp]
	@MasterPolicyBusinessId bigint,
	@PolicyBusinessId bigint,
	@PolicyNumberAction tinyint, -- @PolicyNumberAction: 0 = none, 1 = inherit from master, 2 = remove
	@StampUser bigint
AS
DECLARE @MasterPolicyDetailId bigint, @PolicyNumber varchar(50)

SELECT @MasterPolicyDetailId = PolicyDetailId, @PolicyNumber = PolicyNumber
FROM TPolicyBusiness
WHERE PolicyBusinessId = @MasterPolicyBusinessId

IF @PolicyNumberAction = 0 
	SET @PolicyNumber = (SELECT PolicyNumber FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)

IF @PolicyNumberAction = 2
	SET @PolicyNumber = NULL

-- audit the current policy business record
EXEC SpNAuditPolicyBusiness @StampUser, @PolicyBusinessId, 'U'

-- switch the policydetailid to the master
-- and update the TopupMasterPolicyBusinessId
UPDATE TPolicyBusiness
SET 
	TopupMasterPolicyBusinessId = @MasterPolicyBusinessId,
	PolicyDetailId = @MasterPolicyDetailId,
	PolicyNumber = @PolicyNumber
WHERE 
	PolicyBusinessId = @PolicyBusinessId

-- We also need to update the TopupMasterPolicyBusinessId
-- in Commissions..TDNPolicyMatching
INSERT INTO Commissions..TDnPolicyMatchingAudit (
	IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, RefProdProviderId, ProviderName, 
	BandingTemplateId, RefComTypeId, RefComTypeName, PractitionerId, PractUserId, PractName, ClientId, 
	ClientFirstName, ClientLastName, PreSubmissionFG, StatusId, StatusDate, SubmittedDate, RefPlanType2ProdSubTypeId, 
	GroupId, ConcurrencyId, DnPolicyMatchingId, StampAction, StampDateTime, StampUser, TopupMasterPolicyId)
SELECT
	IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, RefProdProviderId, ProviderName, 
	BandingTemplateId, RefComTypeId, RefComTypeName, PractitionerId, PractUserId, PractName, ClientId, 
	ClientFirstName, ClientLastName, PreSubmissionFG, StatusId, StatusDate, SubmittedDate, RefPlanType2ProdSubTypeId, 
	GroupId, ConcurrencyId, DnPolicyMatchingId, 'U', GETDATE(), @StampUser, TopupMasterPolicyId
FROM
	Commissions..TDnPolicyMatching
WHERE
	PolicyId = @PolicyBusinessId

UPDATE Commissions..TDnPolicyMatching
SET	
	PolicyNo = @PolicyNumber,
	TopupMasterPolicyId = @MasterPolicyBusinessId
WHERE
	PolicyId = @PolicyBusinessId
GO
