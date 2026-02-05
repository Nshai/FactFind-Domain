SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditTaskExtended]
	@StampUser varchar (255),
	@TaskExtendedId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO dbo.TTaskExtendedAudit (
		[TaskId], [MigrationRef], [IndigoClientId], [ConcurrencyId], 
		[TaskExtendedId], [StampAction], [StampDateTime], [StampUser]
		) 
	SELECT
		[TaskId], [MigrationRef], [IndigoClientId], [ConcurrencyId], 
		[TaskExtendedId], @StampAction, GetDate(), @StampUser
	FROM dbo.TTaskExtended
	WHERE TaskExtendedId = @TaskExtendedId
END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
