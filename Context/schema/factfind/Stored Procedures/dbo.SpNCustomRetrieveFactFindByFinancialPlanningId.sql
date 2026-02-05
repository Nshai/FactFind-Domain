SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFactFindByFinancialPlanningId]
	@FinancialPlanningId bigint
AS
SELECT
	FF.FactFindId,
	FF.CRMContactId1,	
	FF.CRMContactId2
FROM
	TFinancialPlanning FP
	JOIN TFactFind FF ON FF.FactFindId = FP.FactFindId
WHERE
	FP.FinancialPlanningId = @FinancialPlanningId
GO
