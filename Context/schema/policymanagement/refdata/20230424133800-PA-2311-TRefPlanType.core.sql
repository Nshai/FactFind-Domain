USE [PolicyManagement];

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER = '1b70ec51-1ba1-480c-aa27-6060a3d7cc13'
    ,@Comments VARCHAR(255) = 'PA-2311 Set new column: IsTaxQualifying for US plan types only'
    ,@ErrorMessage VARCHAR(MAX) = NULL
    ,@StampAction CHAR(1) = 'U'
    ,@StampDateTime AS DATETIME = GETUTCDATE()
    ,@StampUser AS VARCHAR(255) = '0';

DECLARE @AuditId BIGINT;
SELECT @AuditId = MAX(AuditId) FROM dbo.TRefPlanTypeAudit;

IF EXISTS (SELECT 1 FROM dbo.TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

BEGIN TRANSACTION;

    -- Set 'IsTaxQualifying' column for US PlanTypes only.
    BEGIN TRY
        MERGE dbo.TRefPlanType AS tgt
        USING
        (
            VALUES
                (1086, 'Individual Taxable', 0)
                ,(1087, 'Joint Taxable', 0)
                ,(1088, 'Roth IRA', 1)
                ,(1089, 'Roth Rollover IRA', 1)
                ,(1090, 'Traditional IRA', 1)
                ,(1091, 'Traditional Rollover IRA', 1)
                ,(1092, 'Savings Account', 0)
                ,(1093, 'Checking Account', 0)
                ,(1095, 'Inherited IRA', 1)
                ,(1096, 'Inherited Roth IRA', 1)
                ,(1097, 'Trust Investment Account', 0)
                ,(1098, 'Custodian Investment Account', 0)
                ,(1099, 'Corporate Investment Account', 0)
                ,(1100, 'Non-Profit Investment Account', 1)
                ,(1101, 'Partnership Investment Account', 0)
                ,(1102, 'Estate Investment Account', 0)
                ,(1103, '403B Retirement Account', 1)
                ,(1104, 'Corporate Pension & Profit Sharing Plan', 1)
        ) AS src (RefPlanTypeId, PlanTypeName, IsTaxQualifying) ON src.RefPlanTypeId = tgt.RefPlanTypeId
        WHEN MATCHED THEN
            UPDATE SET IsTaxQualifying = src.IsTaxQualifying
        OUTPUT
            INSERTED.RefPlanTypeId
            ,INSERTED.PlanTypeName
            ,INSERTED.WebPage
            ,INSERTED.OrigoRef
            ,INSERTED.QuoteRef
            ,INSERTED.NBRef
            ,INSERTED.RetireFg
            ,INSERTED.RetireDate
            ,INSERTED.FindFg
            ,INSERTED.SchemeType
            ,INSERTED.IsWrapperFg
            ,INSERTED.AdditionalOwnersFg
            ,INSERTED.Extensible
            ,INSERTED.ConcurrencyId
            ,INSERTED.IsTaxQualifying
            ,@StampAction
            ,@StampDateTime
            ,@StampUser
        INTO dbo.TRefPlanTypeAudit
        (
            RefPlanTypeId
            ,PlanTypeName
            ,WebPage
            ,OrigoRef
            ,QuoteRef
            ,NBRef
            ,RetireFg
            ,RetireDate
            ,FindFg
            ,SchemeType
            ,IsWrapperFg
            ,AdditionalOwnersFg
            ,Extensible
            ,ConcurrencyId
            ,IsTaxQualifying
            ,StampAction
            ,StampDateTime
            ,StampUser
        );

    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        WHILE (@@TRANCOUNT > 0) 
            ROLLBACK TRANSACTION;
        RETURN;
    END CATCH

    INSERT dbo.TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments);

COMMIT TRANSACTION;

IF (@@TRANCOUNT > 0)
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Open transaction found, aborting';
    RETURN;
END

RETURN;
