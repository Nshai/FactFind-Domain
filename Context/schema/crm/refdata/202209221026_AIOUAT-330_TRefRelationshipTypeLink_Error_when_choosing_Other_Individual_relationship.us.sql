USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      

SELECT
    @ScriptGUID = 'f41a817c-737c-4143-ace4-5eee6b7510ad',
    @Comments = 'APN-3272  regionalise relationships for US environments'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Relationships - Add New Relations
-- Expected row affected: 17(TRefRelationshipType) + 22 (TRefRelationshipTypeLink)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
        BEGIN TRANSACTION

		DECLARE @OtherIndividual INT = 1000  		
		DECLARE @Brother INT = 1001
		DECLARE @Daughter INT = 1002
		DECLARE @DomesticPartner INT = 1003
		DECLARE @Father INT = 1004
		DECLARE @GrandFather INT = 1006
		DECLARE @GrandMother INT = 1007
		DECLARE @GrandDaughter INT = 1008
		DECLARE @GrandSon INT = 1009
		DECLARE @Mother INT = 1010
		DECLARE @Sister INT = 1014
        DECLARE @Son INT = 1015
				
		declare @RefLink1 int = (select l.RefRelationshipTypeLinkId
		from TRefRelationshipTypeLink l
		where l.RefRelTypeId = @OtherIndividual and l.RefRelCorrespondTypeId = @Brother)

		declare @RefLink2 int = (select l.RefRelationshipTypeLinkId
		from TRefRelationshipTypeLink l
		where l.RefRelTypeId = @OtherIndividual and l.RefRelCorrespondTypeId = @OtherIndividual)

		update l
		set RefRelCorrespondTypeId = @OtherIndividual
		from TRefRelationshipTypeLink l
		where l.RefRelationshipTypeLinkId = @RefLink1

		update l
		set RefRelCorrespondTypeId = @Brother
		from TRefRelationshipTypeLink l
		where l.RefRelationshipTypeLinkId = @RefLink2

		-- insert US relationship type links
        INSERT INTO TRefRelationshipTypeLink([RefRelTypeId],[RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
        VALUES

		(@Brother, @OtherIndividual, NULL, 1)
		,(@Daughter, @OtherIndividual, NULL, 1)
		,(@DomesticPartner, @OtherIndividual, NULL, 1)
		,(@Father, @OtherIndividual, NULL, 1)
		,(@GrandFather, @OtherIndividual, NULL, 1)
		,(@GrandMother, @OtherIndividual, NULL, 1)
		,(@GrandDaughter, @OtherIndividual, NULL, 1)
		,(@GrandSon, @OtherIndividual, NULL, 1)
		,(@Mother, @OtherIndividual, NULL, 1)
		,(@Sister, @OtherIndividual, NULL, 1)
		,(@Son, @OtherIndividual, NULL, 1)
		    
		-- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
        @ScriptGUID, 
         @Comments,
         null, 
         getdate() )
		 
		 
		COMMIT TRANSACTION
	 
END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT
	
       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY    */

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;