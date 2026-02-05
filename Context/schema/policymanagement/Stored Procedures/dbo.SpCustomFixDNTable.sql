USE PolicyManagement
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure dbo.SpCustomFixDNTable
AS          
 
/*  
## VERSION 1.2 ##  
TJB - 28 Oct 2013 - Add Topup Master Policy

## VERSION 1.1 ##  
TJB - 15 Jan 2013 - Make the transaction boundaries smaller

## VERSION 1.0 ##  
TJB - 21 Apr 2010 - First Comments  
 Simplify the way this works to only look at the current status and   
  the transition it used to get there  

PW - 28 July 2011 Including Draft plans that don't have payment records
to be deleted from TDNPolicyMatching and TLUProvBreaks  

MT - 27 Oct 2016 Exclude an plans or status histories that are created AFTER this script starts running
  -Potenantial timing issues can cause statuses/transitions to be recognised incorrectly

NF - IP-81207 - 13 May 2020 Performance improvement to reduce deadlocks

##############  
Notes   
1.   
  
*/  
SET NOCOUNT ON;

--Get Max PB and SH, so as to exclude any items created after this point
DECLARE @MaxPolicyBusinessId INT = (Select Max(PolicyBusinessId) from TPolicyBusiness)

CREATE TABLE #tdnpolicymatching(
	[IndClientId] [int] NOT NULL,
	[PolicyId] [int] NOT NULL,
	[PolicyNo] [varchar](255) NULL,
	[PolicyRef] [varchar](255) NULL,
	[ExpCommAmount] [money] NULL,
	[RefProdProviderId] [int] NOT NULL,
	[ProviderName] [varchar](255) NOT NULL,
	[RefComTypeId] [int] NULL,
	[RefComTypeName] [varchar](255) NULL,
	[PractitionerId] [int] NULL,
	[PractUserId] [int] NULL,
	[PractName] [varchar](255) NULL,
	[ClientId] [int] NOT NULL,
	[ClientFirstName] [varchar](255) NULL,
	[ClientLastName] [varchar](255) NULL,
	[PreSubmissionFG] [tinyint] NOT NULL,
	[StatusId] [int] NULL,
	[StatusDate] [datetime] NOT NULL,
	[SubmittedDate] [datetime] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[RefPlanType2ProdSubTypeId] [int] NULL,
	[BandingTemplateId] [int] NULL,
	[TopupMasterPolicyId] [int] NULL,
    DnPolicyMatchingId int NULL -- updated for the audit table only
) 


 If Object_Id('tempdb..#PolicyBusiness') Is Not Null    
  Drop Table #PolicyBusiness    
 
 Create Table #PolicyBusiness(PolicyBusinessId bigint NOT NULL, Include bit NOT NULL, FromStatusHistoryId bigint NOT NULL, ToStatusHistoryId Bigint NOT NULL)    
    --exec tempdb..sp_help #PolicyBusiness
 -- Find items that went forward through the transition    
