SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckNationality]
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
	
	Declare @Valid1 int = 0
	Declare @Valid2 int = 0

	set @Valid1 = 
		(
			Select count(1) From CRM..TPerson A
			Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
			Where B.CRMContactId = @Owner1Id
			And A.RefNationalityId IS NOT NULL
		)

	If(@Owner2Id IS NOT NULL)
	Begin

		Set @Valid2 = 
		(
			Select count(1) From CRM..TPerson A
			Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
			Where B.CRMContactId = @Owner2Id
			And A.RefNationalityId IS NOT NULL			
		)

		--IO-46797 -- if Owner2 is not a Person , then ignore
		if (@Valid2 = 0)
		Begin
			Set @Valid2= (Select count(1) From CRM..TCRMContact Where CRMContactId = @Owner2Id AND (PersonId IS NULL))
		End

	End

	if (@Valid1 = 0)
		select @ErrorMessage = 'OWNER1'
	if (@Valid2 = 0 and @Owner2Id is not null and @Valid1 > 0)
		select @ErrorMessage = 'OWNER2'
	if (@Valid2 = 0 and @Owner2Id is not null and @Valid1 = 0)
		select @ErrorMessage = 'OWNER1+OWNER2'

		
	--Add Owner Data for side bar link generator
	IF(LEN(ISNULL(@ErrorMessage, '')) > 0)
	BEGIN		
		SET @ErrorMessage = @ErrorMessage + '_::Owner1Id=' + CONVERT(varchar(50), ISNULL(@Owner1Id,''))
										  + '::Owner1Name=' + CONVERT(varchar(255), ISNULL(@Owner1Name,''))
										  + '::Owner2Id=' + CONVERT(varchar(50), ISNULL(@Owner2Id,''))
										  + '::Owner2Name=' + CONVERT(varchar(255), ISNULL(@Owner2Name,''))

	END				  
		

GO
