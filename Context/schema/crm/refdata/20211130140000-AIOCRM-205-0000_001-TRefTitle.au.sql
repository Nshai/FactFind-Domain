USE [crm]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '2EF747B7-6419-4278-BA55-B658E2AEAF0A',
    @Comments = 'AIOCRM-205 Title field localization'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN

BEGIN TRANSACTION

    BEGIN TRY
        SET IDENTITY_INSERT TRefTitle ON

        INSERT INTO
            TRefTitle
            (
                RefTitleId,
                TitleName
            )
        OUTPUT
            INSERTED.TitleName,
            INSERTED.ConcurrencyId,
            INSERTED.RefTitleId,
            'C',
            GETDATE(),
            '0'
        INTO
            TRefTitleAudit
            (
                TitleName,
                ConcurrencyId,
                RefTitleId,
                StampAction,
                StampDateTime,
                StampUser
            )
        SELECT 1, 'Unspecified' UNION ALL
        SELECT 2, 'Mr' UNION ALL
        SELECT 3, 'Mrs' UNION ALL
        SELECT 4, 'Miss' UNION ALL
        SELECT 5, 'Ms' UNION ALL
        SELECT 6, 'Dr' UNION ALL
        SELECT 7, 'Prof' UNION ALL
        SELECT 8, 'Master' UNION ALL
        SELECT 9, 'Count' UNION ALL
        SELECT 10, 'Countess' UNION ALL
        SELECT 11, 'Dame' UNION ALL
        SELECT 12, 'Lady' UNION ALL
        SELECT 13, 'Lord' UNION ALL
        SELECT 14, 'Baron' UNION ALL
        SELECT 15, 'Bishop' UNION ALL
        SELECT 16, 'Canon' UNION ALL
        SELECT 17, 'Fr' UNION ALL
        SELECT 18, 'Pastor' UNION ALL
        SELECT 19, 'Rev' UNION ALL
        SELECT 20, 'Right Reverend' UNION ALL
        SELECT 21, 'Sister' UNION ALL
        SELECT 22, 'Venerable' UNION ALL
        SELECT 23, 'Very Reverend' UNION ALL
        SELECT 24, 'The Honourable' UNION ALL
        SELECT 25, 'Justice' UNION ALL
        SELECT 26, 'Right Honourable' UNION ALL
        SELECT 27, 'Right Honourable Lord' UNION ALL
        SELECT 28, 'Sheriff' UNION ALL
        SELECT 29, 'Brigadier' UNION ALL
        SELECT 30, 'Captain' UNION ALL
        SELECT 40, 'Colonel' UNION ALL
        SELECT 41, 'Commander' UNION ALL
        SELECT 42, 'Lieutenant' UNION ALL
        SELECT 43, 'Lieutenant Colonel' UNION ALL
        SELECT 44, 'Lieutenant Commander' UNION ALL
        SELECT 45, 'Major' UNION ALL
        SELECT 46, 'Major General' UNION ALL
        SELECT 47, 'Squadron Leader' UNION ALL
        SELECT 48, 'Wing Commander' UNION ALL
        SELECT 49, 'Admiral' UNION ALL
        SELECT 50, 'Air Commodore' UNION ALL
        SELECT 51, 'Air Vice Marshall' UNION ALL
        SELECT 52, 'Baroness' UNION ALL
        SELECT 53, 'Commodore' UNION ALL
        SELECT 54, 'Deacon' UNION ALL
        SELECT 55, 'Deaconess' UNION ALL
        SELECT 56, 'Group Captain' UNION ALL
        SELECT 57, 'Reverend Doctor' UNION ALL
        SELECT 58, 'Surgeon Captain' UNION ALL
        SELECT 59, 'Archdeacon' UNION ALL
        SELECT 60, 'Corporal' UNION ALL
        SELECT 61, 'Flight Lieutenant' UNION ALL
        SELECT 62, 'Lance Corporal' UNION ALL
        SELECT 63, 'Madam' UNION ALL
        SELECT 64, 'Monsignor' UNION ALL
        SELECT 65, 'Prince' UNION ALL
        SELECT 66, 'Princess' UNION ALL
        SELECT 67, 'Private' UNION ALL
        SELECT 68, 'Sir' UNION ALL
        SELECT 69, 'Rear Admiral' UNION ALL
        SELECT 70, 'Staff Sergeant' UNION ALL
        SELECT 71, 'Not Disclosed' UNION ALL
        SELECT 72, 'The Earl of' UNION ALL
        SELECT 73, 'The Reverend Canon' UNION ALL
        SELECT 74, 'Trooper' UNION ALL
        SELECT 75, 'Viscount' UNION ALL
        SELECT 76, 'Viscountess' UNION ALL
        SELECT 77, 'Second Lieutenant' UNION ALL
        SELECT 78, 'Sergeant' UNION ALL
        SELECT 79, 'Rabbi' UNION ALL
        SELECT 80, 'Duchess' UNION ALL
        SELECT 81, 'Mx' UNION ALL
        SELECT 82, 'Estate of the late'

        SET IDENTITY_INSERT TRefTitle OFF

    END TRY
    BEGIN CATCH

        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0) ROLLBACK
        RETURN

    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

COMMIT TRANSACTION

IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Opened transaction found, aborting'
END

RETURN
