SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteMoneyPurchasePensionPlans]
	@StampUser varchar(50),
	@MoneyPurchasePensionPlansId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS
EXEC SpNCustomDeletePlan @MoneyPurchasePensionPlansId, @StampUser, @CurrentUserDate
GO
