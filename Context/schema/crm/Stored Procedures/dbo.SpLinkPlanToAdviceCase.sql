USE [CRM];
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpLinkPlanToAdviceCase]
	@PolicyBussinessIds VARCHAR(MAX),
	@AdviceCaseId BIGINT,
	@UserId BIGINT,
	@TenantId BIGINT
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	DECLARE 
		@RuleName VARCHAR(100) = 'User should be allowed to link same fees, documents and plans to multiple service cases',
		@CanLinkPlanToMultipleServiceCases BIT;

	DECLARE @PolicyBussinessIdTable TABLE(PolicyBussinessId INT)

	INSERT INTO @PolicyBussinessIdTable
	SELECT PB.Value
	FROM STRING_SPLIT(@PolicyBussinessIds, ',') PB
	JOIN PolicyManagement.dbo.TPolicyBusiness TPB on PB.value = TPB.PolicyBusinessId
	WHERE TPB.IndigoClientId = @TenantId

	if((SELECT COUNT(1) FROM STRING_SPLIT(@PolicyBussinessIds, ',')) <> (SELECT COUNT(1) FROM @PolicyBussinessIdTable))
	BEGIN
		GOTO errh;
	END

	SET @CanLinkPlanToMultipleServiceCases = (
		SELECT COUNT(TRC.TenantRuleConfigurationId) as count 
		FROM PolicyManagement.dbo.TTenantRuleConfiguration TRC 
		INNER JOIN PolicyManagement.dbo.TRefRuleConfiguration RRC ON TRC.RefRuleConfigurationId = RRC.RefRuleConfigurationId 
		WHERE RRC.RuleName = @RuleName
		AND TRC.TenantId = @TenantId 
		AND TRC.IsConfigured = 1)

	DECLARE @AdviceCasesThisPlanIsLinkedTo TABLE(AdviceCaseId INT, PolicyBusinessId INT)
	
	INSERT INTO @AdviceCasesThisPlanIsLinkedTo
	SELECT 
		ACP.AdviceCaseId,
		ACP.PolicyBusinessId 
	FROM CRM.dbo.TAdviceCasePlan ACP 
	INNER JOIN PolicyManagement.dbo.TPolicyBusiness TPB ON ACP.PolicyBusinessId=TPB.PolicyBusinessId 
	WHERE TPB.PolicyBusinessId IN (SELECT PBIT.PolicyBussinessId FROM @PolicyBussinessIdTable PBIT)
	AND TPB.IndigoClientId = @TenantId
	
	IF (EXISTS (SELECT ACP.AdviceCaseId FROM @AdviceCasesThisPlanIsLinkedTo ACP) 
		AND (@CanLinkPlanToMultipleServiceCases = 0 
		OR (EXISTS (SELECT ACP.AdviceCaseId FROM @AdviceCasesThisPlanIsLinkedTo ACP WHERE ACP.AdviceCaseId = @AdviceCaseId))))
		BEGIN
			GOTO errh;
		END
	ELSE
		BEGIN
			INSERT INTO CRM.dbo.TAdviceCasePlan (AdviceCaseId, PolicyBusinessId, ConcurrencyId) 
			OUTPUT  
				INSERTED.AdviceCaseId, 
				INSERTED.PolicyBusinessId,
				INSERTED.ConcurrencyId,
				INSERTED.AdviceCasePlanId,
				'C', 
				GetDate(), 
				@UserId
			INTO CRM.dbo.TAdviceCasePlanAudit(
				AdviceCaseId, 
				PolicyBusinessId, 
				ConcurrencyId, 
				AdviceCasePlanId, 
				StampAction, 
				StampDateTime, 
				StampUser) 
			SELECT @AdviceCaseId, PBT.PolicyBussinessId, 1 
			FROM @PolicyBussinessIdTable PBT;

			DECLARE @FileCheck TABLE(FileCheckMiniId INT)

			INSERT INTO @FileCheck
			SELECT 
				TFC.FileCheckMiniId
			FROM Compliance.dbo.TFileCheckMini TFC 
			INNER JOIN PolicyManagement.dbo.TPolicyBusiness TPB on TFC.PolicyBusinessId = TPB.PolicyBusinessId 
			WHERE TPB.PolicyBusinessId IN (SELECT PBIT.PolicyBussinessId FROM @PolicyBussinessIdTable PBIT)
			AND TPB.IndigoClientId = @TenantId
			AND TFC.IsPreSaleFileChecked = 0
			AND TFC.IndClientId = @TenantId 
			AND TFC.IsArchived = 0
			UNION All
			SELECT 
				TFC.FileCheckMiniId
			FROM Compliance.dbo.TFileCheckMini TFC 
			INNER JOIN PolicyManagement.dbo.TPolicyBusiness TPB on TFC.PolicyBusinessId = TPB.PolicyBusinessId 
			WHERE TPB.PolicyBusinessId IN (SELECT PBIT.PolicyBussinessId FROM @PolicyBussinessIdTable PBIT)
			AND TPB.IndigoClientId = @TenantId
			AND TFC.IsPreSaleFileChecked = 1
			AND TFC.IndClientId = @TenantId 
			AND TFC.IsArchived = 0
			EXCEPT 
			SELECT FileCheckMiniId
			FROM TAdviceCaseFileCheck
			WHERE AdviceCaseId = @AdviceCaseId

			IF (EXISTS (SELECT FC.FileCheckMiniId FROM @FileCheck FC))
				BEGIN
					INSERT INTO CRM.dbo.TAdviceCaseFileCheck(AdviceCaseId, FileCheckMiniId, ConcurrencyId)
					OUTPUT 
						INSERTED.AdviceCaseId,  
						INSERTED.FileCheckMiniId, 
						INSERTED.ConcurrencyId,
						INSERTED.AdviceCaseFileCheckId, 
						'C', 
						GetDate(), 
						@UserId
					INTO CRM.dbo.TAdviceCaseFileCheckAudit(
						AdviceCaseId,
						FileCheckMiniId,
						ConcurrencyId, 
						AdviceCaseFileCheckId, 
						StampAction, 
						StampDateTime, 
						StampUser)
					SELECT @AdviceCaseId, FC.FileCheckMiniId, 1 
					FROM @FileCheck FC
				END
		END
		
	IF @@ERROR != 0 GOTO errh
	IF @tx = 0 COMMIT TRANSACTION TX
END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN(100)