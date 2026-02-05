SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanValuation]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@Amount money,
	@CurrentUserDateTime datetime,
	@Date datetime = null,	
	@SurrenderValue money = null
AS	
DECLARE @PlanValuationId bigint    
-- Amount is required
IF @Amount IS NULL
	RETURN;

-- Default date	
SET @Date = ISNULL(@Date, CONVERT(varchar(12), @CurrentUserDateTime, 106))

-- Exit if the valuation already exists
IF EXISTS (
	SELECT 1 FROM PolicyManagement..TPlanValuation 
	WHERE PolicyBusinessId = @PolicyBusinessId AND PlanValue = @Amount AND PlanValueDate = @Date)
	RETURN;

-- Add new valuation
INSERT INTO PolicyManagement..TPlanValuation (
	PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId)    
VALUES (
	@PolicyBusinessId, @Amount, @Date, 1, @StampUser, GETDATE(), @SurrenderValue, 1)    

SET @PlanValuationId = SCOPE_IDENTITY()    
EXEC PolicyManagement..SpNAuditPlanValuation @StampUser, @PlanValuationId, 'C'
GO
