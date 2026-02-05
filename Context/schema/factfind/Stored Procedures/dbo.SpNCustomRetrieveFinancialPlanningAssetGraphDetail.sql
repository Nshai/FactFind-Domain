SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveFinancialPlanningAssetGraphDetail] 
@FinancialPlanningId bigint

as

select FinancialPlanningId, Data
from	TFinancialPlanningAssetGraphDetail 	
where	FinancialPlanningId = @FinancialPlanningId
GO
