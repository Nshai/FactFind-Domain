USE policymanagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

/*
Summary
-----------------------------------------------------------------------------------------------
Archive Whole of life product type
DatabaseName        TableName               Expected Rows
-----------------------------------------------------------------------------------------------
PolicyManagement    TRefPlanType2ProdSubType          1
*/

SELECT
    @ScriptGUID = '88E9E520-C9CD-4E79-9BD5-502BE216046B',
    @Comments = 'SE-9866 Archive Whole of life product type.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
BEGIN TRANSACTION

DECLARE
    @StampActionUpdate CHAR(1) = 'U',
    @StampActionCreate CHAR(1) = 'C',
    @StampDateTime DATETIME = getdate(),
    @StampUserSystem CHAR(1) = '0',
    @ProductType INT = 54

    UPDATE TRefPlanType2ProdSubType
        SET [IsArchived] = 1
    OUTPUT
        deleted.RefPlanTypeId,
        deleted.ProdSubTypeId,
        deleted.RefPortfolioCategoryId,
        deleted.RefPlanDiscriminatorId,
        deleted.DefaultCategory,
        deleted.ConcurrencyId,
        deleted.RefPlanType2ProdSubTypeId,
        @StampActionUpdate,
        @StampDateTime,
        @StampUserSystem,
        deleted.IsArchived,
        deleted.IsConsumerFriendly,
        deleted.RegionCode
    INTO TRefPlanType2ProdSubTypeAudit
        ( RefPlanTypeId,
        ProdSubTypeId,
        RefPortfolioCategoryId,
        RefPlanDiscriminatorId,
        DefaultCategory,
        ConcurrencyId,
        RefPlanType2ProdSubTypeId,
        StampAction,
        StampDateTime,
        StampUser,
        IsArchived,
        IsConsumerFriendly,
        RegionCode)
    WHERE RefPlanType2ProdSubTypeId = @ProductType

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