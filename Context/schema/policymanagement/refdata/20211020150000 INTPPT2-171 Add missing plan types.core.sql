USE policymanagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	, @Comments VARCHAR(255)
	, @ErrorMessage VARCHAR(MAX)

SELECT
	@ScriptGUID = '32239D61-CEE4-4BF5-BD9A-4FC5912CD9B6',
	@Comments = 'INTPPT2-171 Add missing AU plan types'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

-----------------------------------------------------------------------------------------------
-- Summary: INTPPT2-171 Implement script to create missing "Personal Insurance" AU plan types

--Personal Insurance (Life & IP)
--Personal Insurance (Life, Trauma & IP)
--Personal Insurance (TPD & IP)
--Personal Insurance (TPD, Trauma & IP)
--Personal Insurance (Trauma & IP)

-- Expected row counts: ~30 
-----------------------------------------------------------------------------------------------

DECLARE @starttrancount int
       ,@PersonalInsurancePlanTypeId INT = 1068
       ,@PortfolioCategoryProtectionId INT = 3 
       ,@PlanDiscriminatorId INT = 10
       ,@RegionCode VARCHAR(2) = 'AU'
       ,@DefaultCategory varchar(255) = 'Non-Investment Insurance'
       ,@RefPlanType2ProdSubTypeIds VARCHAR(100) = '1225,1226,1227,1228,1229'
       ,@FactFindSection varchar(255) = 'Protection'
       ,@SchemeType int = 1
       ,@ArchiveFg bit = 0
       ,@StampActionCreate CHAR(1) = 'C'
       ,@StampActionUpdate CHAR(1) = 'D'
       ,@StampActionDelete CHAR(1) = 'U'
       ,@StampDateTime DATETIME = GETDATE()
       ,@StampUser VARCHAR(255) = '0'

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

		IF NOT EXISTS (
			SELECT 1
			FROM TRefPlanType2ProdSubType
			WHERE RefPlanType2ProdSubTypeId IN (SELECT CONVERT(INT,Value) FROM dbo.FnSplit(@RefPlanType2ProdSubTypeIds,','))
		)
			BEGIN

			-- updating existing plan type 1068
				UPDATE dbo.TRefPlanType
				SET    RetireFg = @ArchiveFg,  
				       @SchemeType = @SchemeType
				OUTPUT INSERTED.PlanTypeName, INSERTED.WebPage, INSERTED.OrigoRef, INSERTED.QuoteRef, INSERTED.NBRef, INSERTED.RetireFg,
				       INSERTED.RetireDate, INSERTED.FindFg, INSERTED.SchemeType, INSERTED.IsWrapperFg, INSERTED.AdditionalOwnersFg,
				       INSERTED.Extensible, INSERTED.ConcurrencyId, INSERTED.RefPlanTypeId,
				       @StampActionUpdate, @StampDateTime, @StampUser
				INTO   dbo.TRefPlanTypeAudit(PlanTypeName, WebPage, OrigoRef, QuoteRef, NBRef, RetireFg,
				       RetireDate, FindFg, SchemeType, IsWrapperFg, AdditionalOwnersFg,
				       Extensible, ConcurrencyId, RefPlanTypeId,
					   StampAction, StampDateTime, StampUser)
				WHERE  RefPlanTypeId = @PersonalInsurancePlanTypeId

			-- adding new sub types
				SET IDENTITY_INSERT TProdSubType ON

				INSERT INTO TProdSubType(ProdSubTypeId, ProdSubTypeName, ConcurrencyId)
				OUTPUT INSERTED.ProdSubTypeName,
				       INSERTED.ConcurrencyId,
				       INSERTED.ProdSubTypeId,
				       @StampActionCreate, @StampDateTime, @StampUser
				INTO   TProdSubTypeAudit(ProdSubTypeName, ConcurrencyId, ProdSubTypeId, StampAction, StampDateTime, StampUser)
				VALUES (1160, 'Life & IP', 1),
				       (1161, 'Life, Trauma & IP', 1),
				       (1162, 'TPD & IP', 1),
				       (1163, 'TPD, Trauma & IP', 1),
				       (1164, 'Trauma & IP', 1)

				SET IDENTITY_INSERT TProdSubType OFF

			-- adding RefPlanType2ProdSubType
				SET IDENTITY_INSERT TRefPlanType2ProdSubType ON

				INSERT INTO TRefPlanType2ProdSubType(
				       RefPlanType2ProdSubTypeId,
				       RefPlanTypeId,
				       ProdSubTypeId,
				       DefaultCategory,
				       ConcurrencyId,
				       IsConsumerFriendly,
				       RefPortfolioCategoryId,
				       RefPlanDiscriminatorId,
				       RegionCode)
				OUTPUT INSERTED.RefPlanTypeId,
				       INSERTED.ProdSubTypeId,
				       INSERTED.RefPortfolioCategoryId,
				       INSERTED.RefPlanDiscriminatorId,
				       INSERTED.DefaultCategory,
				       INSERTED.ConcurrencyId,
				       INSERTED.RefPlanType2ProdSubTypeId,
				       INSERTED.IsConsumerFriendly,
				       INSERTED.RegionCode,
				       @StampActionCreate, @StampDateTime, @StampUser
				INTO   TRefPlanType2ProdSubTypeAudit(
				       RefPlanTypeId,
				       ProdSubTypeId,
				       RefPortfolioCategoryId,
				       RefPlanDiscriminatorId,
				       DefaultCategory,
				       ConcurrencyId,
				       RefPlanType2ProdSubTypeId,
				       IsConsumerFriendly,
				       RegionCode,
				       StampAction,
				       StampDateTime,
				       StampUser)
				VALUES (1225, @PersonalInsurancePlanTypeId, 1160, @DefaultCategory, 1, 1, @PortfolioCategoryProtectionId, @PlanDiscriminatorId, @RegionCode),
				       (1226, @PersonalInsurancePlanTypeId, 1161, @DefaultCategory, 1, 1, @PortfolioCategoryProtectionId, @PlanDiscriminatorId, @RegionCode),
				       (1227, @PersonalInsurancePlanTypeId, 1162, @DefaultCategory, 1, 1, @PortfolioCategoryProtectionId, @PlanDiscriminatorId, @RegionCode),
				       (1228, @PersonalInsurancePlanTypeId, 1163, @DefaultCategory, 1, 1, @PortfolioCategoryProtectionId, @PlanDiscriminatorId, @RegionCode),
				       (1229, @PersonalInsurancePlanTypeId, 1164, @DefaultCategory, 1, 1, @PortfolioCategoryProtectionId, @PlanDiscriminatorId, @RegionCode)
				
				SET IDENTITY_INSERT TRefPlanType2ProdSubType OFF

			-- adding TRefLicenseTypeToRefPlanType2ProdSubType for all license types
				CREATE TABLE #RefPlanType2ProdSubTypeIdTemp(RefPlanType2ProdSubTypeId int)
				INSERT INTO #RefPlanType2ProdSubTypeIdTemp
				VALUES(1225), (1226), (1227), (1228), (1229)

				INSERT INTO TRefLicenseTypeToRefPlanType2ProdSubType(RefLicenseTypeId, RefPlanType2ProdSubTypeId)
				OUTPUT INSERTED.RefLicenseTypeId,
				       INSERTED.RefPlanType2ProdSubTypeId,
				       INSERTED.ConcurrencyId,
				       INSERTED.RefLicenseTypeToRefPlanType2ProdSubTypeId,
				       @StampActionCreate, @StampDateTime, @StampUser
				INTO   TRefLicenseTypeToRefPlanType2ProdSubTypeAudit
				SELECT RefLicenseTypeId, RefPlanType2ProdSubTypeId 
				FROM   Administration..TRefLicenseType CROSS JOIN #RefPlanType2ProdSubTypeIdTemp

				DROP TABLE #RefPlanType2ProdSubTypeIdTemp

			-- adding Plan type to Fact Find Section
				INSERT INTO factfind..TRefPlanTypeToSection(RefPlanType2ProdSubTypeId, Section, ConcurrencyId)
				OUTPUT
				       INSERTED.RefPlanType2ProdSubTypeId,
				       INSERTED.Section,
				       INSERTED.ConcurrencyId,
				       INSERTED.RefPlanTypeToSectionId,
				       @StampActionCreate,
				       @StampDateTime,
				       @StampUser
				INTO   factfind..TRefPlanTypeToSectionAudit
				       (RefPlanType2ProdSubTypeId,
				       Section,
				       ConcurrencyId,
				       RefPlanTypeToSectionId,
				       StampAction,
				       StampDateTime,
				       StampUser)
				VALUES (1225, @FactFindSection, 1),
				       (1226, @FactFindSection, 1),
				       (1227, @FactFindSection, 1),
				       (1228, @FactFindSection, 1),
				       (1229, @FactFindSection, 1)

			-- adding TRefPlanType2ProdSubTypeCategory
				INSERT INTO TRefPlanType2ProdSubTypeCategory(IndigoClientId, RefPlanType2ProdSubTypeId, PlanCategoryId, ConcurrencyId)
				OUTPUT INSERTED.IndigoClientId,
				       INSERTED.RefPlanType2ProdSubTypeId,
				       INSERTED.PlanCategoryId,
				       INSERTED.ConcurrencyId,
				       INSERTED.RefPlanType2ProdSubTypeCategoryId,
				       @StampActionDelete, @StampDateTime, @StampUser
				INTO   TRefPlanType2ProdSubTypeCategoryAudit(IndigoClientId, RefPlanType2ProdSubTypeId, PlanCategoryId, ConcurrencyId, RefPlanType2ProdSubTypeCategoryId,
				       StampAction, StampDateTime, StampUser)
				SELECT pc.IndigoClientId, pst.RefPlanType2ProdSubTypeId, pc.PlanCategoryId, 1
				FROM   TPlanCategory pc
				JOIN   TRefPlanType2ProdSubType pst ON pc.PlanCategoryName = pst.DefaultCategory
				WHERE  pst.RefPlanType2ProdSubTypeId IN(1225, 1226, 1227, 1228, 1229)
			END

		INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0 
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

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;