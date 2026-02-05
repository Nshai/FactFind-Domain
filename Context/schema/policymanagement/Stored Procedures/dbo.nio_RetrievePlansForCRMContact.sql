
/****** Object:  StoredProcedure [dbo].[nio_RetrievePlansForCRMContact]    Script Date: 27/11/2015 14:29:20 ******/

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier            Issue           Description
----        ---------           -------         -------------
20231213    Pavel Mankialevich  PA-14816        Add new Filter option on Accounts grid
*/
CREATE PROCEDURE [dbo].[nio_RetrievePlansForCRMContact]
   @CRMContactId int,      
   @TenantId int,
   @NotOnRiskFG bit =0,      
   @IsPdfOutput bit=0,      
   @IsWrapFG bit=0,  
   @IsSippFG bit=0,
   @IsTopUp bit=0,
   @IsInForce bit=0,
   @IsUnderAgency bit=0,
   @IsUnderAgencyAndIsInForce bit=0,
   @IsInForceOnly bit=0
AS      

set transaction isolation level read uncommitted

if (select object_id('tempdb..#Plans')) is not null
       drop table #Plans
       
if (select object_id('tempdb..#MasterTopUpPlans')) is not null
       drop table #MasterTopUpPlans


SET NOCOUNT ON



/*lets create some worker tables*/

/* Master Plan Table for this Contact*/
create table #Plans (
      PolicyBusinessId bigint, 
      PolicyDetailId bigint, 
      IsTopUp bit, 
      IsMasterPolicy bit, 
      [Status] varchar(255), 
      [IntelligentOfficeStatus] varchar(255), 
      [ChangedToDate] datetime,
      RefProdProviderId bigint, 
      ProviderName varchar(255),
      PlanTypeName varchar(255),
      ProdSubTypeName varchar(255),
      IsWrapperFg bit,
      [IsMortgage] bit,
      RefPlanType2ProdSubTypeId bigint,
      RefPlanTypeId bigint,
      RefPlanTypeName varchar(255),
      AdditionalOwnersFg bit,
      SchemeOwnerCRMContactId bigint,
	  IsPipelineStatus bit,
	  SequentialRefId int,
	  IsJointlyOwned bit
	  )

insert into #Plans(PolicyBusinessId, PolicyDetailId, SequentialRefId)
Select distinct A.PolicyBusinessId, A.PolicyDetailId, CAST(REPLACE(A.SequentialRef, 'IOB', '') as int)
From
(
	Select A.PolicyBusinessId, A.PolicyDetailId, A.SequentialRef
	from TPolicyBusiness A
	inner join TPolicyOwner B on a.PolicyDetailId=b.PolicyDetailId
	where b.CRMContactId = @CRMContactId and A.IndigoClientId=@TenantId
	union all
	Select A.PolicyBusinessId, A.PolicyDetailId, A.SequentialRef 
	from TPolicyBusiness A
	Join TAdditionalOwner C on c.PolicyBusinessId=A.PolicyBusinessId
	--Join policymanagement..TMember D on d.PolicyBusinessId=A.PolicyBusinessId
	where C.CRMContactId = @CRMContactId and A.IndigoClientId=@TenantId
) as A

-- update current status
Update A Set A.Status=ST.Name, A.[IntelligentOfficeStatus]=ST.IntelligentOfficeStatusType, A.[ChangedToDate]=SH.ChangedToDate, A.IsPipelineStatus=ST.IsPipelineStatus
from #Plans A
inner join TStatusHistory SH ON A.PolicyBusinessId = SH.PolicyBusinessId AND SH.CurrentStatusFG = 1      
inner join TStatus ST ON SH.StatusId = ST.StatusId
Where ST.IndigoClientId=@TenantId

Delete from #Plans where [IntelligentOfficeStatus]='Deleted'

create table #MasterTopUpPlans (PolicyBusinessId bigint, PolicyDetailId bigint)
insert into #MasterTopUpPlans (PolicyBusinessId, PolicyDetailId)
select min(PolicyBusinessId), PolicyDetailId from #Plans
group by policydetailId
having count(PolicydetailId)>1

-- update my master plans flag
Update A set IsMasterPolicy=1 from #Plans A
inner join #MasterTopUpPlans B on b.PolicyBusinessId=a.PolicyBusinessId

-- update my top up plans
Update A set IsTopUp=1 from #Plans A
inner join #MasterTopUpPlans B on A.PolicyDetailId=b.PolicyDetailId
where isnull(a.IsMasterPolicy,0)=0