Insert Into #PolicyBusiness    
(PolicyBusinessId, Include, FromStatusHistoryId, ToStatusHistoryId)   
Select distinct pb.PolicyBusinessId,     
				Include = lct.AddToCommissionsFg,
				'from' = Max(shFrom.StatusHistoryId), 
				'to' = Max(shTo.StatusHistoryId)    
 from dbo.TPolicyBusiness pb    
 JOIN dbo.TLifeCycle lc ON pb.LifeCycleId = lc.LifeCycleId    
 JOIN dbo.TLifeCycleStep lsFrom ON lsFrom.LifeCycleId = pb.LifeCycleId --  lc.LifeCycleId    
 JOIN dbo.TLifeCycleStep lsTo ON lsTo.LifeCycleId = pb.LifeCycleId --lc.LifeCycleId    
 JOIN dbo.TLifeCycleTransition lct   
 ON lct.LifeCycleStepId = lsFrom.LifeCycleStepId AND lct.ToLifeCycleStepId = lsTo.LifeCycleStepId    
 Join dbo.TStatusHistory shFrom   
 ON pb.PolicyBusinessId = shFrom.PolicyBusinessId And lsFrom.StatusId = shFrom.StatusId    
 Join dbo.TStatusHistory shTo   
 ON pb.PolicyBusinessId = shTo.PolicyBusinessId And lsTo.StatusId = shTo.StatusId   
  And shTo.CurrentStatusFG=1   
 Where 1=1
 And lct.AddToCommissionsFg Is Not Null    
 And shFrom.StatusHistoryId < shTo.StatusHistoryId -- > backwards   -- < forward    
 AND pb.PolicyBusinessId <= @MaxPolicyBusinessId -- avoid Timing issue where items are included in the following queries during the run
 Group By pb.PolicyBusinessId  , lct.AddToCommissionsFg    -- 3:29 min 516831 rows

 UPDATE pb    
 Set pb.Include = 0    
 From #PolicyBusiness pb    
 INNER Join dbo.TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId      
 INNER Join dbo.TStatus s ON sh.StatusId = s.StatusId    
 Where sh.CurrentStatusFg = 1 and s.IntelligentOfficeStatusType = 'Deleted'  -- 5000 rows 1 sec

 ALTER TABLE #PolicyBusiness ADD CONSTRAINT PK_#PolicyBusiness PRIMARY KEY (PolicyBusinessId, ToStatusHistoryId, Include)

Declare  @StartId bigint, @Step bigint
Select @StartId = 1, @Step = 500000

