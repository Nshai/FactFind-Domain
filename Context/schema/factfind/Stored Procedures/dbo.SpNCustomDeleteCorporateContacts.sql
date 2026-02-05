SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteCorporateContacts]
	@StampUser varchar(255),
	@CorporateContactsId bigint,
	@ConcurrencyId int
AS
	EXEC CRM..SpDeleteContactByIdAndConcurrencyId @CorporateContactsId, @ConcurrencyId, @StampUser

	INSERT FactFind..TCorporateContactAudit(CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,
						STAMPACTION,STAMPDATETIME,STAMPUSER)

	SELECT CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,'D',getdate(),@StampUser
	FROM FactFind..TCorporateContact WHERE ContactId=@CorporateContactsId

	DELETE FROM FactFind..TCorporateContact
	WHERE ContactId=@CorporateContactsId



GO
