SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateDNPolicyMatchingByPolicyId]  
	@PolicyBusinessId bigint,
	@StampUser varchar(255)
AS
-- Exit if records already exist for this plan.
IF EXISTS (SELECT 1 FROM Commissions.dbo.TDNPolicyMatching WHERE PolicyId = @PolicyBusinessId)
	RETURN;	        

-- Add DN records for the policy business record (logic is taken from overnight DN fix).
INSERT INTO Commissions.dbo.TDNPolicyMatching (
	IndClientId, PolicyId, PolicyNo, PolicyRef, ExpCommAmount,         
	RefProdProviderId, ProviderName, RefComTypeId, RefComTypeName, PractitionerId,         
	PractUserId, PractName, ClientId, ClientFirstName, ClientLastName, PreSubmissionFG, StatusId,         
	StatusDate, SubmittedDate, ConcurrencyId, GroupId, RefPlanType2ProdSubTypeId, BandingTemplateId)        
SELECT DISTINCT 
	tpb.IndigoClientId , tpb.PolicyBusinessId , tpb.PolicyNumber, tpb.SequentialRef,  
	CASE tpec.ExpectedCommissionType  
		WHEN 0 then  tpec.ExpectedAmount  
		Else 0  
	end as ExpectedCommissionType,  
	tpd.RefProdProviderId, tcc.corporatename, tpec.RefCommissionTypeId, tct.CommissionTypeName, tpb.PractitionerId,        
	tu.UserId, tcc2.Firstname + ' ' + tcc2.Lastname, tcc3.crmcontactid, tcc3.Firstname,   
	Case When IsNull(tcc3.LastName,'') <>'' Then tcc3.LastName Else tcc3.CorporateName End,
	0, tsh.StatusId ,        
	tsh.ChangedToDate, tsh.ChangedToDate, 1, PolicyManagement.dbo.FnGetLegalEntityForAdviser(tpb.PractitionerId) ,  
	tpd.RefPlanType2ProdSubTypeId, tpbX.BandingTemplateId  
FROM 
	PolicyManagement..TPlanDescription tpd        
	JOIN PolicyManagement..TPolicyDetail tpdl  On tpdl.PlanDescriptionId = tpd.PlanDescriptionId        
	JOIN PolicyManagement..TPolicyBusiness tpb On tpb.PolicyDetailId = tpdl.PolicyDetailId     
	JOIN Policymanagement.dbo.TPolicyBusinessExt tpbX On tpb.policybusinessid = tpbX.policybusinessid    
	LEFT JOIN PolicyManagement..TPolicyExpectedCommission tpec  On tpec.policybusinessid = tpb.policybusinessid  
		And (tpec.ExpectedCommissionType is null or tpec.ExpectedCommissionType = 0)  
	JOIN PolicyManagement..TRefProdProvider tpp On tpp.RefProdProviderId = tpd.RefProdProviderId        
	JOIN CRM..TCRMContact tcc On tcc.crmcontactid = tpp.crmcontactid        
	LEFT JOIN PolicyManagement..TRefCommissionType tct On tct.RefCommissionTypeId = tpec.RefCommissionTypeId        
	JOIN CRM..TPractitioner ctp On ctp.PractitionerId = tpb.PractitionerId        
	JOIN CRM..TCRMContact tcc2 On tcc2.CRMContactId = ctp.CRMContactId        
	JOIN Administration..TUser tu On tu.CRMContactId = tcc2.CRMContactId         
	JOIN PolicyManagement..TPolicyOwner tpo On tpo.PolicyDetailId = tpdl.PolicyDetailId        
	JOIN CRM..TCRMContact tcc3 On tcc3.crmcontactid = tpo.crmcontactid        
	JOIN PolicyManagement..TStatusHistory tsh On tsh.PolicyBusinessId = tpb.PolicyBusinessId  
	JOIN PolicyManagement..TStatus ts on ts.StatusID = tsh.StatusId  
WHERE
	TPB.PolicyBusinessId = @PolicyBusinessId
	AND tsh.CurrentStatusFG = 1 
	AND ts.IntelligentOfficeStatusType IN ('Submitted to Provider','In force', /*'NTU', */  'Off Risk')
    
-- Add Audit records.  
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
		DnPolicyMatchingId, 'C', GetDate(), @StampUser
FROM Commissions.dbo.TDNPolicyMatching        
WHERE PolicyId = @PolicyBusinessId
GO