While(@MaxPolicyBusinessId > @StartId)
BEGIN

    IF object_id('tempdb..#tdnpolicymatching_1') IS NOT NULL
        DROP TABLE #tdnpolicymatching_1
    IF object_id('tempdb..#tdnpolicymatching_2') IS NOT NULL
        DROP TABLE #tdnpolicymatching_2
    IF object_id('tempdb..#tdnpolicymatching_3') IS NOT NULL
        DROP TABLE #tdnpolicymatching_3

    -- Do this query in stages for performance to mitigate bad statistics
    SELECT  DISTINCT 
        PolicyId                    = tsh.PolicyBusinessId
    ,   StatusId                    = tsh.StatusId
    ,   StatusDate                  = tsh.ChangedToDate
    ,   SubmittedDate               = tsh.ChangedToDate
    ,   BandingTemplateId           = tpbX.BandingTemplateId
    INTO    #tdnpolicymatching_1
    FROM        PolicyManagement..TStatusHistory        tsh
    INNER JOIN  PolicyManagement..TStatus               ts      ON ts.StatusID = tsh.StatusId
    LEFT JOIN   #PolicyBusiness                         tpb2    ON tsh.PolicyBusinessId = tpb2.PolicyBusinessId
    INNER JOIN  Policymanagement.dbo.TPolicyBusinessExt tpbX    ON tsh.policybusinessid = tpbX.policybusinessid   
    WHERE
    (     
    ( tpb2.PolicyBusinessId Is Null And tsh.CurrentStatusFG = 1 AND ts.IntelligentOfficeStatusType IN ('Submitted to Provider','In force', /*'NTU', */  'Off Risk','Paid Up') )    
    OR    
    ( tpb2.PolicyBusinessId Is Not Null And tpb2.Include = 1 And tsh.StatusHistoryId = tpb2.ToStatusHistoryId) 
    )
    AND 
        tsh.PolicyBusinessId Between @StartId And @StartId + @Step

    CREATE CLUSTERED INDEX PK_#tdnpolicymatching_1_policy_id ON #tdnpolicymatching_1 (PolicyId)

    SELECT  DISTINCT 
        IndClientId                 = tpb.IndigoClientId
    ,   PolicyId                    = tsh.PolicyId
    ,   PolicyNo                    = tpb.PolicyNumber
    ,   PolicyRef                   = tpb.SequentialRef
    ,   PractitionerId              = tpb.PractitionerId         
    ,   StatusId                    = tsh.StatusId
    ,   StatusDate                  = tsh.StatusDate
    ,   SubmittedDate               = tsh.SubmittedDate
    ,   BandingTemplateId           = tsh.BandingTemplateId
    ,   TopupMasterPolicyId         = tpb.TopupMasterPolicyBusinessId
    ,   PolicyDetailId              = tpb.PolicyDetailId
    INTO    #tdnpolicymatching_2
    FROM        #tdnpolicymatching_1                tsh
    INNER JOIN  Policymanagement..TPolicyBusiness   tpb     ON tsh.PolicyId = tpb.PolicyBusinessId

    CREATE CLUSTERED INDEX IX_#tdnpolicymatching_2_PolicyDetailId_PolicyId ON #tdnpolicymatching_2 (PolicyDetailId, PolicyId)
    
    INSERT #tdnpolicymatching
    SELECT  DISTINCT 
        IndClientId                 = tpb.IndClientId
    ,   PolicyId                    = tpb.PolicyId
    ,   PolicyNo                    = tpb.PolicyNo
    ,   PolicyRef                   = tpb.PolicyRef
    ,   ExpCommAmount               = 
            CASE tpec.ExpectedCommissionType    
                WHEN 0 THEN  tpec.ExpectedAmount    
                Else 0    
            END 
    ,   RefProdProviderId           = tpd.RefProdProviderId
    ,   ProviderName                = tcc.corporatename
    ,   RefComTypeId                = tpec.RefCommissionTypeId
    ,   RefComTypeName              = tct.CommissionTypeName
    ,   PractitionerId              = tpb.PractitionerId         
    ,   PractUserId                 = tu.UserId
    ,   PractName                   = tcc2.Firstname + ' ' + tcc2.Lastname
    ,   ClientId                    = tcc3.crmcontactid
    ,   ClientFirstName             = tcc3.Firstname
    ,   ClientLastName              = Case When IsNull(tcc3.LastName,'') <>'' Then tcc3.LastName Else tcc3.CorporateName End --tcc3.lastname,     
    ,   PreSubmissionFG             = 0
    ,   StatusId                    = tpb.StatusId
    ,   StatusDate                  = tpb.StatusDate
    ,   SubmittedDate               = tpb.SubmittedDate
    ,   ConcurrencyId               = 1
    ,   GroupId                     = PolicyManagement.dbo.FnGetLegalEntityForAdviser(tpb.PractitionerId)
    ,   RefPlanType2ProdSubTypeId   = tpd.RefPlanType2ProdSubTypeId
    ,   BandingTemplateId           = tpb.BandingTemplateId
    ,   TopupMasterPolicyId         = tpb.TopupMasterPolicyId

    ,   tpdl.PlanDescriptionId
    FROM        #tdnpolicymatching_2                        tpb
    INNER JOIN  Policymanagement..TPolicyDetail             tpdl    ON tpb.PolicyDetailId = tpdl.PolicyDetailId 
    INNER JOIN  Policymanagement..TPlandescription          tpd     ON tpdl.PlanDescriptionId = tpd.PlanDescriptionId 
    INNER JOIN  Policymanagement..TPolicyOwner              tpo     ON tpo.PolicyDetailId = tpdl.PolicyDetailId  
    LEFT JOIN   Commissions..TDNPolicyMatching              tdnpm   ON tdnpm.PolicyId= tpb.PolicyId And tpo.CrmContactId = tdnpm.ClientId  
    INNER JOIN  Policymanagement..TRefProdProvider          tpp     ON tpp.RefProdProviderId = tpd.RefProdProviderId
    INNER JOIN  CRM..TCRMContact                            tcc     ON tcc.crmcontactid = tpp.crmcontactid
    INNER JOIN  CRM..TPractitioner                          ctp     ON ctp.PractitionerId = tpb.PractitionerId  
    INNER JOIN  CRM..TCRMContact                            tcc2    ON tcc2.CRMContactId = ctp.CRMContactId 
    INNER JOIN  Administration..TUser                       tu      ON tu.CRMContactId = tcc2.CRMContactId           
    INNER JOIN  CRM..TCRMContact                            tcc3    ON tcc3.crmcontactid = tpo.crmcontactid  
    LEFT JOIN   Policymanagement..TPolicyExpectedCommission tpec     
    ON tpec.policybusinessid = tpb.policyid And (tpec.ExpectedCommissionType is null or tpec.ExpectedCommissionType = 0)    
    LEFT JOIN   Policymanagement..TRefCommissionType        tct     ON tct.RefCommissionTypeId = tpec.RefCommissionTypeId          
    WHERE 
        tdnpm.PolicyId IS NULL

    BEGIN TRANSACTION TX

    PRINT 'StartId:' + Convert(varchar(20), @StartId)
    
    Insert Into Commissions.dbo.tdnpolicymatching
    (IndClientId , PolicyId , PolicyNo , PolicyRef , ExpCommAmount ,
    RefProdProviderId , ProviderName , RefComTypeId , RefComTypeName , PractitionerId ,           
    PractUserId , PractName , ClientId , ClientFirstName, ClientLastName, PreSubmissionFG , StatusId ,           
    StatusDate , SubmittedDate , ConcurrencyId, GroupId, RefPlanType2ProdSubTypeId, BandingTemplateId, TopupMasterPolicyId )          
    
    SELECT  IndClientId , PolicyId , PolicyNo , PolicyRef , ExpCommAmount ,           
        RefProdProviderId , ProviderName , RefComTypeId , RefComTypeName , PractitionerId ,           
        PractUserId , PractName , ClientId , ClientFirstName, ClientLastName, PreSubmissionFG , StatusId ,           
        StatusDate , SubmittedDate , ConcurrencyId, GroupId, RefPlanType2ProdSubTypeId, BandingTemplateId, TopupMasterPolicyId
    FROM #tdnpolicymatching;

    IF @@ERROR != 0 GOTO errh

    -- Update the temp table with the identity before updating the audit table. Temp table used to reduce deadlocks
    UPDATE A
    SET DnPolicyMatchingId = B.DnPolicyMatchingId
    FROM #tdnpolicymatching                   A
    JOIN Commissions.dbo.tdnpolicymatching    B
    ON A.IndClientId = B.IndClientId AND  A.PolicyId = B.PolicyId
    AND A.ClientId = B.ClientId
    AND (
            A.RefComTypeId = b.RefComTypeId
        OR
            A.RefComTypeId is null AND b.RefComTypeId is null
    )
      
    IF @@ERROR != 0 GOTO errh
    
    -- The insert is not done directly from the tdnpolicymatching to avoid a deadlock with FactFind..SpNCustomCreateDNPolicyMatchingByPolicyId
    Insert Into Commissions.dbo.TDnPolicyMatchingAudit -- deadlock with factfind..SpNCustomCreateDNPolicyMatchingByPolicyId step 1
    (IndClientId , PolicyId , PolicyNo , PolicyRef , ExpCommAmount ,           
    RefProdProviderId , ProviderName , RefComTypeId , RefComTypeName , PractitionerId ,           
    PractUserId , PractName , ClientId , ClientFirstName, ClientLastName , PreSubmissionFG , StatusId ,           
    StatusDate , SubmittedDate , ConcurrencyId , StampAction , StampDateTime , StampUser , DnPolicyMatchingId, Groupid,     
    RefPlanType2ProdSubTypeId, BandingTemplateId, TopupMasterPolicyId )    
      
    Select IndClientId , PolicyId , PolicyNo , PolicyRef , ExpCommAmount ,           
    RefProdProviderId , ProviderName , RefComTypeId , RefComTypeName , PractitionerId ,           
    PractUserId , PractName , ClientId , ClientFirstName, ClientLastName , PreSubmissionFG , StatusId ,           
    StatusDate , SubmittedDate , ConcurrencyId  , 'c' , getdate() , 0 , DnPolicyMatchingId, GroupId,     
    RefPlanType2ProdSubTypeId, BandingTemplateId, TopupMasterPolicyId  
    FROM #tdnpolicymatching     
    
    IF @@ERROR != 0 GOTO errh
     
    DELETE dbo.TPolicyBusinessCache WHERE PolicyBusinessId IN (Select DISTINCT PolicyId From #tdnpolicymatching)    
    
    IF @@ERROR != 0 GOTO errh    
    
    COMMIT TRANSACTION TX
    
    TRUNCATE TABLE #tdnpolicymatching
    SELECT @StartId = @StartId + @Step
END

----------------------------------------------------------------------------------------------    
----------------------------------------------------------------------------------------------    
         
 ----------------------------------------------------------------------------------------------    
 ----------------------------------------------------------------------------------------------    
 Print 'Delete records from TDnPolicyMatching where the plan is deleted or draft and there are no payments'

INSERT #tdnpolicymatching  (
        IndClientId 
    ,   PolicyId 
    ,   PolicyNo 
    ,   PolicyRef 
    ,   ExpCommAmount           
    ,   RefProdProviderId 
    ,   ProviderName 
    ,   RefComTypeId 
    ,   RefComTypeName 
    ,   PractitionerId 
    ,   PractUserId 
    ,   PractName 
    ,   ClientId 
    ,   ClientFirstName
    ,   ClientLastName
    ,   PreSubmissionFG 
    ,   StatusId 
    ,   StatusDate 
    ,   SubmittedDate 
    ,   ConcurrencyId
    ,   GroupId
    ,   RefPlanType2ProdSubTypeId
    ,   BandingTemplateId
    ,   TopupMasterPolicyId
    ,   DnPolicyMatchingId)

