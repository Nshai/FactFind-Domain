SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteSavingsPlans] 
@ConcurrencyId bigint,
@SavingsPlansId bigint,
@StampUser varchar(50),
@CurrentUserDate datetime

AS


EXEC SpNCustomDeletePlan @SavingsPlansId, @StampUser, @CurrentUserDate
GO
