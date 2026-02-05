SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomRetrieveFPNotes]  @FinancialPlanningId bigint

as

select 
isnull(Notes,'') as Notes
from TFinancialPlanningNote
where FinancialPlanningId = @FinancialPlanningId
GO
