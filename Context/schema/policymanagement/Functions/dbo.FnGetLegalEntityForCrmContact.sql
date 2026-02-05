SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetLegalEntityForCrmContact](@CrmContactId as bigint, @PaymentEntityId bigint)
--
-- Returns the Legal Entity Group Id for the crm contact
-- This does not deal with introducers 
-- 
RETURNS NUMERIC
AS
BEGIN
	DECLARE @GroupId bigint, @ParentId bigint
	DECLARE @Identifier varchar(64), @Image varchar(500), @Acknowledgements varchar(500), @LegalEntity bit
	Declare @PractitionerFG bit, @CompanyFG bit, @UserFg bit, @ClientFg bit, @RefIntroducerTypeId bigint
	

	Select @PractitionerFG = PractitionerFG, @CompanyFG = CompanyFG, @UserFg = UserFg, 
		@ClientFg = ClientFg, @RefIntroducerTypeId = RefIntroducerTypeId
	From Commissions.dbo.TPaymentEntity
	Where PaymentEntityId = @PaymentEntityId

	-- Select * From  Commissions.dbo.TPaymentEntity Where PaymentEntityId = 476

	If IsNull(@RefIntroducerTypeId, 0) <> 0
	Begin
		-- not allowed
		--Raiserror('Introducers not catered for in FnGetLegalEntityForCrmContact', 16, 1)
		Return 0
	End

	If IsNull(@ClientFg, 0) = 1
	Begin
		--Get the current adviser crm contact id
		Select @CrmContactId = CurrentAdviserCRMId
		From CRM.dbo.TCRMContact
		Where CRMContactId = @CrmContactId
	End


	If IsNull(@CompanyFG, 0) = 0
	Begin
		-- Get Immediate Group Information for the specified user
		SELECT 
			@GroupId = G.GroupId,
			@Identifier = G.Identifier,
			@Image = ISNULL(GroupImageLocation, ''), 
			@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
			@LegalEntity = LegalEntity
		FROM Administration.dbo.TGroup G
		Inner Join Administration.dbo.TUser U 
			On U.GroupId = G.GroupId 
		Where U.CRMContactId = @CrmContactId
			--JOIN CRM..TPractitioner P ON P.CRMContactId = U.CRMContactId AND P.PractitionerId = @AdviserId
	End
	Else
	Begin
		SELECT 
			@GroupId = GroupId,
			@Identifier = Identifier,
			@Image = ISNULL(GroupImageLocation, ''), 
			@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
			@LegalEntity = LegalEntity
		FROM Administration.dbo.TGroup 
		Where CRMContactId = @CrmContactId
	End

	IF @LegalEntity = 1
	BEGIN
		RETURN @GroupId
	END
	ELSE
	BEGIN
		-- Find the parent
		SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @GroupId

		WHILE @ParentId > 0 
		BEGIN	
			-- Get Group Information for the parent group
			SELECT 
				@Image = ISNULL(GroupImageLocation, ''), 
				@Acknowledgements = ISNULL(AcknowledgementsLocation, ''),
				@Identifier = Identifier,
				@LegalEntity = LegalEntity,
				@GroupId=GroupId
			FROM 
				Administration..TGroup 
			WHERE 
				GroupId = @ParentId

			IF @LegalEntity = 1
			BEGIN
				RETURN @GroupId
			END
			ELSE
				SELECT @ParentId = ISNULL(ParentId, 0) FROM Administration..TGroup WHERE GroupId = @ParentId
		END
	END

	RETURN 0
END



GO