SELECT 
    A.IndClientId 
,   A.PolicyId
,   A.PolicyNo
,   A.PolicyRef
,   A.ExpCommAmount
,   A.RefProdProviderId
,   A.ProviderName
,   A.RefComTypeId
,   A.RefComTypeName
,   A.PractitionerId
,   A.PractUserId
,   A.PractName
,   A.ClientId
,   A.ClientFirstName
,   A.ClientLastName
,   A.PreSubmissionFG
,   A.StatusId
,   A.StatusDate
,   A.SubmittedDate
,   A.ConcurrencyId  
,   A.GroupId
,   A.RefPlanType2ProdSubTypeId
,   A.BandingTemplateId
,   a.TopupMasterPolicyId
,   A.DnPolicyMatchingId
 FROM Commissions..TDnPolicyMatching A with(nolock)    
 Inner Join PolicyManagement..TStatusHistory B with(nolock)    
  ON A.PolicyId = B.PolicyBusinessId    
 Inner Join PolicyManagement..TStatus C with(nolock)    
  ON B.StatusId = C.StatusId And (IntelligentOfficeStatusType = 'Deleted'  OR   IntelligentOfficeStatusType='Draft')
 Left Join Commissions..TProvBreak D with(nolock)    
  ON A.IndClientId = D.IndClientId AND
  A.PolicyId = D.PolicyId And AnalyseFG = 1    
 Left Join Commissions..TCashReceiptMatch E with(nolock)    
  ON D.ProvComStateId = E.ProvComStateId    
 Where CurrentStatusFG = 1    
  And D.ProvBreakId Is Null And E.CashReceiptMatchId Is Null    


 DELETE A
 OUTPUT
	deleted.IndClientId 
