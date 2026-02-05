SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditExpectations]
	@StampUser varchar (255),
	@ExpectationsId bigint,
	@StampAction char(1)
AS
BEGIN

	INSERT INTO dbo.TExpectationsAudit
			(
			 [ExpectationsId], [PolicyBusinessId], [FeeId], [Date], [NetAmount],[TotalAmount],[CalculatedAmount],
			 [TenantId],[ConcurrencyId],[StampAction], [StampDateTime], [StampUser], [IsManual]
			)	
	SELECT 	 [ExpectationsId], [PolicyBusinessId], [FeeId], [Date], [NetAmount],[TotalAmount],[CalculatedAmount],
			 [TenantId],[ConcurrencyId],@StampAction, GetDate(), @StampUser, [IsManual]
	FROM dbo.TExpectations
	WHERE ExpectationsId = @ExpectationsId

END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
