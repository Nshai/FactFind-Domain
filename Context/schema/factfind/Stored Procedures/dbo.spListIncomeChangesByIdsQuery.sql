SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

-- =========================================================================
-- Description: Stored procedure for getting IncomeChanges by CRMContactIds
-- =========================================================================
CREATE PROCEDURE [dbo].[spListIncomeChangesByIdsQuery] 
	@CRMContactId1 BIGINT,
	@CRMContactId2 BIGINT = null
AS

SELECT
	ic.IncomeChangeId AS Id,
	ic.CRMContactId,
	ic.CRMContactId2,
	ic.IsRise,
	ic.Amount,
	ic.Frequency,
	ic.StartDate,
	ic.Description,
	ic.IsOwnerSelected
FROM TIncomeChange ic
WHERE ic.CRMContactId = @CRMContactId1 OR
(@CRMContactId2 IS NOT NULL AND ic.CRMContactId = @CRMContactId2)

GO