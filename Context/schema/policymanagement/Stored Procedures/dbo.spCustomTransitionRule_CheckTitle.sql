SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckTitle]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS
	
	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)
	Declare @ClientType2 Varchar(10)

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT,
										@ClientType2 OUTPUT
	
	
	Declare @validClientType varchar(6) = 'PERSON'

	-- If no person clients exists, we can exit
	If @ClientType != @validClientType AND @ClientType2 != @validClientType
		RETURN(0) 
	
	Declare @Valid1 int = 0
	Declare @Valid2 int = 0

	If (@ClientType = @validClientType)
	Begin
	set @Valid1 = 
		(
			Select count(1) From CRM..TPerson A
			Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
			Where B.CRMContactId = @Owner1Id
			AND ISNULL(Title, '') != ''
		)
	End
	Else set @Valid1 = 1

	If(@Owner2Id IS NOT NULL AND @ClientType2 = @validClientType)
	Begin
		set @Valid2 = 
		(
			Select count(1) From CRM..TPerson A
			Inner join CRM..TCRMContact B ON A.PersonId = B.PersonId
			Where B.CRMContactId = @Owner2Id
			AND ISNULL(Title, '') != ''
		)
	End
	Else set @Valid2 = 1

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
