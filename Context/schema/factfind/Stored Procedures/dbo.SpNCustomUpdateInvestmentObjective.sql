SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateInvestmentObjective]
	@StampUser varchar (255),
	@InvestmentObjectiveId Bigint,
	@CRMContactId bigint = null,
	@Owner varchar(16),
	@GoalType tinyint = NULL,
	@RefGoalCategoryId bigint,
	@Objective varchar(500) = null,
	@TargetAmount money = null,
	@StartDate datetime = null,
	@TargetDate datetime = null,
	@Details varchar(max) = null,
	@Frequency int = null,
	@ConcurrencyId bigint = null, -- not required
	@TermInYears tinyint = null
AS
EXEC [SpNCustomUpdateObjective] 
	@StampUser, @InvestmentObjectiveId, @CRMContactId, @Owner, @GoalType,@RefGoalCategoryId,
	@Objective, @TargetAmount, @StartDate, @TargetDate, @Details, @Frequency,
	@TermInYears = @TermInYears
GO
