SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomCreateFeeStatusTransitionRolesForNewTenant] (@NewTenantId BIGINT)
AS
BEGIN
	DECLARE @StampUser VARCHAR(1) = '0'
	DECLARE @TimeStamp DATETIME = GetDate()
	DECLARE @SubmittedRefFeeStatusId BIGINT
	DECLARE @DueRefFeeStatusId BIGINT
	DECLARE @NotToMapFeeStatusTransitionId BIGINT
	DECLARE @CancelledRefFeeStatusId BIGINT
	DECLARE @DeletedRefFeeStatusId BIGINT
	DECLARE @NTURefFeeStatusId BIGINT
	DECLARE @TMP_FeeStatusTransitionRoles AS TABLE (NotToMapFeeStatusTransitionId BIGINT)

	SELECT @SubmittedRefFeeStatusId = RefFeeStatusId FROM Policymanagement..TRefFeeStatus WHERE NAME = ('Submitted For T & C')	
	SELECT @DueRefFeeStatusId = RefFeeStatusId FROM Policymanagement..TRefFeeStatus	WHERE NAME = 'Due/Active'	
	SELECT @CancelledRefFeeStatusId = RefFeeStatusId FROM Policymanagement..TRefFeeStatus WHERE NAME = 'Cancelled'	
	SELECT @DeletedRefFeeStatusId = RefFeeStatusId FROM Policymanagement..TRefFeeStatus WHERE NAME = 'Deleted'	
	SELECT @NTURefFeeStatusId = RefFeeStatusId FROM Policymanagement..TRefFeeStatus	WHERE NAME = 'NTU'
	
	-- select Transition ID for Submitted For T & C to Due/Active
	INSERT INTO @TMP_FeeStatusTransitionRoles (NotToMapFeeStatusTransitionId)
	SELECT FeeStatusTransitionId FROM Policymanagement..TFeeStatusTransition
	WHERE FeeRefStatusIdFrom = @SubmittedRefFeeStatusId	AND FeeRefStatusIdTo = @DueRefFeeStatusId

	-- select Transition ID for Cancelled to Deleted
	INSERT INTO @TMP_FeeStatusTransitionRoles (NotToMapFeeStatusTransitionId)
	SELECT FeeStatusTransitionId FROM Policymanagement..TFeeStatusTransition
	WHERE FeeRefStatusIdFrom = @CancelledRefFeeStatusId	AND FeeRefStatusIdTo = @DeletedRefFeeStatusId
	
	-- select Transition ID for NTU transitions
	INSERT INTO @TMP_FeeStatusTransitionRoles (NotToMapFeeStatusTransitionId)
	SELECT FeeStatusTransitionId FROM Policymanagement..TFeeStatusTransition
	WHERE FeeRefStatusIdFrom = @NTURefFeeStatusId OR FeeRefStatusIdTo = @NTURefFeeStatusId

	INSERT INTO Policymanagement..TFeeStatusTransitionToRole (
		FeeStatusTransitionId
		,TenantId
		,RoleId
		)
	SELECT TFS.FeeStatusTransitionId
		,TR.IndigoClientId
		,TR.RoleId
	FROM TRole AS TR
	INNER JOIN TIndigoClient AS TI ON TR.IndigoClientId = TI.IndigoClientId
	INNER JOIN Policymanagement..TFeeStatusTransition AS TFS ON 1 = 1	
	WHERE TI.IndigoClientId = @NewTenantId
		AND TFS.FeeStatusTransitionId NOT IN (SELECT NotToMapFeeStatusTransitionId FROM @TMP_FeeStatusTransitionRoles)
	
	--Insert into Audit Table
	INSERT INTO Policymanagement..TFeeStatusTransitionToRoleAudit (
		FeeStatusTransitionId
		,TenantId
		,RoleId
		,ConcurrencyId
		,FeeStatusTransitionToRoleId
		,StampAction
		,StampDateTime
		,StampUser
		)
	SELECT FeeStatusTransitionId
		,TenantId
		,RoleId
		,ConcurrencyId
		,FeeStatusTransitionToRoleId
		,'C'
		,@TimeStamp
		,@StampUser
	FROM Policymanagement..TFeeStatusTransitionToRole
	WHERE TenantId = @NewTenantId
END
GO


