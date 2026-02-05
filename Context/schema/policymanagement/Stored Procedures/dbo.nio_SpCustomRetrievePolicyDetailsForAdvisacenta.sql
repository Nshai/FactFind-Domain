SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomRetrievePolicyDetailsForAdvisacenta]
(
	@CrmContact1 bigint,
	@CrmContact2 bigint,
	@TenantId bigint
	)
AS	 
BEGIN

SELECT policyBusiness.PolicyBusinessId                   as PolicyBusinessId,
       policyBusiness.MaturityDate                       as MaturityDate,
       policyBusiness.PolicyStartDate                    as StartDate,
       policydeta1_.IndigoClientId              as TenantId,
       primaryown4_1_.FirstName                 as OwnerFirstName,
       primaryown4_1_.LastName                  as OwnerLastName,
       productpro9_.Name                        as ProviderName,
       productpro9_.RefProdProviderId           as ProviderId,
       refplantyp11_.PlanTypeName               as PlanTypeName,
       refplantyp11_.RefPlanTypeId              as PlanTypeId,
       productsub14_.ProdSubTypeName            as ProductSubTypeName,
       productsub14_.ProdSubTypeId              as ProductSubTypeId,
       policyBusiness.PolicyNumber                       as PolicyNumber,
       status7_.Name                            as CurrentStatus,
       evalueagre13_.EvalueAgreementClass       as EvalueAgreementClassName,
       evalueagre13_.EvalueAgreementTypeName    as EvalueAgreementTypeName,
       evalueagre13_.EvalueAgreementProductName as EvalueProductName,
       primaryown4_.CRMContactId                as PrimaryOwnerId,
       secowner5_.CRMContactId                  as SecondaryOwnerId
FROM   PolicyManagement.dbo.VPolicyBusiness policyBusiness
       inner join PolicyManagement.dbo.[TPolicyDetail] policydeta1_
         on policyBusiness.PolicyDetailId = policydeta1_.PolicyDetailId
       inner join PolicyManagement.dbo.[VPlanDescription] plandescri8_
         on policydeta1_.PlanDescriptionId = plandescri8_.PlanDescriptionId
       left outer join PolicyManagement.dbo.TRefPlanType2ProdSubType product10_
         on plandescri8_.RefPlanType2ProdSubTypeId = product10_.RefPlanType2ProdSubTypeId
       inner join PolicyManagement.dbo.TRefPlanType refplantyp11_
         on product10_.RefPlanTypeId = refplantyp11_.RefPlanTypeId
       left outer join PolicyManagement.dbo.TProdSubType productsub14_
         on product10_.ProdSubTypeId = productsub14_.ProdSubTypeId
       left outer join PolicyManagement.dbo.TEvalueAgreementToPlanType evalueagre12_
         on product10_.RefPlanType2ProdSubTypeId = evalueagre12_.RefPlanType2ProdSubTypeId
       left outer join PolicyManagement.dbo.TRefEvalueAgreementType evalueagre13_
         on evalueagre12_.RefEvalueAgreementTypeId = evalueagre13_.RefEvalueAgreementTypeId
       left outer join PolicyManagement.dbo.[VProvider] productpro9_
         on plandescri8_.RefProdProviderId = productpro9_.RefProdProviderId
       inner join PolicyManagement.dbo.TPolicyOwner policyprim2_
         on policydeta1_.PolicyDetailId = policyprim2_.PolicyDetailId
            and (policyprim2_.PolicyOwnerId = (SELECT   MIN(Prim.PolicyOwnerId)
                                               FROM     PolicyManagement.dbo.TPolicyOwner Prim
                                               WHERE    Prim.PolicyDetailId = policyprim2_.PolicyDetailId 
											   and (Prim.CRMContactId = @CrmContact1 Or Prim.CRMContactId = @CrmContact2)
                                               GROUP BY Prim.PolicyDetailId))
       inner join CRM.dbo.TCRMContact primaryown4_
         on policyprim2_.CRMContactId = primaryown4_.CRMContactId
       left outer join CRM.dbo.VPerson primaryown4_1_
         on primaryown4_.CRMContactId = primaryown4_1_.CRMContactId
       left outer join CRM.dbo.VTrust primaryown4_2_
         on primaryown4_.CRMContactId = primaryown4_2_.CRMContactId
       left outer join CRM.dbo.VCorporate primaryown4_3_
         on primaryown4_.CRMContactId = primaryown4_3_.CRMContactId
       left outer join PolicyManagement.dbo.TPolicyOwner policyseco3_
         on policydeta1_.PolicyDetailId = policyseco3_.PolicyDetailId
            and (policyseco3_.PolicyOwnerId = (SELECT   MAX(Prim.PolicyOwnerId)
                                               FROM     PolicyManagement.dbo.TPolicyOwner Prim
                                               WHERE    Prim.PolicyDetailId = policyseco3_.PolicyDetailId 
											   and (Prim.CRMContactId = @CrmContact1 Or Prim.CRMContactId = @CrmContact2)
                                               GROUP BY Prim.PolicyDetailId
                                               Having   Count(Prim.PolicyOwnerId) > 1))
       left outer join CRM.dbo.TCRMContact secowner5_
         on policyseco3_.CRMContactId = secowner5_.CRMContactId
       left outer join CRM.dbo.VPerson secowner5_1_
         on secowner5_.CRMContactId = secowner5_1_.CRMContactId
       left outer join CRM.dbo.VTrust secowner5_2_
         on secowner5_.CRMContactId = secowner5_2_.CRMContactId
       left outer join CRM.dbo.VCorporate secowner5_3_
         on secowner5_.CRMContactId = secowner5_3_.CRMContactId
       inner join PolicyManagement.dbo.[VStatusHistory] currentsta6_
         on policyBusiness.PolicyBusinessId = currentsta6_.PolicyBusinessId
            and (currentsta6_.CurrentStatusFG = 1)
       inner join PolicyManagement.dbo.[TStatus] status7_
         on currentsta6_.StatusId = status7_.StatusId
WHERE   policyBusiness.TopupMasterPolicyBusinessId is null/* @p0 */
       and policyBusiness.IndigoClientId = @TenantId /* @p1 */
       and status7_.IntelligentOfficeStatusType in ('In force' /* @p2 */,'Paid Up' /* @p3 */)
       and evalueagre13_.EvalueAgreementClass is not null

END
GO
