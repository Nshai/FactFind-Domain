 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardLayout
--    Join: 
--   Where: WHERE TenantId = 12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9B8E847C-8D5D-4DA4-9BD1-273B8EBC7688'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
 
        INSERT INTO TDashboardLayout([DashboardId], [Name], [Layout], [TenantId], [IsPublic], [OwnerId], [ConcurrencyId])
        SELECT '72E47DFA-2F8C-43DA-8F48-258B9F9DB8F1', 'Adviser User', '{"ContextProviders":[],"Components":{"9f992fc4-9d85-41a1-9a15-c81f5b772a68":{"Identifier":"myClientsPlans","Column":1,"Index":3,"Metadata":{}},"912ec941-2c40-46c6-a706-c8d2e39828ed":{"Identifier":"myCompliance","Column":0,"Index":2,"Metadata":{}},"11accc99-6414-4db6-a1db-569ed695ca4b":{"Identifier":"myRecentClients","Column":0,"Index":0,"Metadata":{}},"308c60de-dfa4-4dcf-8a3c-afe46ee9b6fd":{"Identifier":"mySubmittedFeesAndIncome","Column":2,"Index":2,"Metadata":{}},"76526257-5c9c-4e6c-b2ea-61d6a8f0e062":{"Identifier":"myFeesAndCommissions","Column":2,"Index":1,"Metadata":{}},"ced110fb-9d14-4b23-9f00-14b185ea6711":{"Identifier":"myLeads","Column":1,"Index":4,"Metadata":{}},"8ce2cadf-bc8f-4428-b538-e142cc81c888":{"Identifier":"myTopTenOpenOpportunities","Column":1,"Index":2,"Metadata":{}},"a287b6af-01ab-4300-b291-f154e832ac95":{"Identifier":"myTasksDueToday","Column":1,"Index":0,"Metadata":{}},"58c084dc-b1bc-4053-9277-0eb8c544f43c":{"Identifier":"myOpenOpportunities","Column":1,"Index":1,"Metadata":{}},"cadf1f48-f0f3-45ef-ae12-4a9e11a2f08d":{"Identifier":"myPlans","Column":0,"Index":3,"Metadata":{}},"516dce6e-9a0c-47b6-ac4c-d7a61ac0bd3a":{"Identifier":"myOpenServiceCases","Column":0,"Index":1,"Metadata":{}},"2a06d5ab-8f93-4c5d-bbad-93873228e6d3":{"Identifier":"myTargetIncome","Column":2,"Index":0,"Metadata":{}}}}',12498,1,NULL,50 UNION ALL 
        SELECT '0B09EA57-6447-42A3-9341-545A542293ED', 'Group', '{"ContextProviders":["Group"],"Components":{"6ef3c7b5-8328-4080-aba8-fe7fe7e0d484":{"Identifier":"groupTop10Products","Column":0,"Index":0,"Metadata":{}},"170d09bf-ad77-4254-8c65-8795c57e5566":{"Identifier":"groupClients","Column":1,"Index":1,"Metadata":{}},"dd2ae44d-eb31-4529-9c6d-14f9d0d57f83":{"Identifier":"groupCommissionPerMonth","Column":2,"Index":0,"Metadata":{}},"f2e52c33-043c-47ee-add4-711da2144643":{"Identifier":"groupCompliance","Column":2,"Index":1,"Metadata":{}},"28b94f2b-03fd-4c6c-b192-47024fe6a086":{"Identifier":"groupKPI","Column":1,"Index":2,"Metadata":{}},"b2561b50-76ef-4851-9b82-0ffaf976f83f":{"Identifier":"groupTop10ProductsByCommission","Column":0,"Index":1,"Metadata":{}},"3c79a323-b54c-4a08-989b-56be8c8b63a7":{"Identifier":"groupOpportunities","Column":1,"Index":3,"Metadata":{}},"bbb1b0e5-4fce-4e07-ac6c-6952d19beec1":{"Identifier":"groupTasks","Column":1,"Index":4,"Metadata":{}},"01cf72a9-db78-4591-a239-0c08d2646159":{"Identifier":"groupOpenServiceCases","Column":1,"Index":0,"Metadata":{}}}}',12498,1,NULL,3 UNION ALL 
        SELECT 'C717DE6D-E7FD-4D48-A0E1-75AD782FA775', 'Organiser', '{"ContextProviders":[],"Components":{"c16d5a8c-d69f-4f2e-ae20-59f2b7d4a4c0":{"Identifier":"myTasks","Column":0,"Index":1,"Metadata":{}},"8212f9e9-748c-41f9-947e-81042c1bd2ff":{"Identifier":"myTop10OverdueTasks","Column":2,"Index":0,"Metadata":{}},"c766acf3-9323-42ca-8ca5-ca9e76d964a0":{"Identifier":"myTasksDueToday","Column":1,"Index":0,"Metadata":{}},"1eac7097-ee36-423f-9ae9-cbe402e12d2a":{"Identifier":"myTasksDueFromTomorrow","Column":1,"Index":1,"Metadata":{}},"f2d5f931-a183-4078-b118-89f9d228b097":{"Identifier":"myAccessDiary","Column":0,"Index":0,"Metadata":{}}}}',12498,1,NULL,3 UNION ALL 
        SELECT '2C7F1B4A-A531-4F71-8DDE-C578808FDB94', 'Client', '{"ContextProviders":[],"Components":{"e87805ae-8fe9-42ae-bcbd-13eb3f324557":{"Identifier":"clientDetails","Column":0,"Index":0,"Metadata":{}},"baa9c29e-0b26-4f35-8fc0-987929ae0800":{"Identifier":"clientActivity","Column":1,"Index":4,"Metadata":{}},"aed9ce80-b999-430c-95e0-ec44cfc143b4":{"Identifier":"clientRelationships","Column":1,"Index":0,"Metadata":{}},"5108bdb5-f65a-430a-b066-7f9751c6e89c":{"Identifier":"clientActivities","Column":2,"Index":2,"Metadata":{}},"6aef8674-bbb4-4e2b-a356-141a8b3ff210":{"Identifier":"clientKeyFacts","Column":1,"Index":2,"Metadata":{}},"fa00f0b2-5b34-427b-a41e-2d27c539a080":{"Identifier":"clientPortfolioFunds","Column":0,"Index":1,"Metadata":{}},"1faf2589-536b-451f-8be1-3e1382d88e03":{"Identifier":"clientProposals","Column":2,"Index":1,"Metadata":{}},"82f7e921-f481-4bae-be93-398ecf29cad6":{"Identifier":"clientOpportunities","Column":2,"Index":0,"Metadata":{}},"b6eb7f03-1949-4f63-a05f-501376082012":{"Identifier":"clientProfitability","Column":2,"Index":5,"Metadata":{}},"b57ecb8e-eeb3-4c22-93ca-25e801a93148":{"Identifier":"clientPortfolio","Column":0,"Index":3,"Metadata":{}},"d68e6295-3886-49b4-a671-a2201829be6f":{"Identifier":"clientKeyNotes","Column":1,"Index":1,"Metadata":{}},"6d1a2e0f-9918-41d0-8041-02e0b50adc02":{"Identifier":"clientActivePlans","Column":1,"Index":3,"Metadata":{}},"73b49dfc-45f7-42e5-b4d1-5d1a2809509f":{"Identifier":"clientPlanValueByPlanType","Column":2,"Index":3,"Metadata":{}},"96aabc98-e63d-4ee9-9ec1-1fed1c898c50":{"Identifier":"clientPlanValueByProposition","Column":2,"Index":4,"Metadata":{}},"054aa5be-6d6c-4cf0-b7da-43faefaa05f6":{"Identifier":"clientGroupSchemeMembershipTop10","Column":0,"Index":4,"Metadata":{}},"e7f5c066-7251-4ee8-9706-3e62787b30ba":{"Identifier":"clientGroupSchemeFinancialOverviewTop10","Column":0,"Index":5,"Metadata":{}},"a9e716d9-9180-40e3-a3d0-64a143609304":{"Identifier":"familyGroupWealth","Column":0,"Index":2,"Metadata":{}}}}',12498,1,NULL,56 UNION ALL 
        SELECT '7DA6B859-AABB-4681-A821-F6ED200AEE62', 'Non Advisory', '{"ContextProviders":[],"Components":{"8129479c-07c8-4ddf-a943-48b75a479125":{"Identifier":"myRecentWork","Column":0,"Index":1,"Metadata":{}},"1304040b-9540-4b08-a846-486411222a8d":{"Identifier":"myTasks","Column":1,"Index":1,"Metadata":{}},"3ab723fb-8a0e-4014-b67d-42cb0070786d":{"Identifier":"myTop10OverdueTasks","Column":2,"Index":0,"Metadata":{}},"db314a6e-8f88-481b-ad72-448fc53a732a":{"Identifier":"myTasksDueFromTomorrow","Column":2,"Index":1,"Metadata":{}},"dbf221f9-ef29-4408-99c8-9d15d7c2f953":{"Identifier":"myTasksDueToday","Column":1,"Index":0,"Metadata":{}},"26958667-ffba-4212-aaa1-1889e3e80ef5":{"Identifier":"myRecentClients","Column":0,"Index":0,"Metadata":{}},"d3664182-48f6-4150-ae74-20cf6610eeb9":{"Identifier":"myTasksFromTodayByStartDate","Column":1,"Index":2,"Metadata":{}}}}',12498,1,NULL,7 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9B8E847C-8D5D-4DA4-9BD1-273B8EBC7688', 
         'Initial load (5 total rows, file 1 of 1) for table TDashboardLayout',
         12498, 
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
-- #Rows Exported: 5
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
