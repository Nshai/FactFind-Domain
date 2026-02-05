SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomUpdateDNPolicyMatchingStatusByPolicyId] 
  @PolicyId bigint,
  @StatusId bigint
AS

	Insert Into Commissions.dbo.TDNPolicyMatchingAudit
	( DnPolicyMatchingId, IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, 	
	RefProdProviderId, ProviderName, RefComTypeId, RefComTypeName, PractitionerId, 
	PractUserId, PractName, ClientId, ClientFirstName, ClientLastName, PreSubmissionFG, 
	StatusId, StatusDate, SubmittedDate, GroupId, ConcurrencyId, 
	StampAction, StampDateTime, StampUser )
	Select DnPolicyMatchingId, IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount, 	
	RefProdProviderId, ProviderName, RefComTypeId, RefComTypeName, PractitionerId, 
	PractUserId, PractName, ClientId, ClientFirstName, ClientLastName, PreSubmissionFG, 
	StatusId, StatusDate, SubmittedDate, GroupId, ConcurrencyId,
	'U', GetDate(), 0
	From Commissions.dbo.TDNPolicyMatching
	Where PolicyId = @PolicyId

	UPDATE A
	Set StatusId = @StatusId, ConcurrencyId = ConcurrencyId + 1
	From Commissions.dbo.TDNPolicyMatching A
	Where PolicyId = @PolicyId 


GO
