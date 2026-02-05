SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckDPAQuestions]
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
										
	Declare @Valid1 int = 0
	Declare @Valid2 int = 0

	set @Valid1 = 
		(
			Select count(1) From CRM..TDataProtectionAct A
			Where A.CRMContactId = @Owner1Id
			And ISNULL(A.IsAwareOfRights, 2) in (0, 1) --No/Yes
			And ISNULL(A.HasGivenConsent, 2) in (0, 1) --No/Yes
			And ISNULL(A.IsAwareOfAccess, 2) in (0, 1) --No/Yes
		)

	If(@Owner2Id IS NOT NULL)
	Begin
		set @Valid2 = 
		(
			Select count(1) From CRM..TDataProtectionAct A
			Where A.CRMContactId = @Owner2Id
			And ISNULL(A.IsAwareOfRights, 2) in (0, 1) --No/Yes
			And ISNULL(A.HasGivenConsent, 2) in (0, 1) --No/Yes
			And ISNULL(A.IsAwareOfAccess, 2) in (0, 1) --No/Yes
		)
	end

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
