SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomCalculateNextDueDateAndAmountJob]
	@DueDateTime DateTime
AS

DECLARE @StartOfToday datetime = CAST(GETDATE() as DATE) --today at 00:00:00  (not 23:59:59) 
Print @startofToday 

Exec spCustomCalculateNextDueDateAndAmount @DueDateTime = @DueDateTime, @MovementDateTime = @StartOfToday
