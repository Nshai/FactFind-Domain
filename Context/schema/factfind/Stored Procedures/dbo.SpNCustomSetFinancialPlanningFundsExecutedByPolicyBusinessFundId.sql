SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomSetFinancialPlanningFundsExecutedByPolicyBusinessFundId] @StampUser varchar(255),
@PolicyBusinessFundId bigint

as

declare @FinancialPlanningSelectedFundsRevisedId bigint
select @FinancialPlanningSelectedFundsRevisedId = FinancialPlanningSelectedFundsRevisedId
													from TFinancialPlanningSelectedFundsRevised
													where policybusinessfundid = @PolicyBusinessFundId

exec spNAuditFinancialPlanningSelectedFundsRevised @StampUser,@FinancialPlanningSelectedFundsRevisedId,'U'

update	TFinancialPlanningSelectedFundsRevised
set		IsExecuted = 1
where	FinancialPlanningSelectedFundsRevisedId = @FinancialPlanningSelectedFundsRevisedId
GO
