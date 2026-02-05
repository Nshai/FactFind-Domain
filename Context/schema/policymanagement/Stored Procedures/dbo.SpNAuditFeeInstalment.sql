SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFeeInstalment]
	@StampUser varchar (255),
	@FeeInstalmentId bigint,
	@StampAction char(1)
AS
BEGIN

	INSERT INTO dbo.TFeeInstalmentAudit
			(
			 FeeId,NextInstalmentDate,
			 [ConcurrencyId],InstalmentCount,
			 FeeInstalmentId,[StampAction],
			 [StampDateTime], [StampUser]
			)	
	SELECT 	 FeeId,NextInstalmentDate,
			 ConcurrencyId,InstalmentCount,
			 FeeInstalmentId,@StampAction,
			 GetDate(), @StampUser
	FROM dbo.TFeeInstalment
	WHERE FeeInstalmentId = @FeeInstalmentId

END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
