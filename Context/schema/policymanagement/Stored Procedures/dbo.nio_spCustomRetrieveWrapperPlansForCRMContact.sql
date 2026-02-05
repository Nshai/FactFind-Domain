SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spCustomRetrieveWrapperPlansForCRMContact]   
	@CRMContactId bigint,
	@ProviderId bigint = 0,
	@RefPlanTypeId bigint = 0,
	@PolicyBusinessId bigint
AS
SELECT distinct
    T3.PolicyBusinessId AS PlanId,    
	ISNULL(T3.SequentialRef,'') + ': '+ ISNULL(T8.PlanTypeName, '') 
    +' (' + ISNULL(T3.PolicyNumber,'') + ')' AS WrapDisplay,
	T3.PolicyNumber AS PolicyNumber, 
    T5.Name AS StatusName, 
    T8.RefPlanTypeId,
    T8.PlanTypeName, 
	T8.IsWrapperFg, 	
	case when T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1 
		then 1
		else 0
	end as [Plan!1!IsWrapWrapper], 
	case when T8.PlanTypeName <> 'wrap' and T8.IsWrapperFg = 1 
		then 1
		else 0
	end as IsNonWrapWrapper,
	T9.RefProdProviderId AS ProviderId,
    T10.CorporateName AS ProviderName, 
    T3.SequentialRef AS SequentialRef,
	T13.FirstName + ' ' + T13.LastName AS AdviserFullName
  FROM TPolicyOwner T2
  INNER JOIN TPolicyDetail T1 ON T1.PolicyDetailId = T2.PolicyDetailId 
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId AND T3.PolicyBusinessId!=@PolicyBusinessId --don't allow a wrapper to be added to itself
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType not in ('deleted','NTU','Rejected','off risk','out of force')
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId 
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId 
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId
  INNER JOIN (SELECT A.PolicyDetailId,
	Min(PolicyBusinessId) AS PolicyBusinessId 
      	From TPolicyBusiness A
	JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId
	JOIN TPolicyOwner C ON B.PolicyDetailId=C.PolicyDetailId
	WHERE C.CRMContactId=@CRMContactId 
      	Group By A.PolicyDetailId) AS TPB 
  ON	TPB.PolicyDetailId = T1.PolicyDetailId	
  left join TWrapperProvider wp on T9.RefProdProviderId = wp.RefProdProviderId
  left join TWrapperPlanType wpt on wpt.wrapperproviderid = wp.wrapperproviderid
  left JOIN TRefPlanType2ProdSubType T14 ON T14.RefPlanType2ProdSubTypeId = wpt.RefPlanType2ProdSubTypeId 
  WHERE T2.CRMContactId=@CRMContactId 
	--if refplan type id is supplied it must match a plan in a wrapper
	AND ((@RefPlanTypeId = 0) or (@RefPlanTypeId > 0 and @RefPlanTypeId = T14.RefPlanTypeId))
	--if a provider is supplied then it should match a wrapper provider or the wrapper providers allow other providers plans
    AND (
		((@providerId = 0) or (@providerid > 0 and @providerId = wp.RefProdProviderId))
		Or
		(
			(WrapAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'wrap' and T8.IsWrapperFg = 1 )
			 or 
			(SippAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'sipp' and T8.IsWrapperFg = 1)
			or 
			(SsasAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'ssas' and T8.IsWrapperFg = 1)
			or 
			(OffshoreBondAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Offshore Bond' and T8.IsWrapperFg = 1)
			or 
			(GroupSippAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Group SIPP' and T8.IsWrapperFg = 1)
			or 
			(FamilySippAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Family SIPP' and T8.IsWrapperFg = 1)			
			or 
			(QropsAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'QROPS' and T8.IsWrapperFg = 1)
			or 
			(RopsAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'ROPS' and T8.IsWrapperFg = 1)
			or 
			(SuperAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Super' and T8.IsWrapperFg = 1)
			or 
			(JuniorSIPPAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Junior SIPP' and T8.IsWrapperFg = 1)
			or
			(QnupsAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'QNUPS' and T8.IsWrapperFg = 1)
			or
			(WrapInvestmentAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Wrap (Investment)' and T8.IsWrapperFg = 1)
			or
			(PersonalPensionAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Personal Pension Plan' and T8.IsWrapperFg = 1)
			or
			(OpenAnnuityAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Open Annuity' and T8.IsWrapperFg = 1)
			or
			(IncomeDrawdownAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Income Drawdown' and T8.IsWrapperFg = 1)
			or
			(PhasedRetirementAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Phased Retirement' and T8.IsWrapperFg = 1)
			or
			(InvestmentBondAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Insurance / Investment Bond' and T8.IsWrapperFg = 1)
			or
			(PensionAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Pension' and T8.IsWrapperFg = 1)
			or
			(SuperWrapAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Super (Wrap)' and T8.IsWrapperFg = 1)
			or
			(SelfManagedSuperFundAllowOtherProvidersFg = 1 and T8.PlanTypeName = 'Self Managed Super Fund' and T8.IsWrapperFg = 1)
		)
	 )
    AND T8.IsWrapperFg = 1
GO
