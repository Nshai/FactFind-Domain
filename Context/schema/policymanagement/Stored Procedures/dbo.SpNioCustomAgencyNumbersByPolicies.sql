SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure dbo.SpNioCustomAgencyNumbersByPolicies
	@PolicyBusinessIds  VARCHAR(8000),
	@TenantId bigint
AS

--DECLARE
--  @PolicyBusinessIds  VARCHAR(8000) ='100, 21',
--	@TenantId bigint = 10155

SELECT 
pb.PolicyBusinessId,
ag.AgencyNumber,
ag.RefProdProviderId,
ag.PractitionerId
FROM policymanagement..TPolicyBusiness pb		
JOIN policymanagement.dbo.FnSplit(@PolicyBusinessIds, ',') parslist   
            ON pb.PolicyBusinessId = parslist.Value 	
		JOIN policymanagement..TPolicyDetail pd ON pb.PolicyDetailId = pd.PolicyDetailId		
		JOIN policymanagement..TPlanDescription pds ON pds.PlanDescriptionId = pd.PlanDescriptionId	
		JOIN crm..TAgencyNumber ag ON ag.RefProdProviderId = pds.RefProdProviderId and 
									  ag.PractitionerId = pb.PractitionerId and 
									  pb.AgencyNumber = ag.AgencyNumber	
WHERE pb.IndigoClientId = @TenantId


