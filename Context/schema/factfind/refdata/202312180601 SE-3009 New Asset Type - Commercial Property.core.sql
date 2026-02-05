USE FACTFIND;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Add a new Asset category in GB/AU/US regions.
DatabaseName        TableName                       Expected Rows
Factfind			dbo.TAssetCategory					1
*/

SELECT 
    @ScriptGUID = 'F0C53FE1-C005-433A-BE7F-FB1424687646', 
    @Comments = 'SE-3099 New Asset Type - Commercial Property' 


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

        IF NOT EXISTS(SELECT * FROM FACTFIND.dbo.TAssetCategory WHERE AssetCategoryId=17 and CategoryName = 'Commercial Property')

        BEGIN

        BEGIN TRANSACTION

        SET IDENTITY_INSERT TAssetCategory ON

            INSERT dbo.TAssetCategory
                    ([AssetCategoryId]
                    ,[CategoryName]
                    ,[SectorName]
                    ,[IndigoClientId]
                    ,[ConcurrencyId])
           OUTPUT
                     inserted.[AssetCategoryId]
                    ,inserted.[CategoryName]
                    ,inserted.[SectorName]
                    ,inserted.[IndigoClientId]
                    ,inserted.[ConcurrencyId]
                    ,'C'
                    ,GETUTCDATE()
                    ,'0'
           INTO [dbo].[TAssetCategoryAudit]
                     ([AssetCategoryId]
                    ,[CategoryName]
                    ,[SectorName]
                    ,[IndigoClientId]
                    ,[ConcurrencyId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
           VALUES   (17
                    ,'Commercial Property'
                    ,'Property'
                    ,0
                    ,1);

              SET IDENTITY_INSERT TAssetCategory OFF

           INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)


        COMMIT TRANSACTION
       END

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;

