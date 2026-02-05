SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpConvertLeadToClient]
	@TenantId int,
	@PartyId int,
	@StampUser int
AS
IF NOT EXISTS (SELECT 1 FROM CRM..TCRMContact WHERE CRMContactId = @PartyId AND IndClientId = @TenantId)
	RETURN;

-- Audit
EXEC SpNAuditCRMContact @StampUser, @PartyId, 'U'

-- Update the customer status 
UPDATE  
	dbo.TCRMContact
SET
	RefCRMContactStatusId = 1
WHERE
	CRMContactId = @PartyId
	AND IndClientId = @TenantId

-- Convert Lead Notes to Client Notes
EXEC dbo.[nio_SpConvertLeadNotesToClientNotes] @PartyId, @TenantId, @StampUser
GO
