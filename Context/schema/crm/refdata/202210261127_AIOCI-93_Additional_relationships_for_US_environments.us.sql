USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      

SELECT
    @ScriptGUID = '50eb8244-cf63-44ef-b061-3cc5ea2b3158',
    @Comments = 'AIOCI-93 Additional relationships for US environments'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Relationships - Add New Relations
-- Expected row affected: 12(TRefRelationshipType) + 18 (TRefRelationshipTypeLink)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
        BEGIN TRANSACTION
		
		DECLARE @AccountHolder INT = 1018
		DECLARE @Custodian INT = 1019
		DECLARE @Entity INT = 1021
		DECLARE @Grantor INT = 1022
		DECLARE @Guardian INT = 1023
		DECLARE @Minor INT = 1024
		DECLARE @Officer INT = 1025
		DECLARE @Partner INT = 1026
		DECLARE @Partnership INT = 1027
        DECLARE @PowerOfAttorney INT = 1028
		DECLARE @Trust INT = 1029
	    DECLARE @Trustee INT = 1030

		DECLARE @RelationshipTypes TABLE(Id INT, [Name] NVARCHAR(100), PersonFg TINYINT, CorporateFg TINYINT, TrustFg TINYINT)

		INSERT INTO @RelationshipTypes
			VALUES (@AccountHolder, 'Account Holder', 1, 0, 0)
				,(@Custodian, 'Custodian', 1, 0, 0)
				,(@Entity, 'Entity', 0, 1, 0)
				,(@Grantor, 'Grantor', 1, 0, 1)
				,(@Guardian, 'Guardian', 1, 0, 0)
				,(@Minor, 'Minor', 1, 0, 0)
				,(@Officer, 'Officer', 1, 1, 0)
				,(@Partner, 'Partner', 1, 1, 0)
				,(@Partnership, 'Partnership', 0, 1, 0)
				,(@PowerOfAttorney, 'Power of Attorney', 1, 0, 1)
				,(@Trust, 'Trust', 0, 0, 1)
				,(@Trustee, 'Trustee', 1, 1, 1)

		-- insert US relationship types
        SET IDENTITY_INSERT TRefRelationshipType ON; 
 
        INSERT INTO TRefRelationshipType(RefRelationshipTypeId, RelationshipTypeName, ArchiveFg, PersonFg,CorporateFg,TrustFg, AccountFg, Extensible, ConcurrencyId)
		SELECT t.Id,t.[Name],0,t.PersonFg,t.CorporateFg,t.TrustFg,0,NULL,1
		FROM @RelationshipTypes t
			
        SET IDENTITY_INSERT TRefRelationshipType OFF

		
		-- insert US relationship type links
        INSERT INTO TRefRelationshipTypeLink([RefRelTypeId],[RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
        VALUES
		(@AccountHolder, @AccountHolder, NULL, 1)
		,(@PowerOfAttorney, @AccountHolder, NULL, 1)
		,(@Guardian, @AccountHolder, NULL, 1)
		
		,(@Officer, @Entity, NULL, 1)
		
		,(@Guardian, @Minor, NULL, 1)
		,(@Custodian, @Minor, NULL, 1)
		
		,(@Partner, @Partnership, NULL, 1)
		
		,(@Grantor, @Trust, NULL, 1)		
		,(@Trustee, @Trust, NULL, 1)
		,(@PowerOfAttorney, @Trust, NULL, 1)
		
		,(@AccountHolder, @Guardian, NULL, 1)
		,(@Minor, @Guardian, NULL, 1)
				
		,(@Entity, @Officer, NULL, 1)
		
		,(@AccountHolder, @PowerOfAttorney, NULL, 1)
		,(@Trust, @PowerOfAttorney, NULL, 1)
		
		,(@Minor, @Custodian, NULL, 1)
		
		,(@Partnership, @Partner, NULL, 1)
		
		,(@Trust, @Grantor, NULL, 1)
		
		,(@Trust, @Trustee, NULL, 1)
		
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

       RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, '', @ErrorLine, @ErrorMessage);

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;