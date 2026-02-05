 
-----------------------------------------------------------------------------
-- Table: Administration.TDashboardLayout
--    Join: 
--   Where: WHERE TenantId = 466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '9B8E847C-8D5D-4DA4-9BD1-273B8EBC7688'
     AND TenantId = 466
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
        SELECT 'ABE9E3D8-9F46-4079-BACF-0116720E2EF0', 'Adviser User', '{"ContextProviders":[],"Components":{"9f992fc4-9d85-41a1-9a15-c81f5b772a68":{"Identifier":"myClientsPlans","Column":0,"Index":1,"Metadata":{}},"84938bff-1dde-4e36-a423-eb8ba8ed0091":{"Identifier":"myClients","Column":1,"Index":1,"Metadata":{}},"912ec941-2c40-46c6-a706-c8d2e39828ed":{"Identifier":"myCompliance","Column":1,"Index":4,"Metadata":{}},"a3e63487-c105-4c96-89b3-91720ee768a7":{"Identifier":"myOpportunities","Column":1,"Index":3,"Metadata":{}},"e6934de8-afa4-4853-8e00-6cedd8a1eaed":{"Identifier":"myTasks","Column":1,"Index":0,"Metadata":{}},"11accc99-6414-4db6-a1db-569ed695ca4b":{"Identifier":"myRecentClients","Column":0,"Index":0,"Metadata":{}},"308c60de-dfa4-4dcf-8a3c-afe46ee9b6fd":{"Identifier":"mySubmittedFeesAndIncome","Column":2,"Index":0,"Metadata":{}},"76526257-5c9c-4e6c-b2ea-61d6a8f0e062":{"Identifier":"myFeesAndCommissions","Column":2,"Index":1,"Metadata":{}},"782df73d-2d58-4b48-8652-9e34144a3e17":{"Identifier":"myLeads","Column":1,"Index":2,"Metadata":{}}}}',466,1,NULL,1 UNION ALL 
        SELECT '8C4C5FC3-41E5-4726-875E-36D1B9D5D64C', 'Admin User', '{"ContextProviders":[],"Components":{"8129479c-07c8-4ddf-a943-48b75a479125":{"Identifier":"myRecentWork","Column":0,"Index":1,"Metadata":{}},"1304040b-9540-4b08-a846-486411222a8d":{"Identifier":"myTasks","Column":1,"Index":0,"Metadata":{}},"3ab723fb-8a0e-4014-b67d-42cb0070786d":{"Identifier":"myTop10OverdueTasks","Column":1,"Index":1,"Metadata":{}},"db314a6e-8f88-481b-ad72-448fc53a732a":{"Identifier":"myTasksDueFromTomorrow","Column":2,"Index":1,"Metadata":{}},"dbf221f9-ef29-4408-99c8-9d15d7c2f953":{"Identifier":"myTasksDueToday","Column":2,"Index":0,"Metadata":{}},"26958667-ffba-4212-aaa1-1889e3e80ef5":{"Identifier":"myRecentClients","Column":0,"Index":0,"Metadata":{}}}}',466,1,NULL,1 UNION ALL 
        SELECT 'EF96510C-0BEE-4D22-B12E-775C5513510B', 'Group', '{"ContextProviders":["Group"],"Components":
						{"6ef3c7b5-8328-4080-aba8-fe7fe7e0d484":{"Identifier":"groupTop10Products","Column":0,"Index":0,"Metadata":{}},
						"170d09bf-ad77-4254-8c65-8795c57e5566":{"Identifier":"groupClients","Column":1,"Index":0,"Metadata":{}},
						"dd2ae44d-eb31-4529-9c6d-14f9d0d57f83":{"Identifier":"groupCommissionPerMonth","Column":2,"Index":0,"Metadata":{}},
						"f2e52c33-043c-47ee-add4-711da2144643":{"Identifier":"groupCompliance","Column":2,"Index":1,"Metadata":{}},
						"28b94f2b-03fd-4c6c-b192-47024fe6a086":{"Identifier":"groupKPI","Column":1,"Index":1,"Metadata":{}},
						"b2561b50-76ef-4851-9b82-0ffaf976f83f":{"Identifier":"groupTop10ProductsByCommission","Column":0,"Index":1,"Metadata":{}},
						"3c79a323-b54c-4a08-989b-56be8c8b63a7":{"Identifier":"groupOpportunities","Column":1,"Index":2,"Metadata":{}},
						"bbb1b0e5-4fce-4e07-ac6c-6952d19beec1":{"Identifier":"groupTasks","Column":1,"Index":3,"Metadata":{}}}}',466,1,NULL,1 UNION ALL 
        SELECT '83DA7E50-27A7-4076-8CD0-C56FC128E1A5', 'Client', '{"ContextProviders":[],"Components":
						{"e87805ae-8fe9-42ae-bcbd-13eb3f324557":{"Identifier":"clientDetails","Column":0,"Index":0,"Metadata":{}},
						"baa9c29e-0b26-4f35-8fc0-987929ae0800":{"Identifier":"clientActivity","Column":1,"Index":1,"Metadata":{}},
						"aed9ce80-b999-430c-95e0-ec44cfc143b4":{"Identifier":"clientRelationships","Column":1,"Index":0,"Metadata":{}},
						"5108bdb5-f65a-430a-b066-7f9751c6e89c":{"Identifier":"clientActivities","Column":1,"Index":3,"Metadata":{}},
						"6aef8674-bbb4-4e2b-a356-141a8b3ff210":{"Identifier":"clientKeyFacts","Column":1,"Index":2,"Metadata":{}},
						"fa00f0b2-5b34-427b-a41e-2d27c539a080":{"Identifier":"clientPortfolioFunds","Column":0,"Index":2,"Metadata":{}},
						"1faf2589-536b-451f-8be1-3e1382d88e03":{"Identifier":"clientProposals","Column":2,"Index":1,"Metadata":{}},
						"82f7e921-f481-4bae-be93-398ecf29cad6":{"Identifier":"clientOpportunities","Column":2,"Index":0,"Metadata":{}},
						"b6eb7f03-1949-4f63-a05f-501376082012":{"Identifier":"clientProfitability","Column":2,"Index":2,"Metadata":{}},
						"b57ecb8e-eeb3-4c22-93ca-25e801a93148":{"Identifier":"clientPortfolio","Column":0,"Index":1,"Metadata":{}}}}',466,1,NULL,1 UNION ALL 
        SELECT 'B295A06B-FA23-4325-887D-D96325FD4BD1', 'Organiser', '{"ContextProviders":[],"Components":
					{"c16d5a8c-d69f-4f2e-ae20-59f2b7d4a4c0":{"Identifier":"myTasks","Column":0,"Index":0,"Metadata":{}},
					"8212f9e9-748c-41f9-947e-81042c1bd2ff":{"Identifier":"myTop10OverdueTasks","Column":0,"Index":1,"Metadata":{}},
					"c766acf3-9323-42ca-8ca5-ca9e76d964a0":{"Identifier":"myTasksDueToday","Column":1,"Index":0,"Metadata":{}},
					"1eac7097-ee36-423f-9ae9-cbe402e12d2a":{"Identifier":"myTasksDueFromTomorrow","Column":1,"Index":1,"Metadata":{}},
					"F2D5F931-A183-4078-B118-89F9D228B097":{"Identifier":"myAccessDiary","Column":0,"Index":0,"Metadata":{}}}}',466,1,NULL,1 
 
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '9B8E847C-8D5D-4DA4-9BD1-273B8EBC7688', 
         'Initial load (5 total rows, file 1 of 1) for table TDashboardLayout',
         466, 
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
