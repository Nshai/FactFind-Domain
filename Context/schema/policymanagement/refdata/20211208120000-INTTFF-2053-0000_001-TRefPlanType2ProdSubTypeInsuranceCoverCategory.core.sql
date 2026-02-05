USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'F85B8A43-7F35-48A8-93BF-220225E258BD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
 
        INSERT INTO [TRefPlanType2ProdSubTypeInsuranceCoverCategory]([RefPlanType2ProdSubTypeId], [RefInsuranceCoverCategoryId])
		VALUES 
	        -- GB
			(98,1),
			(99,1),
			(1058,1),

			(98,2),			
			(100,2),
			(1058,2),
			(1073,7),
			(1106,7),
			(1107,7),
			(1108,7),
			(1133,7),

			(1076,9),

			(127,4),
			(1075,4),
			(1132,4),

			(128,3),

			(57,6),
			(62,6),
			(115,6),
			(133,6),
			(134,6),
			(135,6),
			(146,6),
			(1037,6),

			-- AU
			(1191,	1),
			(1192,	1),

			(1192,	2),
			(1194,	2),

			(1198,	3),
			
			(1193, 4),
			(1196, 4),
			
			(1171, 6),
			(1161, 6),
			(1162, 6),
			(1163, 6),

			(1197,	7),

			(1195,	9)
        
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'F85B8A43-7F35-48A8-93BF-220225E258BD', 
         'Initial load for table TRefPlanType2ProdSubTypeInsuranceCoverCategory',
         null, 
         getdate() )
 
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
