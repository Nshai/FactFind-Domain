SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeletePersonalPensionPlan]
	@StampUser varchar(50),
	@PersonalPensionPlanId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS
EXEC SpNCustomDeletePlan @PersonalPensionPlanId, @StampUser, @CurrentUserDate
GO
