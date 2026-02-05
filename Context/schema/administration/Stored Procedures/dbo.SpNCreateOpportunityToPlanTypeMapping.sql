SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNCreateOpportunityToPlanTypeMapping]
@TenantId BIGINT
AS

SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
 BEGIN
	DECLARE @StampUser VARCHAR(20) = '0'
	DECLARE @StampCreateAction VARCHAR(1) = 'C'
	DECLARE @StampDateTime DATETIME = GetDate();
	DECLARE @RegulatedMortgageCategory VARCHAR(100) = 'Mortgage'
	DECLARE @NonRegulatedMortgageCategory VARCHAR(100) = 'Mortgage(Non-Regulated)'
	DECLARE @Count INT = 0

	SELECT @Count = COUNT(*) from crm..TRefOpportunityType2ProdSubType OP
	INNER JOIN CRM..TOpportunityType O
	ON OP.OpportunityTypeId = O.OpportunityTypeId
	WHERE O.IndigoClientId = @TenantId	

IF(@Count > 0)
RETURN;

	CREATE TABLE #TmpTableNewPlanType 
		(
		  ProdSubTypeId BIGINT NULL
		 ,NewPlanType VARCHAR(100) NULL
		 ,OpportunityCategory VARCHAR(255) NULL
		)
	
	--Insert data in Temp table
	---- ---- ---- Regulated Type ---- ---- ---- 
	INSERT INTO #TmpTableNewPlanType 
	(
		NewPlanType
		,OpportunityCategory		
	)
	VALUES
		 (	'Bridging Loan'							,@RegulatedMortgageCategory		)
		,(	'Buy to Let'							,@RegulatedMortgageCategory		)
		,(	'Council/Tenant to Buy'					,@RegulatedMortgageCategory		)
		,(	'Further Advance'						,@RegulatedMortgageCategory		)
		,(	'Second Home'							,@RegulatedMortgageCategory		)
		,(	'Home Purchase Plan'					,@RegulatedMortgageCategory		)
		,(	'Let to Buy'							,@RegulatedMortgageCategory		)
		,(	'Remortgage'							,@RegulatedMortgageCategory		)
		,(	'Right to Buy'							,@RegulatedMortgageCategory		)
		,(	'Government Home Ownership Scheme'		,@RegulatedMortgageCategory		)
		,(	'Self-Build'							,@RegulatedMortgageCategory		)
		,(	'Shared Ownership'						,@RegulatedMortgageCategory		)
		,(	'Standard Residential'					,@RegulatedMortgageCategory		)
		,(	NULL									,@RegulatedMortgageCategory		)

	---- ---- ---- NonRegulatedType  ---- ---- ---- 
		--The below SubPlan Type will have only mapping in TRefOpportunityType2ProdSubType
		,(	'Offshore'		,@NonRegulatedMortgageCategory		)
		,(	'Overseas'		,@NonRegulatedMortgageCategory		)
		,(	'Buy to Let'	,@NonRegulatedMortgageCategory		)
		,(	'Commercial'	,@NonRegulatedMortgageCategory		)
		,(	NULL			,@NonRegulatedMortgageCategory		)

	--Update Prod SubType Id value corresponding to the Prod SubType Name 
	UPDATE #TmpTableNewPlanType
	SET ProdSubTypeId = PST.ProdSubTypeId
	FROM #TmpTableNewPlanType as TNP
		 INNER JOIN policymanagement..TProdSubType as PST
			ON TNP.NewPlanType = PST.ProdSubTypeName
    WHERE TNP.NewPlanType IS NOT NULL
	
	--Insert opportunity type & prod sub type mapping data	
	INSERT INTO crm..TRefOpportunityType2ProdSubType 
		(ProdSubTypeId
		,OpportunityTypeId
		,ConcurrencyId
		,IsArchived
		)
	OUTPUT Inserted.ProdSubTypeId
		   ,Inserted.OpportunityTypeId
		   ,Inserted.ConcurrencyId
		   ,Inserted.IsArchived
		   ,Inserted.RefOpportunityType2ProdSubTypeId
		   ,@StampCreateAction
		   ,@StampDateTime
		   ,@StampUser		
	INTO crm..TRefOpportunityType2ProdSubTypeAudit 
		(ProdSubTypeId, 
		 OpportunityTypeId,
		 ConcurrencyId, 
		 IsArchived, 
		 RefOpportunityType2ProdSubTypeId, 
		 StampAction, 
		 StampDateTime, 
		 StampUser)
	SELECT NPT.ProdSubTypeId,
		   OT.OpportunityTypeId,
		   1,
		   0 
	FROM  #TmpTableNewPlanType NPT
		  JOIN crm..TOpportunityType OT
			ON NPT.OpportunityCategory = OT.OpportunityTypeName
	WHERE OT.ArchiveFG = 0 AND OT.IndigoClientId = @TenantId
	ORDER BY OT.IndigoClientId, NPT.NewPlanType
		
IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

-- Drop any temptables explicitly
IF (SELECT OBJECT_ID('tempdb..#TmpTableNewPlanType')) IS NOT NULL
BEGIN
       DROP TABLE #TmpTableNewPlanType
END

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
