SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeletePlan]
@PolicyBusinessId bigint,
@StampUser varchar(50),
@CurrentUserDate datetime

AS


-- add a new StatusHistory record of "Deleted" for his plan
	DECLARE @StatusId bigint
	DECLARE @StatusHistoryId bigint
	DECLARE @IndigoClientId bigint
	DECLARE @WrapperPolicyBusinessId bigint

	SET @IndigoClientId = (SELECT IndigoClientId FROM PolicyManagement..TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)

	SET @StatusId = (
		SELECT TOP 1 StatusId
		FROM PolicyManagement..TStatus 
		WHERE IndigoClientId = @IndigoClientId
		AND IntelligentOfficeStatusType = 'Deleted'
	)

--update the existing CurrentStatus
	insert into PolicyManagement..tstatushistoryaudit  (policybusinessid, statusid, statusreasonid, changedtodate, changedbyuserid, dateofchange, lifecyclestepfg, currentstatusfg, concurrencyid, statushistoryid, stampaction, stampdatetime, stampuser)
	SELECT PolicyBusinessId, StatusId, StatusReasonId, ChangedToDate, ChangedByUserId, DateOfChange, LifeCycleStepFg, CurrentStatusFg, ConcurrencyId, StatusHistoryId, 'U', getdate(), @StampUser
	FROM PolicyManagement..TStatusHistory 
	WHERE PolicyBusinessId = @PolicyBusinessId
	AND CurrentStatusFg = 1

	Update PolicyManagement..TStatusHistory Set CurrentStatusFG = 0 Where PolicyBusinessId = @PolicyBusinessId AND CurrentStatusFg = 1


	INSERT INTO PolicyManagement..TStatusHistory(PolicyBusinessId, StatusId, ChangedToDate, ChangedByUserId, DateOfChange, CurrentStatusFg, LifeCycleStepFg, ConcurrencyId)
	VALUES (@PolicyBusinessId, @StatusId, @CurrentUserDate, @StampUser, getdate(), 1, 1, 1)

	SET @StatusHistoryId = SCOPE_IDENTITY()

	INSERT INTO PolicyManagement..TStatusHistoryAudit(PolicyBusinessId, StatusId, ChangedToDate, ChangedByUserId, DateOfChange, CurrentStatusFg, LifeCycleStepFg, ConcurrencyId, StatusHistoryId, StampAction, StampDateTime, StampUser)
	VALUES (@PolicyBusinessId, @StatusId, @CurrentUserDate, @StampUser, getdate(), 1, 1, 1, @StatusHistoryId, 'C', getdate(), @StampUser)

--delete if related to a portfolio
	insert into policymanagement..TPortfolioClientPlanAudit
	(PortfolioClientId,
	PolicyBusinessId,
	PortfolioClientPlanId,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser)
	select	
	PortfolioClientId,
	PolicyBusinessId,
	PortfolioClientPlanId,
	ConcurrencyId,
	'D',
	getdate(),
	@StampUser
	from	policymanagement..TPortfolioClientPlan
	where	PolicyBusinessId = @PolicyBusinessId

	delete from	policymanagement..TPortfolioClientPlan
	where	PolicyBusinessId = @PolicyBusinessId

	--delete from [TWrapperPolicyBusiness] when plan gets deleted
	IF (@PolicyBusinessId IS NOT NULL) 
	BEGIN
		SELECT @WrapperPolicyBusinessId = WrapperPolicyBusinessId FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness] WHERE PolicyBusinessId = @PolicyBusinessId
		IF @WrapperPolicyBusinessId IS NOT NULL
		BEGIN
			EXEC policymanagement..SpNAuditWrapperPolicyBusiness @StampUser, @WrapperPolicyBusinessId, 'D'

			DELETE FROM [PolicyManagement].[dbo].[TWrapperPolicyBusiness]
			WHERE [PolicyBusinessId] = @PolicyBusinessId
		END
	END
GO