-- lets get the provider and plan type data
update A Set A.PlanTypeName=T8.PlanTypeName + ISNULL(' (' + T11.ProdSubTypeName + ')',''), A.ProdSubTypeName=T11.ProdSubTypeName, A.ProviderName=T10.CorporateName, A.RefProdProviderId=T9.RefProdProviderId,
A.IsMortgage=ISNULL(RPG.IsMortgage,0), A.RefPlanType2ProdSubTypeId=T7.RefPlanType2ProdSubTypeId, A.RefPlanTypeId=T8.RefPlanTypeId, A.IsWrapperFg= T8.IsWrapperFg,
A.RefPlanTypeName = T8.PlanTypeName, A.AdditionalOwnersFg=T8.AdditionalOwnersFg, A.SchemeOwnerCRMContactId=T6.SchemeOwnerCRMContactId
from #Plans a
inner join TPolicyDetail T1 on T1.policydetailId=a.PolicyDetailId
inner join TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId       
inner join TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId       
left join TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId      
inner join TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId
left join TRefPlanTypeGrouping RPG ON T8.RefPlanTypeId=RPG.RefPlanTypeId       
inner join TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId  
INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId

--Update joint owner flag
update A set A.IsJointlyOwned = case 
	when agg.ownerCount > 1 then 1
	else 0 
	end
from #Plans a
inner join (select a.PolicyBusinessId, count(*) as ownerCount
from #Plans a
inner join TPolicyDetail T1 on T1.PolicyDetailId=a.PolicyDetailId
inner join TPolicyOwner T2 on T2.PolicyDetailId=T1.PolicyDetailId
group by a.PolicyBusinessId) as agg
on agg.PolicyBusinessId = a.PolicyBusinessId


