SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.FnCustomGetProviderName
(
@PolicyBusinessId BIgInt
)

RETURNS Varchar(250)

AS

BEGIN

    DECLARE @ProviderName Varchar(250)
	
	Select @ProviderName = crm.CorporateName from crm..TCRMContact crm 
	Inner Join policymanagement..TRefProdProvider provider ON provider.CRMContactId = crm.CRMContactId
	Inner Join policymanagement..TPlanDescription descrip ON descrip.RefProdProviderId = provider.RefProdProviderId
	Inner Join policymanagement..TPolicyDetail pdetails ON pdetails.PlanDescriptionId = descrip.PlanDescriptionId
	Inner Join policymanagement..TPolicyBusiness policy ON policy.PolicyDetailId = pdetails.PolicyDetailId
	Where policy.PolicyBusinessId = @PolicyBusinessId;  	

    RETURN @ProviderName

END
GO
