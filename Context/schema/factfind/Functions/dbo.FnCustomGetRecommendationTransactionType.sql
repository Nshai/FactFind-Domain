SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION dbo.FnCustomGetRecommendationTransactionType
( 
	@PolicyBusinessId int,

	@TopUpPolicyBusinessId int,

	@NewPlanProposal Bit,

	@ActionPlanContributionId int,

	@ContributionIncreased bit,

	@ActionPlanWithdrawalId int,

	@WithdrawalIncreased bit,

	@ActionFundId int,

	@WithdrawalType Varchar(25)	,
	
	@IsEncashment bit
)
RETURNS Varchar(100)

AS

BEGIN



    DECLARE @TransactionType Varchar(100) 

	

	SET @TransactionType =

		CASE

		WHEN @IsEncashment = 1 THEN 'Encashment'

		WHEN @NewPlanProposal = 1 THEN 'New Plan' 

		WHEN @TopUpPolicyBusinessId > 0 THEN 'Top Up' 

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionPlanContributionId IS NOT NULL AND @ContributionIncreased = 1)) THEN 'Increase Regular Cont.'  

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionPlanContributionId IS NOT NULL AND @ContributionIncreased = 0)) THEN 'Decrease Regular Cont.'  

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionPlanWithdrawalId IS NOT NULL AND @WithdrawalType IN ('Lump_Sum','Transfer') and @IsEncashment=0)) THEN 'Withdrawal'  

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionPlanWithdrawalId IS NOT NULL AND @WithdrawalIncreased = 1)) THEN 'Withdrawal Increase.'  

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionPlanWithdrawalId IS NOT NULL AND @WithdrawalIncreased = 0)) THEN 'Withdrawal Decrease.'  

		

		WHEN ( (@NewPlanProposal = 0 AND @PolicyBusinessId > 0) AND (@ActionFundId IS NOT NULL)) THEN 'Switch'  

		ELSE 'None'

		

END;  	



RETURN @TransactionType



END
GO
