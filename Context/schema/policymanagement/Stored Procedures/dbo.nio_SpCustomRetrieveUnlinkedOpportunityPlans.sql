SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[nio_SpCustomRetrieveUnlinkedOpportunityPlans]   
 @OpportunityId bigint,   
    @TenantId bigint,  
    @PartyIds varchar(8000),  
    @ExcludeMigrated bit  
AS  
  
If object_id('tempdb..#Tally') Is Null  
Begin  
	Select Top 1000 Identity(int,1,1) AS N     
	Into #Tally  
	From master.dbo.SysColumns sc1,          
	master.dbo.SysColumns sc2  
  
	declare @sql nvarchar(255) = N'
	Alter Table #Tally
	Add Constraint PK_Tally_N' + cast(@@spid as nvarchar) + N'
	Primary Key Clustered (N) With FillFactor = 100'
	exec sp_executesql @sql
End  
  
Declare @InternalListOfIds varchar(8000)  
Select @InternalListOfIds = LTrim(RTrim(@PartyIds))  
If Right(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = @InternalListOfIds + ','  
If Left(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = ',' + @InternalListOfIds  
  
-- Declare @EntityIds Table ( EntityId bigint, RightMask int )  
Create Table #EntityIds (EntityId bigint )  
  
Insert Into #EntityIds  
( EntityId )   
Select substring(@InternalListOfIds, N+1, CHARINDEX(',', @InternalListOfIds, N+1) -N -1)     
FROM #Tally    
WHERE N < LEN(@InternalListOfIds)  
 AND SUBSTRING(@InternalListOfIds, N, 1) = ','  
  
SELECT  
 PB.PolicyBusinessId AS PolicyBusinessId,   
    PolicyManagement.dbo.FnRetrievePlanOwnerList(PB.PolicyDetailId,PB.PolicyBusinessId) AS OwnerList,  
 PB.SequentialRef AS SequentialRef,    
 RPPC.CorporateName AS ProviderName,   
 PT.PlanTypeName AS PlanTypeName,   
 PT.PlanTypeName AS PlanSubTypeName,  
 ISNULL(PB.PolicyNumber,'') AS PolicyNumber,  
 TS.[Name] AS Status  
FROM   
    PolicyManagement..TPolicyBusiness PB   
    JOIN PolicyManagement..TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId  
    JOIN PolicyManagement..TPolicyOwner PO ON PO.PolicyDetailId = PD.PolicyDetailId      
    LEFT JOIN PolicyManagement..TAdditionalOwner AO ON AO.PolicyBusinessId = PB.PolicyBusinessId     
    JOIN PolicyManagement..TPlanDescription PDesc ON PD.PlanDescriptionId = PDesc.PlanDescriptionId  
    JOIN PolicyManagement..TRefProdProvider RPP ON PDesc.RefProdProviderId = RPP.RefProdProviderId  
    JOIN CRM..TCRMContact RPPC ON RPP.CRMCOntactId = RPPC.CRMContactId    
    JOIN PolicyManagement..TRefPlanType2ProdSubType P2P ON PDesc.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId  
    JOIN PolicyManagement..TRefPlanType PT ON P2P.RefPlanTypeId = PT.RefPlanTypeId  
    JOIN PolicyManagement..TStatusHistory SH ON PB.PolicyBusinessId = SH.PolicyBusinessId AND SH.CurrentStatusFG = 1  
    JOIN PolicyManagement..TStatus TS ON SH.StatusId = TS.StatusId and TS.IntelligentOfficeStatusType not like 'Deleted'  
 -- BAU-711 - Make sure that only unlinked plans as displayed. Removed the O.OpportunityId = @OpportunityId part of this.  
    LEFT JOIN CRM..TOpportunityPolicyBusiness O ON O.PolicyBusinessId = PB.PolicyBusinessId --AND O.OpportunityId = @OpportunityId   
    JOIN PolicyManagement..TPolicyBusinessExt PE ON PE.PolicyBusinessId = PB.PolicyBusinessId  
    JOIN #EntityIds E on E.EntityId = PO.CRMContactId  
    LEFT JOIN #EntityIds EA on EA.EntityId = AO.CRMContactId  
WHERE     
    PB.IndigoClientId = @TenantId -- tenant  
 AND O.POlicyBusinessId is null -- To make sure that it's not linked.  
    AND ((@ExcludeMigrated = 1 AND PE.MigrationRef IS NULL) -- exclude migrated plans    
        OR (@ExcludeMigrated = 0)) -- include all kind of plans.  
      
--AND (PO.CRMContactId IN (select EntityId from #EntityIds) OR AO.CRMContactId IN  (select EntityId from #EntityIds))  
--exec FnRetrievePlanOwnerList(1,1)  
  
--select * from TPolicyBusinessExt where MigrationRef IS NULL  
GO
