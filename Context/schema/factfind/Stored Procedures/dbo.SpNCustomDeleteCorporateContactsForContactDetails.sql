SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteCorporateContactsForContactDetails]
	@StampUser varchar(255),
	@CorporateContactsId bigint
AS
	EXEC CRM..SpDeleteContactByIdForContactDetails @CorporateContactsId, @StampUser

	INSERT FactFind..TCorporateContactAudit(CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,
						STAMPACTION,STAMPDATETIME,STAMPUSER)

	SELECT CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,'D',getdate(),@StampUser
	FROM FactFind..TCorporateContact WHERE ContactId=@CorporateContactsId

	DELETE FROM FactFind..TCorporateContact
	WHERE ContactId=@CorporateContactsId
GO
