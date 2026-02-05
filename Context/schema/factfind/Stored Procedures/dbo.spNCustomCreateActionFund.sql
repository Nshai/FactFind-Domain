SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomCreateActionFund]

@ActionPlanId bigint,
@FundUnitId bigint = null,
@PercentageAllocation decimal (18,9),
@RegularContributionPercentage decimal (18,2),
@PolicyBusinessFundId bigint = null,
@StampUser varchar (50)

as

declare @ActionFundId bigint, @FundId bigint

DECLARE @ExsitingActionFundId BIGINT
IF @PolicyBusinessFundId IS NOT NULL
BEGIN
	SELECT @ExsitingActionFundId = ActionFundId
	FROM TActionFund
	WHERE PolicyBusinessFundId = @PolicyBusinessFundId
	AND ActionPlanId = @ActionPlanId
END 

IF ISNULL(@PolicyBusinessFundId, 0) = 0
	BEGIN
		select @FundId = fundId from fund2..TFundUnit where fundunitid = @FundUnitId
 
		insert into TActionFund
		(
		ActionPlanId,
		FundId,
		FundUnitId,
		PercentageAllocation,
		PolicyBusinessFundId
		)
		select 
		@ActionPlanId,
		@FundId,
		@FundUnitId,
		@PercentageAllocation,
		@PolicyBusinessFundId
 

		select @ActionFundId = SCOPE_IDENTITY()

		exec spNAuditActionFund @StampUser,@ActionFundId,'C'

		return @ActionFundId
	END
ELSE
	RETURN @ExsitingActionFundId

GO
