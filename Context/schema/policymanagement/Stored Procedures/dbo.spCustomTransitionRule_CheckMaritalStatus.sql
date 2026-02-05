SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[spCustomTransitionRule_CheckMaritalStatus]
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
	
	Declare @InvalidMaritalStatus Table (OwnerId bigint, OwnerName Varchar(150))
	

	Insert into @InvalidMaritalStatus
		Select @Owner1Id, @Owner1Name From CRM..TPerson A
		Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
		Where B.CRMContactId = @Owner1Id
		And (ISNULL(A.MaritalStatus, '') = '' OR (ISNULL(A.MaritalStatus, '') = 'Unknown'))
	Union
		Select @Owner2Id, @Owner2Name From CRM..TPerson A
		Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
		Where B.CRMContactId = @Owner2Id
		And (ISNULL(A.MaritalStatus, '') = '' OR (ISNULL(A.MaritalStatus, '') = 'Unknown'))
	
	
if (Select COUNT(1) From @InvalidMaritalStatus) = 0 
		return(0)

	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			
			'FactFindId=' + CONVERT(varchar(20),@FactFindId) + '::'+  
			'FactFindPrimaryOwnerId=' + CONVERT(varchar(20),@FactFindPrimaryOwnerId) + '::'+  
			'OwnerName=' + CONVERT(varchar(20),OwnerName) 
			
		FROM @InvalidMaritalStatus
				
		SELECT @ErrorMessage = 'MARITALSTATUS_' + @Ids
		
GO