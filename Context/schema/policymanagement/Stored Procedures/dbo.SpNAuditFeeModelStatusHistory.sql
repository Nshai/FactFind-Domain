SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditFeeModelStatusHistory]
	@StampUser varchar (255),
	@FeeModelStatusHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeModelStatusHistoryAudit 
( FeeModelId, Version, RefFeeModelStatusId, ActionType, 
		UpdatedDate, UpdatedBy, FeeModelStatusHistoryNote, TenantId, ConcurrencyId, 
		
	FeeModelStatusHistoryId, StampAction, StampDateTime, StampUser) 
Select FeeModelId, Version, RefFeeModelStatusId, ActionType, 
		UpdatedDate, UpdatedBy, FeeModelStatusHistoryNote, TenantId, ConcurrencyId, 
		
	FeeModelStatusHistoryId, @StampAction, GetDate(), @StampUser
FROM TFeeModelStatusHistory
WHERE FeeModelStatusHistoryId = @FeeModelStatusHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
