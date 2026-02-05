SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckResidencyStatus]
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
										
	
	Declare @AddressTypeHome bigint = 1
	Declare @AddressTypeOther bigint = 3
	Declare @PersonClientType varchar(10) = 'PERSON'
	
	Declare @InValid1 int = 1
	Declare @InValid2 int = 1

	Declare @InvalidAddresses Table (AddressId bigint, OwnerId bigint, OwnerName Varchar(150))

	Insert into @InvalidAddresses		
		Select AddressId, @Owner1Id, @Owner1Name From CRM..TAddress   
		Where CRMContactId = @Owner1Id
		And (RefAddressTypeId = @AddressTypeHome Or (RefAddressTypeId = @AddressTypeOther And @ClientType <> @PersonClientType))
		And ResidencyStatus IS NULL
		And RefAddressStatusId <> 4
	Union
		Select AddressId, @Owner2Id, @Owner2Name From CRM..TAddress   
		Where @Owner2Id IS NOT NULL 
		And CRMContactId = @Owner2Id
		And (RefAddressTypeId = @AddressTypeHome Or (RefAddressTypeId = @AddressTypeOther And @ClientType <> @PersonClientType))
		And ResidencyStatus IS NULL
		And RefAddressStatusId <> 4

	if (Select count(1) from @InvalidAddresses) = 0
		return(0)
		
	DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 			
			'AddressId=' + CONVERT(varchar(20),AddressId) + '::'+  
			'OwnerId=' + CONVERT(varchar(20),OwnerId) + '::'+  
			'OwnerName=' + CONVERT(varchar(20),OwnerName) 
			
		FROM @InvalidAddresses
				
		SELECT @ErrorMessage = 'RESIDENCYSTATUS_' + @Ids
GO
