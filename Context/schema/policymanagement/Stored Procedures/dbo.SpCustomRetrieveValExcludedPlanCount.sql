SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomRetrieveValExcludedPlanCount] as

if (select object_id('tempdb..#Providers')) is not null
       drop table #Providers
set transaction isolation level read uncommitted

       
create table #Providers (RefProdProvider bigint)

insert into #Providers (RefProdProvider)
select distinct case when l.RefProdProviderId Is null then x.RefProdProviderId else l.MappedRefProdProviderId end as refProdProvider
    from TValExcludedPlan x 
  left join TValLookUp l on x.RefProdProviderId = l.RefProdProviderId
SELECT
	1 AS TAG,
	NULL AS PARENT,
	pr.CRMContactId AS [ValExcludedPlan!1!PortalCRMContactId],
	UserId AS [ValExcludedPlan!1!UserId],
	Identifier AS [ValExcludedPlan!1!Identifier],
	FirstName + ' ' + LastName AS [ValExcludedPlan!1!Name],
	Email AS [ValExcludedPlan!1!Email],
	SUM(CASE WHEN exc.ExcludedByUserId IS NOT NULL THEN 1 ELSE 0 END) AS [ValExcludedPlan!1!TotalManualExcludedPlanCount],
	SUM(CASE WHEN ExcludedByUserId IS NULL THEN 1 ELSE 0 END) AS [ValExcludedPlan!1!TotalSystemExcludedPlanCount],
	SUM(CASE WHEN ExcludedByUserId IS NOT NULL AND EmailAlertSent = 0 THEN 1 ELSE 0 END) AS [ValExcludedPlan!1!NewManualExcludedPlanCount],
	SUM(CASE WHEN ExcludedByUserId IS NULL AND EmailAlertSent = 0 THEN 1 ELSE 0 END) AS [ValExcludedPlan!1!NewSystemExcludedPlanCount]
FROM 
	TValExcludedPlan exc 
	inner join TPolicyBusiness pb ON exc.policybusinessid = pb.policybusinessid
	inner join #Providers l on l.RefProdProvider = exc.RefProdProviderId 
	inner join crm..TPractitioner pr on pr.PractitionerId = pb.PractitionerId
	INNER JOIN Administration..TUser u ON u.CRMContactId = pr.CRMContactId
	INNER JOIN CRM..TCrmContact crm ON crm.CRMContactId = u.CRMCOntactId
GROUP BY
	pr.CRMContactId,
	UserId,
	Identifier,
	FirstName + ' ' + LastName,
	Email
HAVING
	SUM(CASE WHEN EmailAlertSent = 0 THEN 1 ELSE 0 END) > 0

for xml explicit

GO
