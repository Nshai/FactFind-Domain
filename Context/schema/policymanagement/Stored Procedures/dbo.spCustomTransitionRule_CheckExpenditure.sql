SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[spCustomTransitionRule_CheckExpenditure]
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
	
	Declare @DetailedExpenditureSetting varchar(3) = 'NO'
	Declare @DetailedExpenditureSettingValue int = -1
	Declare @NetMonthyExpenditure varchar(3) = 'YES'
	
	-- Has the question been answered by the primary fact find owner?	
	Select @DetailedExpenditureSetting = Case When IsDetailed IS NOT NULL Then 'YES' Else 'NO' End,
		   @DetailedExpenditureSettingValue = ISNULL(IsDetailed, -1),
		   @NetMonthyExpenditure = Case When NetMonthlySummaryAmount IS NOT NULL Then 'YES' ELSE 'NO' END			   
	From factfind..TExpenditure Where CRMContactId = @FactFindPrimaryOwnerId
	
	If @DetailedExpenditureSetting = 'NO'
	BEGIN
		SELECT @ErrorMessage = 'EXPENDITURESETTING_' +						
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) 			
		RETURN
	END
	
	
	--If the answer to the quetion is YES ... then nothing else to do
	if @DetailedExpenditureSetting = 'YES' And @DetailedExpenditureSettingValue = 1
		return(0)	
	
	--Get the Sequential Ref
	Declare @SequentialRef Varchar(20) = (Select SequentialRef from TPolicyBusiness where PolicyBusinessId = @PolicyBusinessId)
			
	Declare @Expenditure TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, OwnerName varchar(100), --Required
			TotalNetMonthlyExpenditure varchar(3)
	)
	
	
	Insert Into @Expenditure		
		Select Distinct @PolicyBusinessId, @SequentialRef,							--  Expenditure - YES		
			case when @Owner1Id = @FactFindPrimaryOwnerId then @Owner1Id
				When @Owner2Id = @FactFindPrimaryOwnerId then @Owner2Id
			End,																	-- Fact Find owner Id
			case when @Owner1Id = @FactFindPrimaryOwnerId then @Owner1Name
				When @Owner2Id = @FactFindPrimaryOwnerId then @Owner2Name
			End,																	-- Fact Find owner Name
			@NetMonthyExpenditure													-- Total Monthly Expenditure
																	
				

	--Remove Liabilties that answer all questions correctly
	Delete From @Expenditure 
	WHERE TotalNetMonthlyExpenditure = 'YES'

	if (Select COUNT(1) From @Expenditure) = 0 
		return(0)

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'PlanId=' + CONVERT(varchar(50),PlanId) + '::'+  
			'SequentialRef=' + CONVERT(varchar(50),SequentialRef)  + '::'+  
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@Owner1Id) + '::'+  
			'FactFindPrimaryOwnerName=' + CONVERT(varchar(20),OwnerName) + '::'+   				
			'TotalNetMonthlyExpenditure='+ TotalNetMonthlyExpenditure 
			
		FROM @Expenditure
				
		SELECT @ErrorMessage = 'EXPENDITURE_' + @Ids
		
GO