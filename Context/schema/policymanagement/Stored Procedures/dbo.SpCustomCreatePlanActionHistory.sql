SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomCreatePlanActionHistory] 
	@PolicyBusinessId BIGINT,
	@RefPlanActionId BIGINT,
	@ChangedFrom VARCHAR(255),
	@ChangedTo VARCHAR(255),
	@UserId BIGINT,
	@ChangedDate DATETIME = NULL 
AS  

SET NOCOUNT ON
	
DECLARE @tx int
SELECT @tx = @@TRANCOUNT

IF @tx = 0 
BEGIN TRANSACTION TX

BEGIN
	SET @ChangedDate = ISNULL(@ChangedDate, GETDATE()) 
	
	INSERT INTO PolicyManagement..TPlanActionHistory  
	(
		PolicyBusinessId,  
		RefPlanActionId,
		ChangedFrom,  
		ChangedTo,  
		DateOfChange,  
		ChangedByUserId  
	)
	
	-- Auditing -------------------------------------
	OUTPUT 
		INSERTED.[PlanActionHistoryId]
		,INSERTED.[PolicyBusinessId]
		,INSERTED.[RefPlanActionId]
		,INSERTED.[ChangedFrom]
		,INSERTED.[ChangedTo]
		,INSERTED.[DateOfChange]
		,INSERTED.[ChangedByUserId]
		,INSERTED.[ConcurrencyId]
		,'C'
		,@ChangedDate
		,CONVERT(VARCHAR, @UserId)
	INTO [PolicyManagement]..[TPlanActionHistoryAudit]
		([PlanActionHistoryId]
		,[PolicyBusinessId]
		,[RefPlanActionId]
		,[ChangedFrom]
		,[ChangedTo]
		,[DateOfChange]
		,[ChangedByUserId]
		,[ConcurrencyId]
		,[StampAction]
		,[StampDateTime]
		,[StampUser])
	-------------------------------------------------

	SELECT  
		@PolicyBusinessId,  
		@RefPlanActionId,
		@ChangedFrom,
		@ChangedTo, 
		@ChangedDate,
		@UserId	
	
	IF @@ERROR != 0 
		GOTO ERR
			
	IF @tx = 0 
		COMMIT TRANSACTION TX	
END
RETURN (0)
	
ERR:
  IF @tx = 0 
	ROLLBACK TRANSACTION TX
  RETURN (100)
  
GO

