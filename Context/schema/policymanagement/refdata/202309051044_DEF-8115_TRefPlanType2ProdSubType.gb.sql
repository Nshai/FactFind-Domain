USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @PlanTypeName VARCHAR(50) = 'Individual Retirement Account'
      , @NewCategory VARCHAR(50) = 'Retail Investments'
	  , @OldCategory VARCHAR(50) = 'Non-Regulated'
	  , @RefPlanType2ProdSubTypeId INT

/*
Summary
Update RMAR category for Individual Retirement Account

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType2ProdSubType    1
PolicyManagement    TRefPlanType2ProdSubTypeCategory    5991
*/


SELECT 
    @ScriptGUID = '935EE66F-F0C0-4F79-92B7-D165872446C7', 
    @Comments = 'DEF-8115 Update RMAR category for Individual Retirement Account'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

	SET @RefPlanType2ProdSubTypeId = (
		SELECT p2s.RefPlanType2ProdSubTypeId
		FROM TRefPlanType2ProdSubType p2s WITH (NOLOCK)
		JOIN TRefPlanType pt WITH (NOLOCK) on p2s.RefPlanTypeId = pt.RefPlanTypeId
		WHERE pt.PlanTypeName = @PlanTypeName
		)

	SELECT 
		c.IndigoClientId, 
		MAX(c.PlanCategoryId) as 'PlanCategoryId'
	INTO #NewPlanCategory
	FROM TPlanCategory c WITH (NOLOCK)
	WHERE c.PlanCategoryName = @NewCategory
	GROUP BY c.IndigoClientId

IF @RefPlanType2ProdSubTypeId IS NOT NULL
BEGIN TRY

    BEGIN TRANSACTION

	EXEC SpNAuditRefPlanType2ProdSubType 0, @RefPlanType2ProdSubTypeId, 'U'

    UPDATE TRefPlanType2ProdSubType
	SET DefaultCategory = @NewCategory
	WHERE RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId

	UPDATE p2sc
	SET PlanCategoryId = npc.PlanCategoryId
	OUTPUT
		deleted.ConcurrencyId,
		deleted.IndigoClientId,
		deleted.PlanCategoryId,
		deleted.RefPlanType2ProdSubTypeCategoryId,
		deleted.RefPlanType2ProdSubTypeId,
		'U',
		GETUTCDATE(),
		0
	INTO TRefPlanType2ProdSubTypeCategoryAudit(
		ConcurrencyId,
		IndigoClientId,
		PlanCategoryId,
		RefPlanType2ProdSubTypeCategoryId,
		RefPlanType2ProdSubTypeId,
		StampAction,
		StampDateTime,
		StampUser
	)
	FROM TRefPlanType2ProdSubTypeCategory p2sc
	JOIN TPlanCategory pc on p2sc.PlanCategoryId = pc.PlanCategoryId
	JOIN TRefPlanType2ProdSubType p2s on p2sc.RefPlanType2ProdSubTypeId = p2s.RefPlanType2ProdSubTypeId
	JOIN TRefPlanType pt on p2s.RefPlanTypeId = pt.RefPlanTypeId
	JOIN #NewPlanCategory npc ON p2sc.IndigoClientId = npc.IndigoClientId
	WHERE pt.PlanTypeName = @PlanTypeName
	AND pc.PlanCategoryName = @OldCategory

	DROP TABLE #NewPlanCategory

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;