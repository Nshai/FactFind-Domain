SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  



CREATE procedure [dbo].[spNio_CustomRetrieveActionPlansForScenario]          



@FinancialPlanningId bigint,          



@ScenarioId bigint    



    



As    



    



Select distinct actionplanid, ap.financialplanningid, scenarioid, owner1, owner2,    



 RefPlan2ProdSubTypeId, ap.RefPlanTypeId, PercentageAllocation, ap.PolicyBusinessId, TopupParentPolicyBusinessId,       



 case when rpt2.RefPlanType2ProdSubTypeId is not null then           



  case when prodsubtypename is not null then PlanTypeName + ' - ' + prodsubtypename         



  else PlanTypeName end          



 else          



  null end as PlanTypeName,          



 crm1.Firstname + ' ' + crm1.Lastname as Owner1Name,          



 crm2.Firstname + ' ' + crm2.Lastname as Owner2Name,          



 Contribution  ,        



 Withdrawal,        



 --case when pts.section is null then ''     



 -- when  pts.section in ('Final Salary Schemes','Money Purchase Pension Schemes') then 'pension'     



 -- else 'investment' end as agreementType  , 



 '' as  agreementType,    



 IsExecuted,      



 PlanRecommendationCategory,    



 PlanTypeThirdPartyCode,    



 PlanTypeThirdPartyDescription,    



 ProviderName ,   



 SequentialRef as ParentPlanSequentialRef,



 SolutionGroupId,

 

 IsNewProposal,

 fp.RefPlanningTypeId as RefPlanningTypeId   



from TActionPlan ap          



--left join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = ap.RefPlan2ProdSubTypeId           



left join policymanagement..TRefPlanType2ProdSubType rpt2 on ap.RefPlan2ProdSubTypeId = rpt2.RefPlanType2ProdSubTypeId          



left join policymanagement..TRefPlanType rpt on rpt2.RefPlanTypeId = rpt.RefPlanTypeId          



left join policymanagement..TProdSubType pst on rpt2.ProdSubTypeId = pst.ProdSubTypeId          



left join crm..TCRMContact crm1 on owner1 = crm1.crmcontactid          



left join crm..TCRMContact crm2 on owner2 = crm2.crmcontactid    



left JOIN policymanagement..TPolicyBusiness pb on ap.TopupParentPolicyBusinessId = pb.PolicyBusinessId        

Left join factfind..TFinancialPlanning fp on fp.FinancialPlanningId = ap.FinancialPlanningId 

where ap.financialplanningid = @FinancialPlanningId and scenarioid = @scenarioid         



order by ap.PolicyBusinessId desc,actionplanid 




GO
