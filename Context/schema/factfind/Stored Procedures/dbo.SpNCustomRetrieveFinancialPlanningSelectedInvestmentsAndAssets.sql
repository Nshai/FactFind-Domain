SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveFinancialPlanningSelectedInvestmentsAndAssets] 

@FinancialPlanningId bigint

as

select	si.*
from	TFinancialPlanning fp
inner join TFinancialPlanningSelectedInvestments si on si.financialplanningid = fp.financialplanningid
where	fp.financialplanningid = @FinancialPlanningId	
GO
