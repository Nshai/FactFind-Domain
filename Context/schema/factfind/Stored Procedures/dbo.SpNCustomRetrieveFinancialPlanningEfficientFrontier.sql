SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[SpNCustomRetrieveFinancialPlanningEfficientFrontier]

@FinancialPlanningId bigint

as

select
FinancialPlanningId,
ChartUrl,
Data,
OriginalReturn,
OriginalRisk,
CurrentReturn,
CurrentRisk,
Term	
from TFinancialPlanningEfficientFrontier
where	@FinancialPlanningId  = FinancialPlanningId
GO
