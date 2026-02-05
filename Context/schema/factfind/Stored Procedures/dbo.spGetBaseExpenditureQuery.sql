SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO
-- ==================================================================
-- Description: Stored procedure for getting expenditure by CRMContactId
-- ==================================================================
CREATE PROCEDURE [dbo].[spGetBaseExpenditureQuery]
	@CRMContactId1 BIGINT,
	@CRMContactId2 BIGINT = null
AS

SELECT 
	ex.HasFactFindLiabilitiesImported,
	ex.IsDetailed,
	ex.IsChangeExpected,
	ex.NetMonthlySummaryAmount
FROM dbo.TExpenditure ex
WHERE ex.CRMContactId = @CRMContactId1 OR
(@CRMContactId2 IS NOT NULL AND ex.CRMContactId = @CRMContactId2)

GO
