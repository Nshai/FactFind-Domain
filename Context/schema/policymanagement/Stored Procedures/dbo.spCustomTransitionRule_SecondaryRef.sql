SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_SecondaryRef]  
  @PolicyBusinessId bigint,  
  @ErrorMessage varchar(512) output  
AS  


	DECLARE @ClientCount tinyint, @NiCount tinyint

	DECLARE @Owners TABLE (OwnerNumber int IDENTITY(1,1) PRIMARY KEY, 
		PolicyOwnerId bigint, CRMContactId bigint, SecondaryRef Varchar(100),
		Name Varchar(255)
	)
  
	Insert into @Owners
	Select
		O.PolicyOwnerId, CRM.CRMContactId, CRM.AdditionalRef,
		 ISNULL(CRM.CorporateName,'') + ISNULL(CRM.FirstName,'') + ' ' + ISNULL(CRM.LastName, '')
		From 
		CRM..TPerson P
		Inner Join CRM..TCRMContact CRM On CRM.PersonId = P.PersonId
		Inner Join TPolicyOwner O On O.CRMContactId = CRM.CRMContactId
		Inner Join TPolicyBusiness PB On PB.PolicyDetailId = O.PolicyDetailId
	Where 
		PB.PolicyBusinessId = @PolicyBusinessId
		And CRM.PersonId Is Not Null

	Set @ClientCount = (Select count(CRMContactId) From @Owners Where IsNUll(CRMContactId, 0) != 0)
	-- If no person clients exists, we can exit
	If @ClientCount = 0
		RETURN(0) 

	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	SELECT @Owner1Id = CRMContactId, @Owner1Name = Name	FROM @Owners A WHERE OwnerNumber = 1	
	SELECT @Owner2Id = CRMContactId, @Owner2Name = Name FROM @Owners A WHERE OwnerNumber = 2

	Declare @Valid1 int = 0
	Declare @Valid2 int = 0

	set @Valid1 = 
		(
			Select count(1) From @Owners WHERE CRMContactId = @Owner1Id AND IsNUll(SecondaryRef, '') != ''
		)

	If(@Owner2Id IS NOT NULL)
	Begin
		set @Valid2 = 
		(
			Select count(1) From @Owners WHERE CRMContactId = @Owner2Id AND IsNUll(SecondaryRef, '') != ''
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
