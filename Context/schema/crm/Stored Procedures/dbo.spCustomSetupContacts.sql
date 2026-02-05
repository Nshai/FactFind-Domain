SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomSetupContacts] 
	@StampUser varchar (255),
	@IndClientId bigint,
	@CRMContactId bigint,
	@Telephone as Varchar(50) = '',
	@Fax as Varchar(50) = '',
	@Email as Varchar(50) = '',
	@Mobile as Varchar(50) = '',
	@Web as Varchar(50) = ''
AS
/*
	09 Jan 2003
	MT: 	Optimised to Create all these Contacts in One Hit for the AddClientWizard
*/


	IF @Telephone <> ''
	BEGIN		
		--Add Contact
		EXEC spCreateContact @StampUser, @IndClientId, @CRMContactId, 'Telephone', 'Telephone', @Telephone, 1				
	END

	IF @Fax <> ''
	BEGIN		
		--Add Contact
		EXEC spCreateContact @StampUser, @IndClientId, @CRMContactId, 'Fax', 'Fax', @Fax, 1			
	END

	
	IF @Email <> ''
	BEGIN		
		--Add Contact
		EXEC spCreateContact @StampUser, @IndClientId, @CRMContactId, 'E-Mail', 'E-Mail', @Email, 1
	END

	IF @Mobile <> ''
	BEGIN		
		--Add Contact
		EXEC spCreateContact @StampUser, @IndClientId, @CRMContactId, 'Mobile', 'Mobile', @Mobile, 1
	END


	IF @Web <> ''
	BEGIN
		--Add Contact
		EXEC spCreateContact @StampUser, @IndClientId, @CRMContactId, 'Web Site', 'Web Site', @Web, 1
	END
GO
