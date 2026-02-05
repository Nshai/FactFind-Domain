SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteAnnuityPlan]
	@StampUser varchar(50),
	@AnnuityPlanId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS
EXEC SpNCustomDeletePlan @AnnuityPlanId, @StampUser, @CurrentUserDate
GO
