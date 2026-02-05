SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateOutstandingBalance]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@Amount money,
	@CurrentUserDateTime datetime,	
	@SurrenderValue money = null,
    @BalanceDate datetime = null
AS	
DECLARE @PlanValuationId bigint    
DECLARE @Date datetime
DECLARE @PlanValueDate datetime

-- Amount is required
IF @Amount IS NULL
	SET @Amount = 0

-- Default date	
SET @Date = CONVERT(varchar(12), @CurrentUserDateTime, 106)

-- Exit if the valuation already exists
IF (@Amount = 
	(SELECT TOP 1 PlanValue FROM PolicyManagement..TPlanValuation 
	WHERE PolicyBusinessId = @PolicyBusinessId ORDER BY PlanValueDate desc, PlanValuationId desc))
	RETURN;

SET @PlanValueDate = IIF(@BalanceDate IS NULL, @Date, @BalanceDate)
-- Add new valuation
INSERT INTO PolicyManagement..TPlanValuation (
	PolicyBusinessId, PlanValue, PlanValueDate, RefPlanValueTypeId, WhoUpdatedValue, WhoUpdatedDateTime, SurrenderTransferValue, ConcurrencyId)    
VALUES (
	@PolicyBusinessId, -@Amount, @PlanValueDate, 1, @StampUser, GETDATE(), @SurrenderValue, 1)    

SET @PlanValuationId = SCOPE_IDENTITY()    
EXEC PolicyManagement..SpNAuditPlanValuation @StampUser, @PlanValuationId, 'C'
GO
