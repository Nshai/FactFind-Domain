SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
	Custom SP for retrieving Firm schedules Extended Details - i.e. just the addtional information we need to show on the screen
	LIO Procedure: SpCustomRetrieveScheduleForFirm
*/ 
 
CREATE PROCEDURE [dbo].[nio_ContractEnquiry_FirmScheduleExtendedDetails]  @ValScheduleId bigint
AS    
  
If Exists (Select 1 from Policymanagement..TValSchedule WITH(NOLOCK) where ValScheduleId = @ValScheduleId and ScheduledLevel = 'firm')        
 Begin        

        Declare @IndigoClientId bigint, @RefprodProviderId bigint, @RefGroupId bigint,  @ParentGroup BIGINT
        DECLARE @AdviserCount BIGINT, @TotalPlans BIGINT, @ExcludedPlans BIGINT

        Select @IndigoClientId = IndigoClientId, @RefprodProviderId = RefprodProviderId , @RefGroupId = RefGroupId
        From TValSchedule With(NoLock)
        Where ValScheduleId = @ValScheduleId

        SELECT @ParentGroup = GroupId FROM Administration..TGroup	WHERE IndigoClientId = @IndigoClientId AND ParentId IS NULL

    --    if (select object_id('tempdb..#validplans')) is not null
    --           drop table #validplans

    --    create table #validplans
	   --     (IndigoClientId bigint , PolicyBusinessId bigint, OwnerCRM bigint, BaseProvider bigint, RefProdProviderId bigint,
	   --     SellingPractitioner  bigint, SellingCRM bigint, ServicingPractitioner bigint, ServicingCRM bigint, ValueByServicingAdviser bigint,
	   --     TopupPolicyBusinessId bigint)
    --    insert #validplans  exec spFindValidPlansforValuation @RefprodProviderId, @IndigoClientId, DEFAULT, 1

    --    if (select object_id('tempdb..#PlansTable')) is not null
    --           drop table #PlansTable

    --    Create Table #PlansTable(           
    --     PolicyBusinessId bigint,              
    --     RefProdProviderId bigint,              
    --     PractitionerCRMContactId bigint )  

    --    INSERT INTO #PlansTable
    --        (PolicyBusinessId, RefProdProviderId, PractitionerCRMContactId)
    --    SELECT 
    --            PolicyBusinessId, RefProdProviderId, SellingCRM
    --    FROM 
    --            #validplans VP
    --                INNER JOIN Administration..TUser US WITH (NOLOCK)  ON VP.SellingCRM = US.CRMContactId  
    --    Where 
    --    ( (@ParentGroup =   @RefGroupId) OR (us.GroupId  =   @RefGroupId))  

    --SELECT @AdviserCount    = COUNT(DISTINCT PractitionerCRMContactId)  FROM #PlansTable
    --SELECT @TotalPlans   = COUNT(PolicyBusinessId)  FROM #PlansTable
    --SELECT @ExcludedPlans = COUNT(VP.PolicyBusinessId) 
                    --From #PlansTable VP inner join PolicyManagement..TValExcludedPlan EP on EP.policybusinessid = VP.policybusinessid

End        
        
Select        
 IsNull(A.ValScheduleId,0) AS ValScheduleId,
 IsNull(A.IndigoClientId,0) AS IndigoClientId,
 IsNull(A.RefProdProviderId,0) AS RefProdProviderId,
 ISNULL(@AdviserCount,0) AS AdviserCount,
 IsNull(@TotalPlans ,0) AS PlanCount,
 Coalesce(@TotalPlans - @ExcludedPlans,0) AS PlansThatCanBeScheduled,
 IsNull(@ExcludedPlans,0) AS PlansThatCannotBeScheduled,
 IsNull(reg.FileAccessCredentialsRequired,0) AS FileAccessCredentialsRequired,
 CONVERT( varchar, isnull(@TotalPlans,0) )  + ' / ' +  CONVERT( varchar, isnull(@AdviserCount,0) ) AS PlanAndAdviserCount,
 'Not Used' AS ScheduleStatus
From
 PolicyManagement..TValSchedule A WITH(NOLOCK) 
 Inner Join PolicyManagement..TValScheduleItem B WITH(NOLOCK) On A.ValScheduleId = B.ValScheduleId        
 Left Join PolicyManagement..TValProviderConfig reg WITH(NOLOCK) On A.RefProdProviderId = reg.RefProdProviderId               
Where         
a.ValScheduleId = @ValScheduleId

Return(0)
GO
