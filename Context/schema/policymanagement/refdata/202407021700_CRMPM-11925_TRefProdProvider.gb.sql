USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)

/*
Summary
CRMPM-11925 - Migrate actual BIC identifiers to column DTCCIdentifier

DatabaseName        TableName            Expected Rows
PolicyManagement    TRefProdProvider     14
*/

SELECT
    @ScriptGUID = '14DA6E2B-D698-43E2-82E9-C91C3A357D25',
    @Comments = 'CRMPM-11925 - Migrate actual BIC identifiers to column DTCCIdentifier'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

IF OBJECT_ID('tempdb..#ProdProvidersToUpdate') IS NOT NULL
    DROP TABLE #ProdProvidersToUpdate

CREATE TABLE #ProdProvidersToUpdate (
    CorporateName NVARCHAR(255),
    DTCCIdentifier NVARCHAR(255)
);

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    INSERT INTO #ProdProvidersToUpdate (CorporateName, DTCCIdentifier)
    VALUES
    ('Aviva', 'NWBKGB2L'),
    ('Hawksmoor Investment Management Ltd', 'ALUSGB21HIM'),
    ('IFSL (Investment Fund Services Ltd)', 'CLAOGB2LIFL'),
    ('Liverpool Victoria', 'LVFSGB21'),
    ('Liverpool Victoria Portfolio Managers Limited', 'LVFSGB21'),
    ('Liverpool Victoria Retirement Solutions', 'LVFSGB21'),
    ('Mattioli Woods', 'ALUSGB21'),
    ('Premier Portfolio Management Limited', 'CLAOGB2LPPF'),
    ('Quilter Cheviot Limited', 'CLAOGB2LTQC'),
    ('RBC Brewin Dolphin', 'ALUSGB21BRE'),
    ('Standard Life', 'ALUSGB21AAC'),
    ('Transact', 'CLAOGB2LTRA'),
    ('Rathbones', 'RAIAGB21'),
    ('Aviva Platform', 'NWBKGB2L')

    UPDATE RPP
    SET RPP.DTCCIdentifier = PPTU.DTCCIdentifier
    FROM TRefProdProvider RPP
        JOIN crm.dbo.TCRMContact CC
            ON CC.CRMContactId = RPP.CRMContactId
        INNER JOIN #ProdProvidersToUpdate PPTU
            ON CC.CorporateName = PPTU.CorporateName

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

    IF OBJECT_ID('tempdb..#ProdProvidersToUpdate') IS NOT NULL
        DROP TABLE #ProdProvidersToUpdate

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

    IF OBJECT_ID('tempdb..#ProdProvidersToUpdate') IS NOT NULL
        DROP TABLE #ProdProvidersToUpdate

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;
