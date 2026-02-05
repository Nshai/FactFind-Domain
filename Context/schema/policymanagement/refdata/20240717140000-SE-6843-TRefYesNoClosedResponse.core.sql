USE PolicyManagement ;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
/*
Summary
Insert data into TRefYesNoClosedResponse
DatabaseName         TableName                   Expected Rows
PolicyManagement     TRefYesNoClosedResponse     3
*/
SELECT 
    @ScriptGUID = 'FB42FB5B-711C-4237-A55F-4C7E2F653CE7',
    @Comments = 'SE-6843 Add Closed to Plan Level Target Market Dropdown'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    SET IDENTITY_INSERT [dbo].[TRefYesNoClosedResponse] ON
    INSERT INTO [dbo].[TRefYesNoClosedResponse] ([RefYesNoClosedResponseId], [Name], [ConcurrencyId]) VALUES (0, 'No', 1)
    INSERT INTO [dbo].[TRefYesNoClosedResponse] ([RefYesNoClosedResponseId], [Name], [ConcurrencyId]) VALUES (1, 'Yes', 1)
    INSERT INTO [dbo].[TRefYesNoClosedResponse] ([RefYesNoClosedResponseId], [Name], [ConcurrencyId]) VALUES (2, 'Closed', 1)
    SET IDENTITY_INSERT [dbo].[TRefYesNoClosedResponse] OFF
    
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