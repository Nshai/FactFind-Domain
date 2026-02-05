SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create  PROCEDURE [dbo].[spCustomTransitionRule_CheckMortgagePreferenceAndRisk]
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
	
	
	
	Declare @Valid1 int = 0
	Declare @Valid2 int = 0
	
	--Check the primary fact find owner's Mortgage preferences
	set @Valid1 = 
		(
			Select SUM(cnt) From 
			(				
				Select count(1) as cnt From FactFind..TMortgagePreferences
				Where CRMContactId = @FactFindPrimaryOwnerId
				AND redeemFg IS NOT NULL
				AND avoidUncertainty IS NOT NULL
				AND minPaymEarly IS NOT NULL
				AND addFeeFg IS NOT NULL
				AND varyNoPenalty IS NOT NULL
				AND linkToAccount IS NOT NULL
				AND freeLegalFees IS NOT NULL
				AND noValFee IS NOT NULL
				AND bookingFeeFg IS NOT NULL
				AND cashback IS NOT NULL
				AND LikelyToMove IS NOT NULL
				AND HighLendingCharge IS NOT NULL
				AND DailyInterestRates IS NOT NULL
				AND ClubFeeMortgageAdvance IS NOT NULL
				
				union all
				
				Select count(1) as cnt From FactFind..TMortgageRisk
				Where CRMContactId = @FactFindPrimaryOwnerId
				AND riskInterestChange IS NOT NULL
				AND riskMortgRepaid IS NOT NULL
				AND riskInvestVehicle IS NOT NULL
				AND riskCharge IS NOT NULL
				AND riskOverhang IS NOT NULL
				AND riskMaxYears IS NOT NULL
				
			) A
			
		)

	--Add Owner Data for side bar link generator
	IF(@Valid1 < 2)
	BEGIN		
		
		select @ErrorMessage = 'MORTGAGEPREFRISK_::FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+ 
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId)

	END				  
		
GO
