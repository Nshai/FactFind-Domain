 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardComponent
--    Join: 
--   Where: WHERE TenantId IS NULL
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '2D5DCA0D-47E8-442B-A89E-17A08C95CEAA'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TDashboardComponent ON; 
 
        INSERT INTO TDashboardComponent([DashboardComponentId], [Identifier], [Description], [ConcurrencyId], [TenantId])
        SELECT 32, 'myAccessDiary', 'My Access Diary',1,NULL UNION ALL 
        SELECT 31, 'clientProfitability', 'Client Productivity',1,NULL UNION ALL 
        SELECT 30, 'clientProposals', 'Client Proposals (oldest 5)',1,NULL UNION ALL 
        SELECT 29, 'clientOpportunities', 'Client Open Opportunities',1,NULL UNION ALL 
        SELECT 28, 'clientActivities', 'Client Tasks',1,NULL UNION ALL 
        SELECT 27, 'clientKeyFacts', 'Client Key Information',1,NULL UNION ALL 
        SELECT 26, 'clientActivity', 'Client Activity',1,NULL UNION ALL 
        SELECT 25, 'clientRelationships', 'Client Relationships',1,NULL UNION ALL 
        SELECT 24, 'clientPortfolioFunds', 'Client Portfolio Summary: FUM',1,NULL UNION ALL 
        SELECT 23, 'clientPortfolio', 'Client Portfolio Summary: Valuation',1,NULL UNION ALL 
        SELECT 22, 'clientDetails', 'Client Details',1,NULL UNION ALL 
        SELECT 21, 'groupCompliance', 'Group Compliance',1,NULL UNION ALL 
        SELECT 20, 'groupCommissionPerMonth', 'Group Income per Period Commencing',2,NULL UNION ALL 
        SELECT 19, 'groupTasks', 'Group Tasks',1,NULL UNION ALL 
        SELECT 18, 'groupOpportunities', 'Group Opportunities',1,NULL UNION ALL 
        SELECT 17, 'groupKPI', 'Group KPIs (Last Income Period)',1,NULL UNION ALL 
        SELECT 16, 'groupTop10ProductsByCommission', 'Group Top 10 Products (By Inc. Received)',1,NULL UNION ALL 
        SELECT 15, 'groupTop10Products', 'Group Top 10 Products (By Plan Type)',1,NULL UNION ALL 
        SELECT 14, 'groupClients', 'Group Clients',1,NULL UNION ALL 
        SELECT 13, 'myCompliance', 'My Compliance',1,NULL UNION ALL 
        SELECT 12, 'myFeesAndCommissions', 'My Received Fees and Income',1,NULL UNION ALL 
        SELECT 11, 'myOpportunities', 'My Opportunities',1,NULL UNION ALL 
        SELECT 10, 'myClients', 'My Clients',1,NULL UNION ALL 
        SELECT 9, 'myTasks', 'My Tasks',1,NULL UNION ALL 
        SELECT 8, 'myLeads', 'My Leads',1,NULL UNION ALL 
        SELECT 7, 'myClientsPlans', 'My Clients'' Plans',1,NULL UNION ALL 
        SELECT 34, 'clientContactDetails', 'Client Click to Call',1,NULL UNION ALL 
        SELECT 5, 'myTasksDueFromTomorrow', 'My Tasks Due from tomorrow - Top 10',1,NULL UNION ALL 
        SELECT 4, 'myTasksDueToday', 'My Tasks for Today - Top 10',1,NULL UNION ALL 
        SELECT 3, 'myTop10OverdueTasks', 'My Overdue Tasks - Top 10',1,NULL UNION ALL 
        SELECT 2, 'myRecentWork', 'My Recent Work',1,NULL UNION ALL 
        SELECT 1, 'myRecentClients', 'My Recent Clients',1,NULL UNION ALL 
        SELECT 33, 'mySubmittedFeesAndIncome', 'My Submitted Fees and Income',1,NULL UNION ALL 
        SELECT 35, 'clientKeyNotes', 'Client Key Notes',1,NULL UNION ALL 
        SELECT 36, 'myTopTenOpenOpportunities', 'My Opportunities - Top 10',1,NULL UNION ALL 
        SELECT 40, 'myTasksFromTodayByStartDate', 'My Tasks from Today by Start Date - Top 10',1,NULL UNION ALL 
        SELECT 41, 'clientGroupSchemeMembershipTop10', 'Client Group Scheme Membership - Top 10',1,NULL UNION ALL 
        SELECT 42, 'clientGroupSchemeFinancialOverviewTop10', 'Client Group Scheme Financial Overview - Top 10',1,NULL UNION ALL 
        SELECT 43, 'myOpenOpportunities', 'My Open Opportunities ',1,NULL UNION ALL 
        SELECT 44, 'mySaleMove', 'My SaleMove',1,NULL UNION ALL 
        SELECT 45, 'myPlans', 'My Plans',1,NULL UNION ALL 
        SELECT 46, 'clientPlanValueByPlanType', 'Client Plan Value by Plan Type',1,NULL UNION ALL 
        SELECT 47, 'clientPlanValueByProposition', 'Client Plan Value by Proposition',1,NULL UNION ALL 
        SELECT 48, 'clientActivePlans', 'Client Active Plans',1,NULL UNION ALL 
        SELECT 49, 'myOpenServiceCases', 'My Open Service Cases - Top 10',1,NULL UNION ALL 
        SELECT 50, 'myTargetIncome', 'My Target Income',1,NULL UNION ALL 
        SELECT 51, 'groupOpenServiceCases', 'Group Open Service Cases (By Status)',1,NULL UNION ALL 
        SELECT 52, 'familyGroupWealth', 'Client Family Group Wealth',1,NULL UNION ALL 
        SELECT 53, 'myOpenServiceCasesByStatus', 'My Open Service Cases (By Status)',1,NULL UNION ALL 
        SELECT 54, 'clientPfpDetails', 'Client PFP Details',1,NULL 
 
        SET IDENTITY_INSERT TDashboardComponent OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '2D5DCA0D-47E8-442B-A89E-17A08C95CEAA', 
         'Initial load (50 total rows, file 1 of 1) for table TDashboardComponent',
         null, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 50
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
