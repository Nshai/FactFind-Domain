SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateFinancialPlanningInvestmentAssetAllocation]   
@StampUser varchar (255),   
@FinancialPlanningId bigint,   
@InvestmentId bigint,   
@InvestmentType varchar(50) ,   
@AssetClass  varchar(50) ,   
@AssetAllocation money = NULL
  
AS  
  
declare @InvestmentAssetAllocationId bigint,
		@InvestmentAssetAllocationBreakdownId bigint


--get the investment allocation id.  If null create one
select   @InvestmentAssetAllocationId =		(select top 1 FinancialPlanningInvestmentAssetAllocationId
											from TFinancialPlanningInvestmentAssetAllocation
											where InvestmentId = @InvestmentId and
												  InvestmentType = @InvestmentType)
					
if(@InvestmentAssetAllocationId is null) begin

	insert into TFinancialPlanningInvestmentAssetAllocation (FinancialPlanningId,InvestmentId,InvestmentType,ConcurrencyId)
	select @FinancialPlanningId, @InvestmentId,@InvestmentType, 1
	
	select @InvestmentAssetAllocationId = SCOPE_IDENTITY()

	exec SpNAuditFinancialPlanningInvestmentAssetAllocation @StampUser, @InvestmentAssetAllocationId, 'C'

end

		
--get the breakdown id.  If it's null we create, if it's populated we update
select @InvestmentAssetAllocationBreakdownId = FinancialPlanningInvestmentAssetAllocationBreakdownId  
											from TFinancialPlanningInvestmentAssetAllocationBreakdown
											where	FinancialPlanningInvestmentAssetAllocationId = @InvestmentAssetAllocationId and 
													AssetClass = @AssetClass

if(@InvestmentAssetAllocationBreakdownId is null) begin

	insert into TFinancialPlanningInvestmentAssetAllocationBreakdown (FinancialPlanningInvestmentAssetAllocationId,AssetClass,AllocationPercentage,ConcurrencyId)
	select @InvestmentAssetAllocationId, @AssetClass,@AssetAllocation, 1
	
	select @InvestmentAssetAllocationBreakdownId = SCOPE_IDENTITY()

	exec SpNAuditFinancialPlanningInvestmentAssetAllocationBreakdown @StampUser, @InvestmentAssetAllocationBreakdownId, 'C'

end else begin
	
	exec SpNAuditFinancialPlanningInvestmentAssetAllocationBreakdown @StampUser, @InvestmentAssetAllocationBreakdownId, 'U'		

	update	TFinancialPlanningInvestmentAssetAllocationBreakdown
	set		AllocationPercentage = @AssetAllocation
	where	FinancialPlanningInvestmentAssetAllocationBreakdownId = @InvestmentAssetAllocationBreakdownId

end


  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)
GO
