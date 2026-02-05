SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomCalculateNextDueDateAndAmountByPolicyBusinessId]
	@PolicyBusinessId Int = 0,
	@DueDateTime DateTime
AS


Update TPolicyExpectedCommission Set DueDate = null where PolicyBusinessId = @PolicyBusinessId

EXEC spCustomCalculateNextDueDateAndAmount @PolicyBusinessId = @PolicyBusinessId, @DueDateTime = @DueDateTime