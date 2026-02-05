SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpNCustomUpdateContacts]
	@StampUser varchar(255),
	@ContactsId bigint,
	@CRMContactId bigint, -- This gets updated on the basis of owner
	@Owner varchar(16) = null,
	@RefContactType VARCHAR(255) = null,
	@Description varchar(500) = null,
	@Value VARCHAR(255) = null,
	@DefaultFg bit = 0,
	@ConcurrencyId bigint
AS
DECLARE @IndClientId bigint
-- Get IndigoClientId
SELECT @IndClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

IF @Owner = 'Client 2' 
	SELECT @CRMContactId = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId

EXEC CRM..SpNAuditContact @StampUser, @ContactsId, 'U'

UPDATE CRM..TContact 
SET CRMContactId = @CRMContactId, RefContactType = @RefContactType, [Description] = @Description,
	[Value] = @Value, DefaultFg = @DefaultFg, ConcurrencyId = ConcurrencyId + 1	
WHERE 
	ContactId = @ContactsId

IF @DefaultFg = 1
	Exec SpNCustomUpdateContactDefaultFg @ContactsId, @StampUser, @IndClientId, @CRMContactId, @RefContactType
GO
