SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanPremium]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@RefFrequencyId bigint,
	@Amount money,
	@StartDate datetime,
	@RefContributionTypeId bigint,
	@RefContributorTypeId bigint,
	@CurrentUserDateTime datetime
AS	

DECLARE @IsCurrent bit, @PolicyMoneyInId bigint

-- make sure an amount and frequency is specified
IF @Amount IS NULL OR @RefFrequencyId IS NULL OR @RefFrequencyId = 0
	RETURN;

-- Default to lump sum
IF @RefFrequencyId = 10 AND @RefContributionTypeId = 1
	SET @RefContributionTypeId = 2

-- Set current flag on basis of start date
IF @StartDate is null
	Set @StartDate = @CurrentUserDateTime
	
-- convert to date element only - i.e. set time to zero
Set @StartDate = Convert(date, @StartDate)

SELECT @IsCurrent = CASE WHEN @RefContributionTypeId = 1 AND @StartDate <= Convert(date, @CurrentUserDateTime) THEN 1 ELSE 0 END;

-- Add money in
INSERT INTO PolicyManagement..TPolicyMoneyIn (
	Amount, RefFrequencyId, PolicyBusinessId, StartDate, RefContributionTypeId, RefContributorTypeId, CurrentFg, ConcurrencyId)
VALUES (
	@Amount, @RefFrequencyId, @PolicyBusinessId, @StartDate, @RefContributionTypeId, @RefContributorTypeId, @IsCurrent, 1)

-- Audit
SET @PolicyMoneyInId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditPolicyMoneyIn @StampUser, @PolicyMoneyInId, 'C'
GO
