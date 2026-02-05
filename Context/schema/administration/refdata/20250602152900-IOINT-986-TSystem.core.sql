/*
Summary
=================================================================
IOINT-986 Added permissions for Wealthlink Dashboard

DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         5
administration      TSystemAudit                    5
*/

USE [administration]
DECLARE
	@ScriptGUID UNIQUEIDENTIFIER = '5A466A06-2782-40BC-B4C4-6A642C0C5557',
	@Comments VARCHAR(255) = 'IOINT-986 Added permissions for Wealthlink Dashboard',
	@StampDateTime DATETIME = GETUTCDATE(),
	@StampAction CHAR(1) = 'C',
	@StampUser INT = 0,
	@ConcurrencyId INT = 1,
	
	@applicationSupportPath VARCHAR(255) = 'administration.applicationsupport',
	@applicationSupportId INT,
	
	@wealthlinkDashboardIdentifier VARCHAR(255) = 'wealthlinkdashboard',
	@wealthlinkDashboardSystemType VARCHAR(255) = '-function',
	@wealthlinkDashboardPath VARCHAR(255) = 'administration.applicationsupport.wealthlink',
	@wealthlinkDashboardDescription VARCHAR(255) = 'Wealthlink Dashboard',
	
	@planApplicationIdentifier VARCHAR(255) = 'wealthlinkplanapplication',
	@planApplicationSystemType VARCHAR(255) = '+entity',
	@planApplicationPath VARCHAR(255) = 'wealthlinkplanapplication',
	@planApplicationDescription VARCHAR(255) = 'Wealthlink Plan Application',
	@planApplicationId INT,

	@planApplicationActionsIdentifier VARCHAR(255) = 'actions',
	@planApplicationActionsSystemType VARCHAR(255) = '+action',
	@planApplicationActionsPath VARCHAR(255) = 'wealthlinkplanapplication.actions',
	@planApplicationActionsDescription VARCHAR(255) = 'Actions:',
	@planApplicationActionsId INT,

	@resubmitIdentifier VARCHAR(255) = 'resubmit',
	@resubmitSystemType VARCHAR(255) = '+subaction',
	@resubmitPath VARCHAR(255) = 'wealthlinkplanapplication.actions.resubmit',
	@resubmitDescription VARCHAR(255) = 'Resubmit Plan Application',

	@viewrequestIdentifier VARCHAR(255) = 'viewrequestresponse',
	@viewrequestSystemType VARCHAR(255) = '+subaction',
	@viewrequestPath VARCHAR(255) = 'wealthlinkplanapplication.actions.viewrequestresponse',
	@viewrequestDescription VARCHAR(255) = 'View Request And Response'

BEGIN TRY

    BEGIN TRANSACTION

		SET @applicationSupportId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @applicationSupportPath)

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @wealthlinkDashboardPath)
        BEGIN

            INSERT INTO [dbo].[TSystem]
                ([Identifier],
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier],
				INSERTED.[Description],
				INSERTED.[SystemPath],
				INSERTED.[SystemType],
				INSERTED.[ParentId],
				INSERTED.[Url],
				INSERTED.[EntityId],
				INSERTED.[ConcurrencyId],
				INSERTED.[SystemId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier], 
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[Url],
				[EntityId],
				[ConcurrencyId],
				[SystemId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[Order])
            VALUES
                (@wealthlinkDashboardIdentifier,
				@wealthlinkDashboardDescription,
				@wealthlinkDashboardPath,
				@wealthlinkDashboardSystemType,
				@applicationSupportId,
				@ConcurrencyId)

        END

		IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @planApplicationPath)
        BEGIN

            INSERT INTO [dbo].[TSystem]
                ([Identifier],
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier],
				INSERTED.[Description],
				INSERTED.[SystemPath],
				INSERTED.[SystemType],
				INSERTED.[ParentId],
				INSERTED.[Url],
				INSERTED.[EntityId],
				INSERTED.[ConcurrencyId],
				INSERTED.[SystemId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier], 
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[Url],
				[EntityId],
				[ConcurrencyId],
				[SystemId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[Order])
            VALUES
                (@planApplicationIdentifier,
				@planApplicationDescription,
				@planApplicationPath,
				@planApplicationSystemType,
				null,
				@ConcurrencyId)

        END

		SET @planApplicationId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @planApplicationPath)

		IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @planApplicationActionsPath)
        BEGIN

			INSERT INTO [dbo].[TSystem]
                ([Identifier],
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier],
				INSERTED.[Description],
				INSERTED.[SystemPath],
				INSERTED.[SystemType],
				INSERTED.[ParentId],
				INSERTED.[Url],
				INSERTED.[EntityId],
				INSERTED.[ConcurrencyId],
				INSERTED.[SystemId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier], 
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[Url],
				[EntityId],
				[ConcurrencyId],
				[SystemId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[Order])
            VALUES
                (@planApplicationActionsIdentifier,
				@planApplicationActionsDescription,
				@planApplicationActionsPath,
				@planApplicationActionsSystemType,
				@planApplicationId,
				@ConcurrencyId)
            
        END

		SET @planApplicationActionsId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @planApplicationActionsPath)

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @resubmitPath)
        BEGIN

			INSERT INTO [dbo].[TSystem]
                ([Identifier],
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier],
				INSERTED.[Description],
				INSERTED.[SystemPath],
				INSERTED.[SystemType],
				INSERTED.[ParentId],
				INSERTED.[Url],
				INSERTED.[EntityId],
				INSERTED.[ConcurrencyId],
				INSERTED.[SystemId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier], 
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[Url],
				[EntityId],
				[ConcurrencyId],
				[SystemId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[Order])
            VALUES
                (@resubmitIdentifier,
				@resubmitDescription,
				@resubmitPath,
				@resubmitSystemType,
				@planApplicationActionsId,
				@ConcurrencyId)
            
        END

		IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @viewrequestPath)
        BEGIN

			INSERT INTO [dbo].[TSystem]
                ([Identifier],
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier],
				INSERTED.[Description],
				INSERTED.[SystemPath],
				INSERTED.[SystemType],
				INSERTED.[ParentId],
				INSERTED.[Url],
				INSERTED.[EntityId],
				INSERTED.[ConcurrencyId],
				INSERTED.[SystemId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier], 
				[Description],
				[SystemPath],
				[SystemType],
				[ParentId],
				[Url],
				[EntityId],
				[ConcurrencyId],
				[SystemId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[Order])
            VALUES
                (@viewrequestIdentifier,
				@viewrequestDescription,
				@viewrequestPath,
				@viewrequestSystemType,
				@planApplicationActionsId,
				@ConcurrencyId)
            
        END

        INSERT INTO [TExecutedDataScript] ([ScriptGUID], [Comments]) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;