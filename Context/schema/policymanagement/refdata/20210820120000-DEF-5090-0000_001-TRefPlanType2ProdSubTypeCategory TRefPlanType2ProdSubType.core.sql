USE [policymanagement];


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
	@ScriptGUID = '2BD91708-2817-4F4B-A89A-274F12346AD3', --Need to set this
	@Comments = 'DEF-4386 - SSAS - RMAR Categorisation is incorrectly categorised as ''Retail Investments''' --Need to set this, please follow this format so script can be run in order


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int


BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

			DECLARE @StampUser VARCHAR(20) = '0'
			DECLARE @StampAction varchar(1) = 'U'
			DECLARE @StampDateTime DateTime = GetDate()
			DECLARE @NewCategoryName varchar(50) = 'Non-Regulated'
			
			DECLARE @RefPlanType2ProdSubTypeId_SSAS INT = (
				SELECT TOP 1 PST.RefPlanType2ProdSubTypeId  
				FROM policymanagement..TRefPlanType PT 
				JOIN policymanagement..TRefPlanType2ProdSubType PST ON PST.RefPlanTypeId = PT.RefPlanTypeId
				WHERE PT.PlanTypeName = 'SSAS') -- 12

			SELECT 
				STC.IndigoClientId, 
				MIN(PC.PlanCategoryId) as NonRegulatedPlanCategoryId --There is some duplication for tenant 775
			INTO #Categories
			FROM policymanagement..TRefPlanType2ProdSubTypeCategory STC WITH (NOLOCK)
			JOIN policymanagement..TPlanCategory PC WITH (NOLOCK) ON PC.IndigoClientId = STC.IndigoClientId AND PC.PlanCategoryName = @NewCategoryName
			WHERE STC.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId_SSAS
			GROUP BY STC.IndigoClientId

			UPDATE stc
				SET stc.PlanCategoryId = C.NonRegulatedPlanCategoryId
			OUTPUT
				deleted.[IndigoClientId],
				deleted.[RefPlanType2ProdSubTypeId],
				deleted.[PlanCategoryId],
				deleted.[ConcurrencyId],
				deleted.[RefPlanType2ProdSubTypeCategoryId],
				@StampAction,
				@StampDateTime,
				@StampUser
			INTO TRefPlanType2ProdSubTypeCategoryAudit(
				[IndigoClientId],
				[RefPlanType2ProdSubTypeId],
				[PlanCategoryId],
				[ConcurrencyId],
				[RefPlanType2ProdSubTypeCategoryId],
				[StampAction],
				[StampDateTime],
				[StampUser]
			)
			FROM policymanagement..TRefPlanType2ProdSubTypeCategory STC
			JOIN #Categories C ON STC.IndigoClientId = C.IndigoClientId 
			WHERE STC.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId_SSAS

			UPDATE policymanagement..TRefPlanType2ProdSubType
			SET 
				DefaultCategory = @NewCategoryName
			OUTPUT
				deleted.[RefPlanTypeId],
				deleted.[ProdSubTypeId],
				deleted.[RefPortfolioCategoryId],
				deleted.[RefPlanDiscriminatorId],
				deleted.[DefaultCategory],
				deleted.[ConcurrencyId],
				deleted.[RefPlanType2ProdSubTypeId],
				@StampAction,
				@StampDateTime,
				@StampUser,
				deleted.[IsArchived],
				deleted.[IsConsumerFriendly],
				deleted.[RegionCode]
			INTO TRefPlanType2ProdSubTypeAudit(
				[RefPlanTypeId],
				[ProdSubTypeId],
				[RefPortfolioCategoryId],
				[RefPlanDiscriminatorId],
				[DefaultCategory],
				[ConcurrencyId],
				[RefPlanType2ProdSubTypeId],
				[StampAction],
				[StampDateTime],
				[StampUser],
				[IsArchived],
				[IsConsumerFriendly],
				[RegionCode]
			)
			WHERE RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId_SSAS

			INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0 
        COMMIT TRANSACTION

	IF (SELECT OBJECT_ID('tempdb..#Categories')) IS NOT NULL 
		DROP TABLE #Categories


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