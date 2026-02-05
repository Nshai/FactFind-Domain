USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)


SELECT
    @ScriptGUID = 'A01FCE1A-AB59-403E-BB9D-B2A5DFA9EDD9',
    @Comments = 'AIOCI-154 Additional relationships for US environments'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Relationships - Add New Relations
-- Expected row affected: 11(TRefRelationshipType) + 12 (TRefRelationshipTypeLink)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
        BEGIN TRANSACTION

		DECLARE @Entity INT = 1021
		DECLARE @GrantorPerson INT = 1022
		DECLARE @GrantorTrust INT = 1031
		DECLARE @OfficerPerson INT = 1025
		DECLARE @OfficerCorporate INT = 1032
		DECLARE @PartnerPerson INT = 1026
		DECLARE @PartnerCorporate INT = 1033
		DECLARE @Partnership INT = 1027
		DECLARE @PowerOfAttorneyPerson INT = 1028
		DECLARE @PowerOfAttorneyTrust INT = 1034
		DECLARE @Trust INT = 1029
		DECLARE @TrusteePerson INT = 1030
		DECLARE @TrusteeCorporate INT = 1035
		DECLARE @TrusteeTrust INT = 1036

		DECLARE @RelationshipTypes TABLE(Id INT, [Name] NVARCHAR(100), PersonFg TINYINT, CorporateFg TINYINT, TrustFg TINYINT)

		INSERT INTO @RelationshipTypes
			VALUES (@GrantorTrust, 'Grantor', 0, 0, 1)
				,(@OfficerCorporate, 'Officer', 0, 1, 0)
				,(@PartnerCorporate, 'Partner', 0, 1, 0)
				,(@PowerOfAttorneyTrust, 'Power of Attorney', 0, 0, 1)
				,(@TrusteeCorporate, 'Trustee', 0, 1, 0)
				,(@TrusteeTrust, 'Trustee', 0, 0, 1)

		-- insert US relationship types
        SET IDENTITY_INSERT TRefRelationshipType ON; 

        INSERT INTO TRefRelationshipType(RefRelationshipTypeId, RelationshipTypeName, ArchiveFg, PersonFg,CorporateFg,TrustFg, AccountFg, Extensible, ConcurrencyId)
		SELECT t.Id,t.[Name],0,t.PersonFg,t.CorporateFg,t.TrustFg,0,NULL,1
		FROM @RelationshipTypes t

        SET IDENTITY_INSERT TRefRelationshipType OFF

        --update US relationship types
        UPDATE TRefRelationshipType
        SET TrustFg = 0
        WHERE RefRelationshipTypeId = @GrantorPerson OR RefRelationshipTypeId = @PowerOfAttorneyPerson

        UPDATE TRefRelationshipType
        SET CorporateFg = 0
        WHERE RefRelationshipTypeId = @OfficerPerson OR RefRelationshipTypeId = @PartnerPerson

        UPDATE TRefRelationshipType
        SET TrustFg = 0, 
            CorporateFg = 0
        WHERE RefRelationshipTypeId = @TrusteePerson


        -- insert US relationship type links
        INSERT INTO TRefRelationshipTypeLink([RefRelTypeId],[RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
        VALUES
		(@OfficerCorporate, @Entity, NULL, 1)

		,(@PartnerCorporate, @Partnership, NULL, 1)

		,(@GrantorTrust, @Trust, NULL, 1)
		,(@TrusteeCorporate, @Trust, NULL, 1)
		,(@TrusteeTrust, @Trust, NULL, 1)
		,(@PowerOfAttorneyTrust, @Trust, NULL, 1)

		,(@Entity, @OfficerCorporate, NULL, 1)

		,(@Trust, @PowerOfAttorneyTrust, NULL, 1)
		
		,(@Partnership, @PartnerCorporate, NULL, 1)

		,(@Trust, @GrantorTrust, NULL, 1)
		,(@Trust, @TrusteeCorporate, NULL, 1)
		,(@Trust, @TrusteeTrust, NULL, 1)


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