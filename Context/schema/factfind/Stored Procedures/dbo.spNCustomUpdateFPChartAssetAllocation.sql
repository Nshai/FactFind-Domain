SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateFPChartAssetAllocation]  
  
@FinancialPlanningId bigint,  
@Key varchar(10),  
@AllocationText varchar(255) = null,  
@ChartXml varchar(max) = null,  
@RiskProfileGuid uniqueidentifier = null,
@StampUser varchar(255)  
  
as  
  
declare @FPChartAssetAllocationId bigint  
  
select @FPChartAssetAllocationId = FPChartAssetAllocationId  
         from TFPChartAssetAllocation  
         where @FinancialPlanningId = FinancialPlanningId and  
           @Key = AllocationKey  
  
if(@FPChartAssetAllocationId is null) begin  
  
insert into TFPChartAssetAllocation  
(FinancialPlanningId,  
AllocationKey,  
AllocationText,  
ChartXml,  
RiskGuid,
ConcurrencyId)  
select  
@FinancialPlanningId,  
@Key,  
@AllocationText,  
@ChartXml,  
@RiskProfileGuid,
1  
  
select @FPChartAssetAllocationId = SCOPE_IDENTITY()  
  
exec spNAuditFPChartAssetAllocation @FPChartAssetAllocationId, 'C', @StampUser  
  
end else begin  
  
exec spNAuditFPChartAssetAllocation @FPChartAssetAllocationId, 'U', @StampUser  
  
  
update TFPChartAssetAllocation  
set  AllocationText = case when @AllocationText is null then AllocationText else @AllocationText end,  
  ChartXml = case when @ChartXml is null then ChartXml   
      when @ChartXml ='' then null  
      else @ChartXml end  ,
      RiskGuid = case when @RiskProfileGuid is null then RiskGuid else @RiskProfileGuid end
where FPChartAssetAllocationId = @FPChartAssetAllocationId  
  
end  
  
GO
