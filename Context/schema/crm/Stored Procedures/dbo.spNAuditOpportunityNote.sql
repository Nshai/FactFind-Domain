SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNAuditOpportunityNote] 
	@StampUser varchar(255),
	@OpportunityNoteId	int,
	@StampAction char(1)
AS
INSERT INTO [dbo].[TOpportunityNoteAudit] (
	OpportunityNoteId, TenantId, OpportunityId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT
	OpportunityNoteId, TenantId, OpportunityId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, @StampAction, GETDATE(), @StampUser
FROM
	dbo.TOpportunityNote
WHERE
	OpportunityNoteId = @OpportunityNoteId
GO