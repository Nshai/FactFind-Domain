SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

-- ==================================================================
-- Description: Stored procedure for getting Incomes by CRMContactIds
-- ==================================================================
CREATE PROCEDURE [dbo].[spListBaseIncomesByIdsQuery] 
	@CRMContactId1 BIGINT,
	@CRMContactId2 BIGINT = null
AS

SELECT
	i.IncomeId AS Id,
	i.CRMContactId,
	i.IsChangeExpected,
	i.IsRiseExpected,
	i.ChangeAmount,
	i.ChangeReason
FROM TIncome i
WHERE i.CRMContactId = @CRMContactId1 OR (@CRMContactId2 IS NOT NULL AND i.CRMContactId = @CRMContactId2)

GO