SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[SpCustomRetrievePolicyBusinessDetailsForFileCheck]
  @PolicyBusinessId bigint
As

Begin

select 	*
From PolicyManagement..TPolicyBusiness PolicyBusiness 
Inner Join PolicyManagement..TPolicyDetail PolicyDetail on PolicyDetail.PolicyDetailId = PolicyBusiness.PolicyDetailId
-- get practitioner
Inner Join CRM..TPractitioner Practitioner on Practitioner.PractitionerId=PolicyBusiness.PractitionerId
Inner Join CRM..TCRMContact PractitionerCRMContact on PractitionerCRMContact.CRMContactId=Practitioner.CRMContactId
-- get plan type
Inner Join PolicyManagement..TPlanDescription PlanDescription on PolicyDetail.PlanDescriptionId=PlanDescription.PlanDescriptionId
Inner Join PolicyManagement..TRefPlanType2ProdSubType RefPlanType2ProdSubType on PlanDescription.RefPlanType2ProdSubTypeId=RefPlanType2ProdSubType.RefPlanType2ProdSubTypeId
Inner Join PolicyManagement..TRefPlanType PlanType on RefPlanType2ProdSubType.RefPlanTypeId=PlanType.RefPlanTypeId
Where PolicyBusiness.PolicyBusinessId = @PolicyBusinessId

for xml auto

End



GO
