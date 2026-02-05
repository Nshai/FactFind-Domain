SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveRefFinancialPlanningTaxWrapper]
@IncludePension bit = 0

as

select RefFinancialPlanningTaxWrapperId,
Description,
IsPension,
ConcurrencyId
from TRefFinancialPlanningTaxWrapper 
where IsPension = 0 or IsPension = @IncludePension
GO
