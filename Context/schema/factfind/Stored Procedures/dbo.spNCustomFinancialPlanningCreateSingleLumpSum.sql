SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomFinancialPlanningCreateSingleLumpSum]
		@Amount money,
		@PolicyBusinessId bigint,
		@IsMoneyIn bit,
		@StampUser varchar(255)
		
as

declare @RefFrequencyId bigint,
		@RefWithdrawalTypeId bigint,
		@RefContributionTypeId bigint,
		@RefContributorTypeId bigint,
		@ReturnId bigint

select	@RefFrequencyId = 10,
		@RefWithdrawalTypeId = 2,
		@RefContributionTypeId = 2,
		@RefContributorTypeId = 1

if(@isMoneyIn = 1) begin

	insert into PolicyManagement..TPolicyMoneyIn(
		Amount,
		RefFrequencyId,
		StartDate,
		PolicyBusinessId,
		RefContributionTypeId,
		RefContributorTypeId,
		ConcurrencyId)
	select
		@amount,
		@RefFrequencyId,
		getdate(),
		@policybusinessid,
		@RefContributionTypeId,
		@RefContributorTypeId,
		1
		
	select @returnId = SCOPE_IDENTITY()
	
	exec policymanagement..spNAuditPolicyMoneyIn @StampUser,@returnId,'C'

end
else begin

	insert into PolicyManagement..TPolicyMoneyOut(
		PolicyBusinessId,
		Amount,
		PaymentStartDate,
		RefFrequencyId,
		RefWithdrawalTypeId,
		ConcurrencyId)
	select
		@policybusinessid,
		@amount,
		getdate(),
		@RefFrequencyId,
		@RefWithdrawalTypeId,
		1
	
	select @returnId = SCOPE_IDENTITY()
	
	exec policymanagement..spNAuditPolicyMoneyOut @StampUser,@returnId,'C'
end
GO
