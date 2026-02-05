SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNAuditFPChartAssetAllocation]

@FPChartAssetAllocationAuditId bigint,
@StampAction char(1),
@StampUser varchar(50)

as

insert into TFPChartAssetAllocationAudit
(FinancialPlanningId,
AllocationKey,
AllocationText,
ChartXml,
ConcurrencyId,
FPChartAssetAllocationId,
STAMPACTION,
STAMPDATETIME,
STAMPUSER)
select
FinancialPlanningId,
AllocationKey,
AllocationText,
ChartXml,
ConcurrencyId,
FPChartAssetAllocationId,
@StampAction,
getdate(),
@StampUser
from	TFPChartAssetAllocation
where	FPChartAssetAllocationId = @FPChartAssetAllocationAuditId
GO
