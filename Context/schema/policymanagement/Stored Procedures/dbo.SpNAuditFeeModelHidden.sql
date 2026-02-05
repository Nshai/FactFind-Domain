SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFeeModelHidden]
	@StampUser varchar (255),
	@FeeModelHiddenId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeModelHiddenAudit 
( FeeModelId, TenantId, ConcurrencyId, 
		
	FeeModelHiddenId, StampAction, StampDateTime, StampUser,GroupId) 
Select FeeModelId, TenantId, ConcurrencyId, 		
	FeeModelHiddenId, @StampAction, GetDate(), @StampUser,GroupId
FROM TFeeModelHidden
WHERE FeeModelHiddenId = @FeeModelHiddenId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
