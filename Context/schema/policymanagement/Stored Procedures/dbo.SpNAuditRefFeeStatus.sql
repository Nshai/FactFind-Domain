SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRefFeeStatus]
	@StampUser varchar (255),
	@RefFeeStatusId bigint,
	@StampAction char(1)
AS

	Insert into TRefFeeStatusAudit (RefFeeStatusId, [Name],ConcurrencyId, StampAction, StampDateTime, StampUser)
	select RefFeeStatusId, [Name], ConcurrencyId, @StampAction, GetDate(), @StampUser from TRefFeeStatus
	where RefFeeStatusId = @RefFeeStatusId



IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