,   deleted.PolicyId 
,   deleted.PolicyNo 
,   deleted.PolicyRef 
,   deleted.ExpCommAmount           
,   deleted.RefProdProviderId 
,   deleted.ProviderName 
,   deleted.RefComTypeId 
,   deleted.RefComTypeName 
,   deleted.PractitionerId 
,   deleted.PractUserId 
,   deleted.PractName 
,   deleted.ClientId 
,   deleted.ClientFirstName
,   deleted.ClientLastName
,   deleted.PreSubmissionFG 
,   deleted.StatusId 
,   deleted.StatusDate 
,   deleted.SubmittedDate 
,   deleted.ConcurrencyId
,   deleted.GroupId
,   deleted.RefPlanType2ProdSubTypeId
,   deleted.BandingTemplateId
,   deleted.TopupMasterPolicyId
,   deleted.DnPolicyMatchingId
,   'D'
,   getdate()
,   0 
INTO Commissions.dbo.TDnPolicyMatchingAudit 
(
        IndClientId 
    ,   PolicyId 
    ,   PolicyNo 
    ,   PolicyRef 
    ,   ExpCommAmount           
    ,   RefProdProviderId 
    ,   ProviderName 
    ,   RefComTypeId 
    ,   RefComTypeName 
    ,   PractitionerId 
    ,   PractUserId 
    ,   PractName 
    ,   ClientId 
    ,   ClientFirstName
    ,   ClientLastName
    ,   PreSubmissionFG 
    ,   StatusId 
    ,   StatusDate 
    ,   SubmittedDate 
    ,   ConcurrencyId
    ,   GroupId
    ,   RefPlanType2ProdSubTypeId
    ,   BandingTemplateId
    ,   TopupMasterPolicyId
    ,   DnPolicyMatchingId
    ,   StampAction
    ,   StampDateTime
    ,   StampUser
)  
FROM Commissions..TDnPolicyMatching    A
JOIN #TDnPolicyMatching                B
ON A.DnPolicyMatchingId = B.DnPolicyMatchingId

