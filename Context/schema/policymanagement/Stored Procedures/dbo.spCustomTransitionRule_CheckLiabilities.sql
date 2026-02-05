SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckLiabilities]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(max) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
										
	--Only applies to person clients
	if @ClientType != 'PERSON'
		return(0)	
		
	--Check Fack Find 
	declare @FactFindId bigint = null
	declare @FactFindPrimaryOwnerId bigint	= null
	
	EXEC spCustomTansitionRule_CheckFactFind @Owner1Id, @Owner2Id, @Owner1Name, @Owner2Name, @ClientCount, 
		@FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT, @ErrorMessage OUTPUT
	
	if ISNULL(@ErrorMessage, '') != ''
		return 	
	
	
	Declare @AnyLiabilitiesSetting varchar(3) = 'NO'
	Declare @AnyLiabilitiesSettingValue int = NULL

	
	--Has the primary fact find owner answered the question - Do you have any liabilities		
	Select @AnyLiabilitiesSetting = Case When AnyLiabilities IS NULL Then 'NO' Else 'YES' End,
		   @AnyLiabilitiesSettingValue = ISNULL(AnyLiabilities, -1)
	From factfind..TBudgetMiscellaneous Where CRMContactId = @FactFindPrimaryOwnerId
	
	If @AnyLiabilitiesSetting = 'NO'
	BEGIN
		SELECT @ErrorMessage = 'ANYLIABILITIESSETTING_' +						
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) 			
		RETURN
	END
		
	--If The question was answered and the answer was "No" - then return
	if @AnyLiabilitiesSetting = 'YES' And @AnyLiabilitiesSettingValue = 0
		return(0)	
	
	--Get the Sequential Ref
	Declare @SequentialRef Varchar(20) = (Select SequentialRef from TPolicyBusiness where PolicyBusinessId = @PolicyBusinessId)
			
	Declare @Liabilities TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, OwnerName varchar(100), --Required
			FactFindOwnerId Bigint, FactFindOwnerName varchar(100),
			LiabilitiesId Bigint, Category varchar(50), AmountRemaining varchar(20),
			AmountOutstanding varchar(3), InterestRate varchar(3), PaymentAmount varchar(3), 
			LiabilityCategory varchar(3), EndDate varchar(3), IsToBeRepaid varchar(3)
	)
	
	
	Insert Into @Liabilities
		
		Select Distinct @PolicyBusinessId, @SequentialRef,							--  Expenditure - YES		
			CRMContactId,															-- liability OwnerId
			case when @Owner1Id = CRMContactId then @Owner1Name
				When @Owner2Id = CRMContactId then @Owner2Name
			End,																	-- liability OwnerName
		
			case when @Owner1Id = @FactFindPrimaryOwnerId then @Owner1Id
				When @Owner2Id = @FactFindPrimaryOwnerId then @Owner2Id
			End,																	-- Fact Find owner Id
			case when @Owner1Id = @FactFindPrimaryOwnerId then @Owner1Name
				When @Owner2Id = @FactFindPrimaryOwnerId then @Owner2Name
			End,																	-- Fact Find owner Name
			LiabilitiesId,  CommitedOutgoings, Amount,
			Case  When Amount IS NOT NULL Then 'YES' ELSE 'NO' END,								-- Remaining Amount
			Case  When InterestRate IS NOT NULL Then 'YES' ELSE 'NO' END,						-- InterestRate
			Case  When ISNULL(CONVERT(INT, PaymentAmountPerMonth),0)=0 Then 'NO' ELSE 'YES' END,-- PaymentAmount
			Case  When CommitedOutgoings IS NOT NULL Then 'YES' ELSE 'NO' END,					-- Liabitlity Category
			Case  When EndDate IS NULL 
					AND (CommitedOutgoings !='Credit/Store cards' AND CommitedOutgoings !='Student loans')
					 Then 'NO' ELSE 'YES' END,													-- End Date
			Case  When IsToBeRepaid IS NOT NULL Then 'YES' ELSE 'NO' END						-- Is to be repaid			
		From factfind..TLiabilities
		Where ((CRMContactId = @Owner1Id AND CRMContactId2 IS NULL)								  -- Solely owned by owner 1 - works for single and joint
			OR (@Owner2Id IS NOT NULL AND CRMContactId = @Owner2Id AND CRMContactId2 IS NULL)	  -- Solely owned by owner 2 - joint only
			OR (@Owner2Id IS NOT NULL AND CRMContactId = @Owner1Id AND CRMContactId2 = @Owner2Id) -- Joint owned Owner1/2 - joint only
			OR (@Owner2Id IS NOT NULL AND CRMContactId = @Owner2Id AND CRMContactId2 = @Owner1Id) -- Joint owned Owner2/1 - joint only
			)
			  
	
	
				


	--Remove Liabilties that answer all questions correctly
	Delete From @Liabilities 
	WHERE AmountOutstanding = 'YES' 
	AND  InterestRate = 'YES' 
	AND  PaymentAmount = 'YES' 
	AND  LiabilityCategory = 'YES' 
	AND  EndDate = 'YES'
	AND  IsToBeRepaid = 'YES'
	
	if (Select COUNT(1) From @Liabilities) = 0 
		return(0)

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'PlanId=' + CONVERT(varchar(50),PlanId) + '::'+  
			'SequentialRef=' + CONVERT(varchar(50),SequentialRef)  + '::'+  
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'OwnerId=' + CONVERT(varchar(20),OwnerId) + '::'+  
			'OwnerName=' + OwnerName + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),FactFindOwnerId) + '::'+  
			'FactFindPrimaryOwnerName=' + FactFindOwnerName + '::'+  
			'LiabilitiesId=' + CONVERT(varchar(20),LiabilitiesId) + '::'+  
			'Category=' + ISNULL(CONVERT(varchar(20),Category), 'blank') + '::'+  		
			'AmountRemaining=' + ISNULL(CONVERT(varchar(20),AmountRemaining), 'blank')  + '::'+  				
			'AmountOutstanding='+ AmountOutstanding + '::' +  
			'InterestRate='+ InterestRate + '::' +  
			'PaymentAmount='+ PaymentAmount + '::' +  
			'LiabilityCategory='+ LiabilityCategory + '::' +  
			'EndDate='+ EndDate + '::' +  
			'IsToBeRepaid='+ IsToBeRepaid 		
			
		FROM @Liabilities
				
		SELECT @ErrorMessage = 'LIABILITIES_' + @Ids

	
		

GO
