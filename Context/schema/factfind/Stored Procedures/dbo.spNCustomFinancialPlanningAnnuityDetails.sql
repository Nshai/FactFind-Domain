SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomFinancialPlanningAnnuityDetails] @FinancialPlanningId bigint

as

select		PensionIncrease,
case						
			when PensionIncrease = 'RPI' then 'RPI'
			when PensionIncrease = 'Limited to 5' then 'LPI'
			when PensionIncrease = 'Limited to 2.5' then 'LPI'
			else 'NONE'
												end as PensionIncreaseBasis,
			case
			when PensionIncrease = 'RPI' then '0'
			when PensionIncrease = 'Limited to 5' then 'LPI'
			when PensionIncrease = 'Limited to 2.5' then 'LPI'
			when PensionIncrease in ('1','2','3','4','5') then PensionIncrease
			else 'NONE'
												end as PensionIncreaseRate,
			case 
			when PensionIncrease = 'Limited to 5' then '5'
			when PensionIncrease = 'Limited to 2.5' then '2.5'
			else '0' end as LPICap,
			case 
			when PensionIncrease = 'Limited to 5' then '-0.3'
			when PensionIncrease = 'Limited to 2.5' then '-0.2'
			else '0' end as LPIAdjustment,
SpousePercentage,
GuaranteePeriod
from TFinancialPlanningExt where FinancialPlanningId = @FinancialPlanningId
GO
