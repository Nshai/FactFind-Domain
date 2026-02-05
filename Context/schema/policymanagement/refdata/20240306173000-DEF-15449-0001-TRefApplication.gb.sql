USE policymanagement

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

/*
Summary
****************************************************
Update Name and shortName for Aegon NBS integration in [TRefApplication] table.

DatabaseName        TableName               Expected Rows
************************************************************
PolicyManagement    TRefApplication          1
*/

SELECT 
    @ScriptGUID = '2B4CB868-7414-4AEB-BA27-D660A20EDEB9', 
    @Comments = 'DEF-15449 Portal Name in event history is incorrect'  

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE 
    @StampUser varchar(1) = '0',
    @StampAction varchar(1) = 'U',
    @StampDateTime datetime = GETDATE()

BEGIN TRY
	BEGIN TRANSACTION

		UPDATE dbo.TRefApplication
		SET ApplicationName = 'Aegon AFP',
            ApplicationShortName ='AFP'
        Output 
            deleted.ApplicationName, 
            deleted.ApplicationShortName, 
            deleted.RefApplicationTypeId, 
            deleted.ImageName, 
        	deleted.IsArchived, 
            deleted.ConcurrencyId, 
        	deleted.RefApplicationId, 
            @StampAction, 
            @StampDateTime, 
            @StampUser
        INTO TRefApplicationAudit (
            ApplicationName, 
            ApplicationShortName, 
            RefApplicationTypeId, 
            ImageName, 
		    IsArchived, 
            ConcurrencyId, 
            RefApplicationId, 
            StampAction, 
            StampDateTime, 
            StampUser)
		WHERE ApplicationName = 'Aegon NBS'

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