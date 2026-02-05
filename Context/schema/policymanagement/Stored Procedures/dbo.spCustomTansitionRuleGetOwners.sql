SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[spCustomTansitionRuleGetOwners]
	@PolicyBusinessId Bigint,
	@ClientCount int = 0 OUTPUT,
	@ClientType varchar(10) = '' OUTPUT,
	@Owner1Id Bigint = null OUTPUT,
	@Owner1Name Varchar(255) = null  OUTPUT,
	@Owner2Id Bigint = null  OUTPUT,
	@Owner2Name Varchar(255) = null  OUTPUT,
	@ClientType2 Varchar(10) = null  OUTPUT
AS

--Declare @PolicyBusinessId bigint  = 2
--Declare @Owner1Id Bigint 
--	Declare @Owner2Id Bigint 
--	Declare @Owner1Name Varchar(255) 
--	Declare @Owner2Name Varchar(255)  


DECLARE @Owners TABLE (OwnerNumber int IDENTITY(1,1) PRIMARY KEY, ClientType VarChar(10),
	PolicyOwnerId bigint, CRMContactId bigint, Name Varchar(255)
)

	Insert into @Owners
	Select	Distinct 
		Case When CRM.PersonId IS Not NULL THen 'PERSON'
			 When CRM.CorporateId IS Not NULL THen 'CORPORATE'
			 When CRM.TrustId IS Not NULL THen 'TRUST'
		End,
		O.PolicyOwnerId, CRM.CRMContactId,
		 ISNULL(CRM.CorporateName,'') + ISNULL(CRM.FirstName,'') + ' ' + ISNULL(CRM.LastName, '')		
		FROM CRM..TCRMContact CRM 
		Inner Join TPolicyOwner O On O.CRMContactId = CRM.CRMContactId
		Inner Join TPolicyBusiness PB On PB.PolicyDetailId = O.PolicyDetailId
	Where 
		PB.PolicyBusinessId = @PolicyBusinessId
		
	Set @ClientCount = (Select count(CRMContactId) From @Owners Where IsNUll(CRMContactId, 0) != 0)
	-- If no clients exists, we can exit
	If @ClientCount = 0
		RETURN


	--Owner 1 required
	SELECT @Owner1Id = CRMContactId, @Owner1Name = Name, @ClientType = ClientType 
	FROM @Owners A WHERE OwnerNumber = 1
	
	--Owner 2 	not required
	SELECT @Owner2Id = CRMContactId, @Owner2Name = Name, @ClientType2 = ClientType FROM @Owners A WHERE OwnerNumber = 2
	
	