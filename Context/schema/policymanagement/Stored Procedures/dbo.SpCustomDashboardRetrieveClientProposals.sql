USE policymanagement
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date Modifier Issue Description
---- --------- ------- -------------
20191022 Nick Fairway IP-63571 Performance issue. Check for existence on a subset before getting data as the slowest performance is where there is no data to return
20240711 Nick Fairway DEF-16943 Perfromance issue. Reduce the risk of bad parameter sniffing by assisting the optimiser in picking a plan

*/
CREATE or alter PROCEDURE [dbo].SpCustomDashboardRetrieveClientProposals
@UserId int, --not referened
@cid int

AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF EXISTS( -- check for existence as a this is faster than running the full statement below where there are no rows to return. Approx 1/3 duration of full set of joins below
    SELECT 1
    FROM        dbo.TPolicyOwner        tpo
    INNER JOIN  dbo.TPolicyDetail       pd 
    ON  pd.PolicyDetailId   = tpo.PolicyDetailId
    AND tpo.CRMContactId    = @cid
    INNER JOIN  dbo.TPolicyBusiness     tpb
    ON tpb.PolicyDetailId   = pd.PolicyDetailId
    INNER JOIN  dbo.TStatusHistory      sh 
    ON  sh.PolicyBUsinessId = tpb.PolicyBusinessId
    INNER JOIN TStatus s 
    ON  s.StatusId          = sh.StatusId
    AND s.intelligentOfficeStatusType NOT IN ('NTU', 'In Force', 'Deleted', 'Off Risk', 'Paid Up')
)
BEGIN
    -- Encourage the optimiser to do things in the right order using an intermediate temp table
   WITH CTE_ForceOrder AS (
        SELECT pd.PlanDescriptionId
        , tpo.CRMContactId, tpo.PolicyDetailId
        , tpd.RefPlanType2ProdSubTypeId, tpd.RefProdProviderId
        , rpt2pst.RefPlanTypeId
        , rpt.PlanTypeName
        , c.CorporateName
        , tpb.PolicyBusinessId, tpb.SequentialRef , tpb.SequentialRefLegacy
        FROM dbo.TPolicyOwner tpo 
        JOIN dbo.TPolicyDetail pd                   ON pd.PolicyDetailId = tpo.PolicyDetailId
        JOIN dbo.TPlanDescription tpd               ON pd.PlanDescriptionId = tpd.PlanDescriptionId
        JOIN dbo.TRefPlanType2ProdSubType rpt2pst   ON rpt2pst.RefPlanType2ProdSubTypeId = tpd.RefPlanType2ProdSubTypeId
        JOIN dbo.TRefPlanType rpt                   ON rpt.RefPlantypeId = rpt2pst.RefPlanTypeId
        JOIN TRefProdProvider rpp                   ON rpp.RefProdProviderId = tpd.RefProdProviderId
        JOIN CRM..TCRMContact c                     ON rpp.CRMContactId = c.CRMContactId
        JOIN dbo.TPolicyBusiness tpb                ON tpb.PolicyDetailId = pd.PolicyDetailId
        WHERE tpo.CRMContactId = @cid
   )
    SELECT *
    INTO #CTE_ForceOrder
    FROM CTE_ForceOrder;

    WITH
    CTE_StatusHistory AS (
        SELECT tpb.*, sh.ChangedToDate, sh.StatusId
        FROM #CTE_ForceOrder tpb
        JOIN dbo.TStatusHistory sh ON sh.PolicyBUsinessId = tpb.PolicyBusinessId
        WHERE sh.CurrentStatusFg = 1
    ),
    CTE_Status AS (
        SELECT sh.*, s.name
        FROM CTE_StatusHistory sh
        JOIN dbo.TStatus s ON s.StatusId = sh.StatusId
        WHERE s.intelligentOfficeStatusType NOT IN ('NTU', 'In Force', 'Deleted', 'Off Risk', 'Paid Up')
    )
    SELECT TOP 5
        s.SequentialRef,
        s.PolicyBusinessId as [PolicyBusinessId],
        s.PlanTypeName as [PlanTypeName],
        s.Name as [PlanStatusName],
        s.ChangedToDate as [StatusDate],
        s.CorporateName as [ProviderName],
        s.CRMContactId as [CrmContactId]
    FROM    CTE_Status s
    ORDER BY s.PolicyBusinessId asc
END
ELSE -- there are no rows so select none (keep the same shape and types on the output in case the front end is expecting an empty recordset)
     SELECT TOP 0
        tpb.SequentialRef,
        tpb.PolicyBusinessId as [PolicyBusinessId],
        rpt.PlanTypeName as [PlanTypeName],
        s.Name as [PlanStatusName],
        sh.ChangedToDate as [StatusDate],
        c.CorporateName as [ProviderName],
        tpo.CRMContactId as [CrmContactId]
    FROM 
               TPolicyBusiness tpb
    INNER JOIN TPolicyDetail pd ON tpb.PolicyDetailId = pd.PolicyDetailId
    INNER JOIN TPolicyOwner tpo ON pd.PolicyDetailId = tpo.PolicyDetailId
    INNER JOIN TPlanDescription tpd ON pd.PlanDescriptionId = tpd.PlanDescriptionId
    INNER JOIN TRefPlanType2ProdSubType rpt2pst ON rpt2pst.RefPlanType2ProdSubTypeId = tpd.RefPlanType2ProdSubTypeId
    INNER JOIN TRefPlanType rpt ON rpt.RefPlantypeId = rpt2pst.RefPlanTypeId
    INNER JOIN TRefProdProvider rpp ON rpp.RefProdProviderId = tpd.RefProdProviderId
    INNER JOIN TStatusHistory sh ON sh.PolicyBUsinessId = tpb.PolicyBusinessId
    INNER JOIN TStatus s ON s.StatusId = sh.StatusId
    INNER JOIN CRM..TCRMContact c ON rpp.CRMContactId = c.CRMContactId
    WHERE 1=0
GO