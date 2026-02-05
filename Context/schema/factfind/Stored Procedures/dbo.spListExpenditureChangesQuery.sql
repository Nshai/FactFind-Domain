SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting list of expenditure changes by CRMContactId
-- ==================================================================
CREATE PROCEDURE [dbo].[spListExpenditureChangesQuery]
	@CRMContactId1 BIGINT,
	@CRMContactId2 BIGINT = null
AS


SELECT 
	exc.Amount,
	exc.Frequency,
	exc.IsRise
FROM dbo.TExpenditureChange exc
WHERE exc.CRMContactId = @CRMContactId1 OR
(@CRMContactId2 IS NOT NULL AND exc.CRMContactId = @CRMContactId2)

GO
