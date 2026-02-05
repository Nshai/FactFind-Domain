SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNAuditPlanNote] 
	@StampUser varchar(255),
	@PlanNoteId	int,
	@StampAction char(1)
AS
INSERT INTO [dbo].[TPlanNoteAudit] (
	PlanNoteId,	PlanId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, MigrationRef, PlanMigrationRef, StampAction, StampDateTime, StampUser)
SELECT
	PlanNoteId,	PlanId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, MigrationRef, PlanMigrationRef, @StampAction, GETDATE(), @StampUser
FROM
	dbo.TPlanNote
WHERE
	PlanNoteId = @PlanNoteId
GO