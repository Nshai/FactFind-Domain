USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      

SELECT
    @ScriptGUID = 'f41a817c-737c-4143-ace4-5eee6b7500ad',
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
		DECLARE @Fatherinlaw INT = 1005
		DECLARE @GrandFather INT = 1006
		DECLARE @GrandMother INT = 1007
		DECLARE @GrandDaughter INT = 1008
		DECLARE @GrandSon INT = 1009
		DECLARE @Mother INT = 1010
		DECLARE @MotherInLaw INT = 1011
		DECLARE @Nephew INT = 1012
		DECLARE @Niece INT = 1013
		DECLARE @Sister INT = 1014
        DECLARE @Son INT = 1015
		DECLARE @NonSpouseOther INT = 1016
	    DECLARE @Spouse INT = 1017

		DECLARE @RelationshipTypes TABLE(Id INT, [Name] NVARCHAR(100))

		INSERT INTO @RelationshipTypes
			VALUES (@Brother, 'Brother')
			,(@Daughter, 'Daughter')
            ,(@DomesticPartner, 'Domestic Partner')
			,(@Father, 'Father')
			,(@Fatherinlaw, 'Father in law')
			,(@GrandFather, 'Grandfather')
		    ,(@GrandMother, 'Grandmother')
            ,(@GrandDaughter, 'Granddaughter')
            ,(@GrandSon, 'Grandson')
		    ,(@Mother, 'Mother')
	        ,(@MotherInLaw, 'Mother in law')
            ,(@Nephew, 'Nephew')
            ,(@Niece, 'Niece')
		    ,(@Sister, 'Sister')
            ,(@Son, 'Son')
		    ,(@NonSpouseOther, 'Non-spouse / Other')
			,(@OtherIndividual, 'Other Individual')
			,(@Spouse, 'Spouse')

		-- insert US relationship types
        SET IDENTITY_INSERT TRefRelationshipType ON; 
 
        INSERT INTO TRefRelationshipType(RefRelationshipTypeId, RelationshipTypeName, ArchiveFg, PersonFg,CorporateFg,TrustFg, AccountFg, Extensible, ConcurrencyId)
		SELECT t.Id,t.[Name],0,1,0,0,0,NULL,1
		FROM @RelationshipTypes t
			
        SET IDENTITY_INSERT TRefRelationshipType OFF

		
		-- insert US relationship type links
        INSERT INTO TRefRelationshipTypeLink([RefRelTypeId],[RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
        VALUES
		 (@OtherIndividual, @Brother, NULL, 1)
		,(@Sister, @Brother, NULL, 1)
		,(@Brother, @Brother, NULL, 1)
		
		,(@OtherIndividual, @Daughter, NULL, 1)		
		,(@Father, @Daughter, NULL, 1)
		,(@Mother, @Daughter, NULL, 1)
		
		,(@DomesticPartner, @DomesticPartner, NULL, 1)

		,(@OtherIndividual, @Father, NULL, 1)
		,(@Son, @Father, NULL, 1)
		,(@Daughter, @Father, NULL, 1)

		,(@OtherIndividual, @GrandFather, NULL, 1)		
		,(@GrandDaughter, @GrandFather, NULL, 1)
		,(@GrandSon, @GrandFather, NULL, 1)

		,(@OtherIndividual, @GrandMother, NULL, 1)		
		,(@GrandDaughter, @GrandMother, NULL, 1)
		,(@GrandSon, @GrandMother, NULL, 1)

		,(@OtherIndividual, @GrandDaughter, NULL, 1)		
		,(@GrandFather, @GrandDaughter, NULL, 1)
		,(@GrandMother, @GrandDaughter, NULL, 1)

		,(@OtherIndividual, @GrandSon, NULL, 1)		
		,(@GrandFather, @GrandSon, NULL, 1)
		,(@GrandMother, @GrandSon, NULL, 1)

		,(@OtherIndividual, @Mother, NULL, 1)	
		,(@Son, @Mother, NULL, 1)
		,(@Daughter, @Mother, NULL, 1)

		,(@OtherIndividual, @Sister, NULL, 1)		
		,(@Brother, @Sister, NULL, 1)
		,(@Sister, @Sister, NULL, 1)

		,(@OtherIndividual, @Son, NULL, 1)	
		,(@Father, @Son, NULL, 1)
		,(@Mother, @Son, NULL, 1)

		,(@Spouse, @Spouse, NULL, 1)		
		
		,(@OtherIndividual, @OtherIndividual, NULL, 1)
		,(@Fatherinlaw, @OtherIndividual, NULL, 1)
		,(@MotherInLaw, @OtherIndividual, NULL, 1)
		,(@NonSpouseOther, @OtherIndividual, NULL, 1)
		,(@Niece, @OtherIndividual, NULL, 1)
		,(@Nephew, @OtherIndividual, NULL, 1)		
		
		,(@OtherIndividual, @Fatherinlaw, NULL, 1)
		,(@OtherIndividual, @MotherInLaw, NULL, 1)
		,(@OtherIndividual, @Nephew, NULL, 1)
		,(@OtherIndividual, @Niece, NULL, 1)
		,(@OtherIndividual, @NonSpouseOther, NULL, 1)
		
		

		-- upate all non-US relationships to spouse/spouse (1017) (doesn't take into account party type)
		UPDATE R
		SET RefRelTypeId = CASE WHEN T1.Id IS NULL THEN @Spouse ELSE R.RefRelTypeId END,
			RefRelCorrespondTypeId = CASE WHEN T2.Id IS NULL THEN @Spouse ELSE R.RefRelCorrespondTypeId END
		FROM TRelationship R
		LEFT JOIN @RelationshipTypes T1 ON T1.Id = r.RefRelTypeId
		LEFT JOIN @RelationshipTypes T2 ON T2.Id = r.RefRelCorrespondTypeId
		WHERE T1.Id IS NULL 
			OR T2.Id IS NULL 

		-- delete non-US relationship type links
		DELETE lnk 
		FROM TRefRelationshipTypeLink lnk
		LEFT JOIN @RelationshipTypes t1 on t1.Id = lnk.RefRelTypeId
		LEFT JOIN @RelationshipTypes t2 on t2.Id = lnk.RefRelCorrespondTypeId
		WHERE t1.Id IS NULL
			OR t2.Id IS NULL

		-- delete non-US relationship types
		DELETE rrt 
		FROM TRefRelationshipType rrt 
		LEFT JOIN @RelationshipTypes t on t.Id = rrt.RefRelationshipTypeId
		WHERE t.Id IS NULL

		    
		-- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'f41a817c-737c-4143-ace4-5eee6b7500ad', 
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