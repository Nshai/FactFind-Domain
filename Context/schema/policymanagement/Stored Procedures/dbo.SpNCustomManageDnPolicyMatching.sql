SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomManageDnPolicyMatching]
	@PolicyBusinessId bigint, 
	@StampUser varchar(50)  
AS  
-- Get policy number
DECLARE @PolicyNumber varchar(255)
SELECT @PolicyNumber = PolicyNumber FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId  

-- Audit changes  
INSERT INTO Commissions.dbo.TDnPolicyMatchingAudit
( IndClientId, PolicyId, PolicyNo, PolicyRef, 
		ExpCommAmount, RefProdProviderId, ProviderName, BandingTemplateId, 
		RefComTypeId, RefComTypeName, PractitionerId, PractUserId, 
		PractName, ClientId, ClientFirstName, ClientLastName, 
		PreSubmissionFG, StatusId, StatusDate, SubmittedDate, 
		GroupId, RefPlanType2ProdSubTypeId, ConcurrencyId, TopupMasterPolicyId, 
		DnPolicyMatchingId, StampAction, StampDateTime, StampUser) 
Select IndClientId, PolicyId, PolicyNo, PolicyRef, 
		ExpCommAmount, RefProdProviderId, ProviderName, BandingTemplateId, 
		RefComTypeId, RefComTypeName, PractitionerId, PractUserId, 
		PractName, ClientId, ClientFirstName, ClientLastName, 
		PreSubmissionFG, StatusId, StatusDate, SubmittedDate, 
		GroupId, RefPlanType2ProdSubTypeId, ConcurrencyId, TopupMasterPolicyId, 
		DnPolicyMatchingId, 'U', GetDate(), @StampUser
FROM 
	Commissions.dbo.TDNPolicyMatching        
WHERE 
	PolicyId = @PolicyBusinessId
	AND PolicyNo != @PolicyNumber
  
UPDATE A  
SET 
	PolicyNo = @PolicyNumber,
	ConcurrencyId = ConcurrencyId + 1
FROM 
	Commissions..TDnPolicyMatching A 
WHERE 
	PolicyId = @PolicyBusinessId
	AND PolicyNo != @PolicyNumber
  
GO