IF @@ERROR != 0 GOTO errh     


----------------------------------------------------------------------------------------------    
---------------------------------------------------------------------------------------------- 
-- Keep the slow query out of the transaction to minimise deadlocks
SELECT StatusId 
INTO #Status 
FROM PolicyManagement..TStatus 
WHERE 
    IntelligentOfficeStatusType = 'Deleted'  
OR  IntelligentOfficeStatusType='Draft';

ALTER TABLE #STAtus ADD CONSTRAINT PK_Temp_STatus_SatusId1 PRIMARY KEY (StatusId);

  Select A.IndClientId, A.GroupId, A.PolicyId, A.RetainerId, A.FeeId, A.ProviderId, A.BreakPolicyNo,     
  A.BreakClientName, A.ConcurrencyId, A.LUProvBreaksId, StampAction='d', StampDateTime=getdate(), StampUser=0
  INTO #T
  From Commissions..TLUProvBreaks A with(nolock)    
  Inner Join PolicyManagement..TStatusHistory B with(nolock)    
  ON A.PolicyId = B.PolicyBusinessId    
  INNER JOIN #Status C 
  ON B.StatusId = C.StatusId 
  Where B.CurrentStatusFG = 1    -- 13274

  SELECT  A.IndClientId, A.GroupId, A.PolicyId, A.RetainerId, A.FeeId, A.ProviderId, A.BreakPolicyNo,     
  A.BreakClientName, A.ConcurrencyId, A.LUProvBreaksId, StampAction='D', StampDateTime=getdate(), StampUser=0 
  INTO #TLUProvBreaksAudit 
  FROM #T a
  Left Join Commissions..TProvBreak D with(nolock)    
  ON A.IndClientId = D.IndClientId AND 
  A.PolicyId = D.PolicyId And D.AnalyseFG = 1   
  WHERE D.ProvBreakId Is Null 

 ----------------------------------------------------------------------------------------------    
 ----------------------------------------------------------------------------------------------    
 Print 'Delete records from TLUProvBreaks where the plan is deleted and there are no payments'
     
 DELETE A
 OUTPUT 
  deleted.IndClientId, deleted.GroupId, deleted.PolicyId, deleted.RetainerId, deleted.FeeId, deleted.ProviderId, deleted.BreakPolicyNo,     
  deleted.BreakClientName, deleted.ConcurrencyId, deleted.LUProvBreaksId, 'D', getdate(), 0 
 
 INTO Commissions.dbo.TLUProvBreaksAudit          
 ( IndClientId, GroupId, PolicyId, RetainerId, FeeId, ProviderId, BreakPolicyNo,     
  BreakClientName, ConcurrencyId, LUProvBreaksId, StampAction, StampDateTime, StampUser )

 FROM Commissions..TLUProvBreaks A
 JOIN #TLUProvBreaksAudit B
 ON A.PolicyId = B.PolicyId
    
 IF @@ERROR != 0 GOTO errh          
    
 DROP TABLE #PolicyBusiness    
    
RETURN (0)          
          
errh:          
	If @@TRANCOUNT > 0  
		ROLLBACK TRANSACTION TX          
  RETURN (100)
GO
