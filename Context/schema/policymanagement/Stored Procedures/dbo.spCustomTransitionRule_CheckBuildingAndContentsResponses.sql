SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[spCustomTransitionRule_CheckBuildingAndContentsResponses]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
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
	
	Declare @Valid int = 0
		
	
	--This is the same check for single and joint, because even for single the 
	--owner could be the second owner of a valid Fact.
	Set @Valid = (
			Select COUNT(1) from factfind..TBuildingAndContentsProtection
			Where (CRMContactId = @FactFindPrimaryOwnerId)
			And IsCoverSufficient IS NOT NULL			
			And AnyExistingBuildingProvision IS NOT NULL
			And AnyExistingContentsProvision IS NOT NULL
			And AnyBuyToLet IS NOT NULL
			And ((AnyBuyToLet = 0) OR (AnyBuyToLet = 1 AND IsBtlCoverSufficient IS NOT NULL))
			
		)
	
	IF @Valid = 0
	BEGIN
	
		select @ErrorMessage = 'BUILDINGCONTENTSRESPONSES_::FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+ 
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId)
	END