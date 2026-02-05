SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateContacts]
	@StampUser varchar (255),
	@CRMContactId bigint, -- This gets updated on the basis of owner
	@Owner varchar(16) = NULL,
	@RefContactType varchar (50) = NULL,
	@Description varchar(500) = NULL,
	@Value varchar (255) = NULL,
	@DefaultFg tinyint = 0
AS
SET NOCOUNT ON
DECLARE @ContactId bigint, @IndClientId bigint
-- Get IndigoClientId
SELECT @IndClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

IF @Owner = 'Client 2' 
	SELECT @CRMContactId = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId

INSERT INTO Crm..TContact (IndClientId, CRMContactId, RefContactType, [Description], Value, DefaultFg, ConcurrencyId) 
VALUES ( @IndClientId, @CRMContactId, @RefContactType, @Description, @Value, @DefaultFg, 1) 

SELECT @ContactId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditContact @StampUser, @ContactId, 'C'

If @DefaultFg = 1
	Exec SpNCustomUpdateContactDefaultFg @ContactId, @StampUser, @IndClientId, @CRMContactId, @RefContactType

SELECT @ContactId AS ContactsId
GO
