SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting several options of ExpenditureDetails by ExpenditureDetail id
-- ==================================================================
CREATE PROCEDURE [dbo].[spGetExpenditureDetailsOptionsByIdQuery]
	@ExpenditureDetailsId BIGINT
AS

SELECT
  ed.IsConsolidated,
  ed.IsLiabilityToBeRepaid
FROM TExpenditureDetail ed
WHERE ed.ExpenditureDetailId = @ExpenditureDetailsId

GO