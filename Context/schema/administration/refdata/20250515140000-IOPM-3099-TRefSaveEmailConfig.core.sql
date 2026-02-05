USE Administration ;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
/*
Summary
Insert data into TRefSaveEmailConfig
DatabaseName         TableName                   Expected Rows
administration       TRefSaveEmailConfig         2
*/
SELECT 
    @ScriptGUID = '0DBCC2BA-5764-48B3-9B53-9F765A6561AC',
    @Comments = 'IOPM-3099 Add new column in table  TTenantEmailConfig and Ref data'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    SET IDENTITY_INSERT [dbo].[TRefSaveEmailConfig] ON

    INSERT INTO [dbo].[TRefSaveEmailConfig] ([RefSaveEmailConfigId], [SaveEmailConfigName], [ConcurrencyId]) VALUES (1, 'Email activity only', 1)
    INSERT INTO [dbo].[TRefSaveEmailConfig] ([RefSaveEmailConfigId], [SaveEmailConfigName], [ConcurrencyId]) VALUES (2, 'Email activity and a Document', 1)

    SET IDENTITY_INSERT [dbo].[TRefSaveEmailConfig] OFF
    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    COMMIT TRANSACTION
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;