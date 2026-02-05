SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteContacts]
	@StampUser varchar(255),
	@ContactsId bigint,
	@ConcurrencyId int
AS
	EXEC CRM..SpDeleteContactByIdAndConcurrencyId @ContactsId, @ConcurrencyId, @StampUser
GO
