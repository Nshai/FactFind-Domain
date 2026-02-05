SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


CREATE procedure [dbo].[spCustomTransitionRule_CheckPostcode]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(1024) output
AS

BEGIN

	DECLARE @Owners TABLE (OwnerNumber int IDENTITY(1,1) PRIMARY KEY, 
							PolicyOwnerId bigint, CRMContactId bigint, Name varchar(255))

	-- get policy owners
	INSERT INTO @Owners (PolicyOwnerId, CRMContactId, Name)
	SELECT	 po.PolicyOwnerId,
			 po.CRMContactId,
			 ISNULL(con.CorporateName,'') + ISNULL(con.FirstName,'') + ' ' + ISNULL(con.LastName, '')
	FROM	 TPolicyOwner po
	INNER JOIN	 TPolicyDetail pd ON pd.PolicyDetailId = po.PolicyDetailId
	INNER JOIN	 TPolicyBusiness pb ON pb.PolicyDetailId = pd.PolicyDetailId
	INNER JOIN CRM..TCRMContact con on po.CRMContactId = con.CRMContactId
	WHERE	 pb.PolicyBusinessId = @PolicyBusinessId
	ORDER BY po.PolicyOwnerId
	
		
	
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)  

	SELECT @Owner1Id = CRMContactId, @Owner1Name = Name	FROM @Owners A WHERE OwnerNumber = 1	
	SELECT @Owner2Id = CRMContactId, @Owner2Name = Name FROM @Owners A WHERE OwnerNumber = 2
	

	--make sure that there is an address with a Postcode
	declare @ValidAddressCount1 int
	declare @ValidAddressCount2 int

	set @ValidAddressCount1 = 
		(
		select count(ast.AddressStoreId)
		FROM CRM..TAddressStore ast
		JOIN CRM..TAddress a ON a.AddressStoreId = ast.AddressStoreId
		WHERE a.CRMContactId = @Owner1Id
		AND len(ISNULL(ast.PostCode,'')) > 0
		)

	if @Owner2Id is not null
	begin
		set @ValidAddressCount2 = 
		(
		select count(ast.AddressStoreId)
		FROM CRM..TAddressStore ast
		JOIN CRM..TAddress a ON a.AddressStoreId = ast.AddressStoreId
		WHERE a.CRMContactId = @Owner2Id
		AND len(ISNULL(ast.PostCode,'')) > 0
		)
		
	end

	if (@ValidAddressCount1 = 0)
		select @ErrorMessage = 'OWNER1'
	if (@ValidAddressCount2 = 0 and @Owner2Id is not null and @ValidAddressCount1 > 0)
		select @ErrorMessage = 'OWNER2'
	if (@ValidAddressCount2 = 0 and @Owner2Id is not null and @ValidAddressCount1 = 0)
		select @ErrorMessage = 'OWNER1+OWNER2'
	
	Declare @OwnerId bigint
	
	--Add Owner Data for side bar link generator
	IF(LEN(ISNULL(@ErrorMessage, '')) > 0)
	BEGIN		
		SET @ErrorMessage = @ErrorMessage + '_::Owner1Id=' + CONVERT(varchar(50), ISNULL(@Owner1Id,''))
										  + '::Owner1Name=' + CONVERT(varchar(255), ISNULL(@Owner1Name,''))
										  + '::Owner2Id=' + CONVERT(varchar(50), ISNULL(@Owner2Id,''))
										  + '::Owner2Name=' + CONVERT(varchar(255), ISNULL(@Owner2Name,''))

		
	END			
		
END


GO
