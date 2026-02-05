SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomFinancialPlanningIsLocked]
	@FinancialPlanningId bigint	
AS

declare @locked bigint

select @locked = count(*) from TFinancialPlanningLock where financialPlanningId = @FinancialPlanningId

select @locked


GO
