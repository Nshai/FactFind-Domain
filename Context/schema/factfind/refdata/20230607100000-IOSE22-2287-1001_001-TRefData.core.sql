USE [factfind]

IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DD340948-11FA-457F-B027-E6F1E175FD48'
) RETURN 

SET NOCOUNT ON 
SET XACT_ABORT ON

DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- insert the records
        SET IDENTITY_INSERT TRefData ON; 

		INSERT INTO TRefData (RefDataId, [Name],[Type],[Property],[RegionCode],[Attributes])
			OUTPUT 
				inserted.RefDataId,
				inserted.Name,
				inserted.Type,
				inserted.Property,
				inserted.RegionCode,
				inserted.Attributes,
				inserted.TenantId,
				'C',
				GETUTCDATE(),
				0
			INTO
				TRefDataAudit
				(
					RefDataId,
					[Name],
					[Type],
					Property,
					RegionCode,
					Attributes,
					TenantId,
					StampAction,
					StampDateTime,
					StampUser
				)
			VALUES 
				(106,'Share of Company Profit','income','category','US','{\"party_types\":\"Person\",\"ordinal\":\"2\"}'),
				(107,'Share of Company Profit','income','category','GB','{\"party_types\":\"Person\",\"ordinal\":\"2\"}'),
				(108,'Share of Company Profit','income','category','AU','{\"party_types\":\"Person\",\"ordinal\":\"2\"}')

		 SET IDENTITY_INSERT TRefData OFF

		 INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
			 VALUES (
				 'DD340948-11FA-457F-B027-E6F1E175FD48', 
				 'Adding new Income type to the table TRefData',
				 null, 
				 GETUTCDATE() 
			 )

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