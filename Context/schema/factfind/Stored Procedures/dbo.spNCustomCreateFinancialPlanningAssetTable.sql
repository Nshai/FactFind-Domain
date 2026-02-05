SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomCreateFinancialPlanningAssetTable]

@FinancialPlanningId bigint,
@Data varchar(max)

as

if exists (select 1 
			from TFinancialPlanningAssetTableDetail
			where	FinancialPlanningId = @FinancialPlanningId) begin

update	TFinancialPlanningAssetTableDetail
set		AssetAllocationTableDetail = @Data
where	FinancialPlanningId = @FinancialPlanningId

end
else begin

insert into TFinancialPlanningAssetTableDetail
(FinancialPlanningId,AssetAllocationTableDetail)
select @FinancialPlanningId,@Data

end
GO
