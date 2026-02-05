SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinalSalaryPensionPlans]
	@StampUser varchar(50),
	@FinalSalaryPensionPlansId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS
EXEC SpNCustomDeletePlan @FinalSalaryPensionPlansId, @StampUser, @CurrentUserDate
GO
