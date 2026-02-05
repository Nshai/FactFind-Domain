SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeStatusTransition] 
	@StampUser varchar (255),
	@FeeStatusTransitionId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO [TFeeStatusTransitionAudit] 
( [FeeRefStatusIdFrom]
      ,[FeeRefStatusIdTo]
      ,[ConcurrencyId]
      ,[FeeStatusTransitionId], [StampAction], [StampDateTime], [StampUser]) 
		
Select [FeeRefStatusIdFrom]
      ,[FeeRefStatusIdTo]
      ,[ConcurrencyId]
      ,[FeeStatusTransitionId], @StampAction, GetDate(), @StampUser
FROM [TFeeStatusTransition]
WHERE FeeStatusTransitionId = @FeeStatusTransitionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
END
GO
