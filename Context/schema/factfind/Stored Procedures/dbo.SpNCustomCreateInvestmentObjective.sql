SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateInvestmentObjective]
	@StampUser varchar (255),
	@CRMContactId bigint,
	@Owner varchar(16),
	@CurrentUserDate datetime,
	@GoalType tinyint = NULL,
	@RefGoalCategoryId bigint,
	@Objective varchar(500) = NULL, 
	@TargetAmount money = NULL, 
	@StartDate datetime = NULL, 
	@TargetDate datetime = NULL, 
	@Details  varchar(max)= NULL,
	@Frequency int = NULL,
	@TermInYears tinyint = NULL
AS
DECLARE @NewId bigint

EXEC [SpNCustomCreateObjective] @StampUser, 1, @CRMContactId, @Owner, @CurrentUserDate,
	@GoalType,@RefGoalCategoryId, @Objective, @TargetAmount, @StartDate, @TargetDate, @Details, @Frequency,
	NULL, 1, NULL, @TermInYears, NULL, @ObjectiveId = @NewId output

SELECT @NewId AS InvestmentObjectiveId
GO