--Return result
SELECT distinct
	   T3.PolicyBusinessId AS [PlanId],
       REPLICATE ('0' , 20-len(100000000000 - Plans.SequentialRefId)) + convert(varchar(20), 100000000000 - Plans.SequentialRefId) AS [SortId], --used to sort the data
       T3.PolicyNumber AS [Number],       
   T3.PractitionerId AS [SellingPractitionerId],       
       Plans.Status AS [Status],
       Plans.RefPlanType2ProdSubTypeId AS ProductTypeId,       
       Plans.RefPlanTypeId AS [RefPlanTypeId],      
       Plans.PlanTypeName,      
       Plans.IsWrapperFg AS [IsWrapperFg],       
       ISNULL(wrapProv.WrapAllowOtherProvidersFg, 0)  AS [WrapAllowOtherProvidersFg],        
       ISNULL(wrapProv.SippAllowOtherProvidersFg, 0)  AS [SippAllowOtherProvidersFg],        
       CASE 
              WHEN plans.PlanTypeName = 'wrap' and Plans.IsWrapperFg = 1 THEN 1
              ELSE 0      
       end AS [IsWrapWrapper],       
       CASE 
              WHEN plans.PlanTypeName <> 'wrap' and Plans.IsWrapperFg = 1 THEN 1
       ELSE 0
       end AS [IsNonWrapWrapper],      
       Plans.AdditionalOwnersFg AS [AdditionalOwnersFg],       
       Plans.RefProdProviderId AS [ProviderId],      
       Plans.ProviderName AS [ProviderName],       
       T3.PolicyBusinessId AS [PolicyBusinessId],       
       T1.PolicyDetailId AS [PolicyDetailId] ,      
       --Top up child flag.
       CASE 
              WHEN (T3.PolicyBusinessId = Plans.PolicyBusinessId  AND Plans.IsTopUp=1) THEN 1 
              ELSE 0 
       END AS [IsTopUp],
       --Top up parent Flag
       CASE 
              WHEN (T3.PolicyBusinessId = Plans.PolicyBusinessId AND Plans.IsMasterPolicy=1) THEN 1 
              ELSE 0 
       END AS [IsTopUpParent],       
       ISNULL(Plans.ProdSubTypeName,'') AS [ProdSubTypeName],      
       PLans.[ChangedToDate]  AS [ChangedToDate],      
       CASE 
              WHEN ISNULL(Plans.SchemeOwnerCRMContactId,0) = 0 THEN 0 
              ELSE 1 
       END AS [IsScheme],      
       CASE 
              WHEN Adt.IntelligentOfficeAdviceType='Pre-Existing' THEN 1 
              ELSE 0 
       END AS [ExistingPolicy],         
       T3.SequentialRef AS [SequentialRef],      
       ISNULL(wrapolbus.SequentialRef, '') AS [LinkedToSequentialRef],      
       ISNULL(wrapolbus.PolicyBusinessId, '0') AS [LinkedToPolicyBusinessId],       
       T13.FirstName + ' ' + T13.LastName AS [AdviserFullName],      
       CASE      
              WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=0       
                     THEN ISNULL(T3.SequentialRef,'') + ': ' + ISNULL(Plans.ProviderName,'') + ' - ' + ISNULL(Plans.PlanTypeName,'')      
              WHEN (ISNULL(T3.PolicyNumber,'0') = '0' OR T3.PolicyNumber = NULL OR T3.PolicyNumber = ' ' ) AND @IsPdfOutput=1      
                     THEN ISNULL(Plans.ProviderName,'') + ' - ' + ISNULL(Plans.PlanTypeName,'')      
              WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=0      
                     THEN ISNULL(T3.SequentialRef,'') + ' : ' + ISNULL(Plans.ProviderName,'') + ' - ' + ISNULL(Plans.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'      
              WHEN ISNULL(T3.PolicyNumber,'0') <> '0' AND T3.PolicyNumber IS NOT NULL AND @IsPdfOutput=1      
                     THEN ISNULL(Plans.ProviderName,'') + ' - ' + ISNULL(Plans.PlanTypeName,'') + ' (' + T3.PolicyNumber + ')'      
       END AS [LongName],
       Plans.IsMortgage AS [IsMortgage],
       @CRMContactId As [CRMContactId], 
       NULL As AccountPartyId,
       T3.PolicyStartDate As [PolicyStartDate],
	   Plans.IsJointlyOwned as [IsJointlyOwned],
	   T3.ProductName as [ProductName]

  FROM #Plans Plans        
  INNER JOIN TPolicyBusiness T3 ON Plans.PolicyBusinessId = T3.PolicyBusinessId           
  INNER JOIN TPolicyDetail T1 ON T3.PolicyDetailId = T1.PolicyDetailId
  INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T3.PractitionerId      
  INNER JOIN [CRM]..TCRMContact T13 ON T13.CRMContactId = T12.CRMContactId      
  INNER JOIN TAdviceType AdT on T3.AdviceTypeId=AdT.AdviceTypeId      
  LEFT JOIN TWrapperProvider wrapProv ON Plans.RefProdProviderId = wrapProv.RefProdProviderId      
  --added for sipp  
  and wrapProv.RefPlanTypeId = Plans.RefPlanTypeId   
 LEFT JOIN TWrapperPolicyBusiness wrapPol ON T3.PolicyBusinessId = wrapPol.PolicyBusinessId      
 LEFT JOIN TPolicyBusiness wrapolbus ON wrapPol.ParentPolicyBusinessId = wrapolbus.PolicyBusinessId
 LEFT JOIN TPolicyBusinessExt T4 ON T4.PolicyBusinessId = T3.PolicyBusinessId
 WHERE  @CRMContactId>0  

and ((@IsWrapFg = 0) or (@IsWrapFg = 1 and Plans.PlanTypeName = 'wrap'))  -- need better way
and ((@IsSippFg = 0) or (@IsSippFg = 1 and Plans.PlanTypeName = 'sipp')) -- need better way
and ((@IsTopUp = 0 and (ISNULL(Plans.IsTopUp,0)=0))  or (@IsTopUp  = 1 and Plans.IsTopUp=1))  --is this ok?
--Adding condition to fetch all inforce and pipeline plans on the basis of status
and ((@IsInForce = 0) or (@IsInForce = 1 and Plans.IsPipelineStatus = 1))
and ((@IsInForceOnly = 0) or (@IsInForceOnly = 1 and Plans.[IntelligentOfficeStatus] = 'In force'))
and ((@IsUnderAgency = 0) or (@IsUnderAgency = 1 and T4.AgencyStatus IN ('UnderAgency_InformationOnly','UnderAgency_ServicingAgent')))
and ((@IsUnderAgencyAndIsInForce = 0) or (@IsUnderAgencyAndIsInForce = 1 and T4.AgencyStatus IN ('UnderAgency_InformationOnly','UnderAgency_ServicingAgent') and Plans.IsPipelineStatus = 1 ))
       --Defect RDRCHARGE-533: Add check for TenantId
       AND T3.IndigoClientId = @TenantId 

GO


