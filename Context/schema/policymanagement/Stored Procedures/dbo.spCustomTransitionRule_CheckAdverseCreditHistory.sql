SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



Create PROCEDURE [dbo].[spCustomTransitionRule_CheckAdverseCreditHistory]
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
		
		
	declare @FactFindId bigint = null
	declare @FactFindPrimaryOwnerId bigint	= null
	
	EXEC spCustomTansitionRule_CheckFactFind @Owner1Id, @Owner2Id, @Owner1Name, @Owner2Name, @ClientCount, 
		@FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT, @ErrorMessage OUTPUT
	
	if ISNULL(@ErrorMessage, '') != ''
		return 
	
		
	Declare @AdverseCreditHistorySetting varchar(3) = 'NO' 
	Declare @AdverseCreditHistorySettingValue int = NULL
	
	--Get the Sequential Ref
	Declare @SequentialRef Varchar(20) = (Select SequentialRef from TPolicyBusiness where PolicyBusinessId = @PolicyBusinessId)
			
	Declare @CreditHistory TABLE 
	(		
			PlanId Bigint, SequentialRef varchar(20), OwnerId Bigint, OwnerName varchar(100), --Required
			CreditHistoryId Bigint, DateDischarged varchar(50)
	)
	

	-- Has the question: Do you have any advserse credit history been answered?	by the Fact finds primary owner?
	Select @AdverseCreditHistorySetting = Case When HasAdverseCreditHistory IS NULL Then 'NO' Else 'YES' End,
		   @AdverseCreditHistorySettingValue = ISNULL(HasAdverseCreditHistory, -1)
	From factfind..TMortgageMiscellaneous Where CRMContactId = @FactFindPrimaryOwnerId

		
	If @AdverseCreditHistorySetting = 'NO'
	BEGIN
		Select @ErrorMessage = 'ADVERSECREDITHISTORYSETTING_' +			 
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) 
			
		RETURN
	END
		
	--If they have answered the questio and they slected 'no'... then nothing else to do
	if @AdverseCreditHistorySetting = 'YES' And @AdverseCreditHistorySettingValue = 0 
	return(0)
				
	--Get count of credit history records for both owners
	Declare @CountAdverseCreditHistoryRecords Bigint = 	(Select Count(1) from factfind..TCreditHistory where CRMContactId in (@Owner1Id, @Owner2Id))
	
	--If they have answered the questio and And there are NO Credit History records for either owner then fail
	if @AdverseCreditHistorySetting = 'YES' And @CountAdverseCreditHistoryRecords = 0 
	BEGIN
		Select @ErrorMessage = 'ADVERSECREDITHISTORYNORECORDS_' +		 
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) 

		RETURN
	END

	Insert Into @CreditHistory	
		Select Distinct @PolicyBusinessId, @SequentialRef, @Owner1Id, @Owner1Name,				-- OWNER 1 Credit History
			CreditHistoryId, 
			Case  When DateDischarged IS NOT NULL Then 'YES' ELSE 'NO' END						-- Date Discharged
		From factfind..TCreditHistory
		Where CRMContactId = @Owner1Id
		And [Type] = 'Bankruptcy'
		And DateDischarged IS NULL
		
	UNION
	
		Select Distinct @PolicyBusinessId, @SequentialRef, @Owner2Id, @Owner2Name,				-- OWNER 2 Credit History 
			CreditHistoryId, 
			Case  When DateDischarged IS NOT NULL Then 'YES' ELSE 'NO' END						-- Date Discharged
		From factfind..TCreditHistory
		Where CRMContactId = ISNULL(@Owner2Id, 0)
		And [Type] = 'Bankruptcy'
		And DateDischarged IS NULL

	

	--Remove Credit Histories that answer all questions correctly
	Delete From @CreditHistory WHERE DateDischarged = 'YES'

	
	if (Select COUNT(1) From @CreditHistory) = 0 
		return(0)

	
	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			'OwnerId=' + CONVERT(varchar(20),OwnerId) + '::'+  
			'OwnerName=' + OwnerName + '::'+  
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+ 
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) + '::'+
			'CreditHistoryId=' + CONVERT(varchar(20),CreditHistoryId) + '::'+   
			'DateDischarged='+ DateDischarged 	
			
		FROM @CreditHistory
				
		SELECT @ErrorMessage = 'ADVERSECREDITHISTORY_' + @Ids

	
		

GO
