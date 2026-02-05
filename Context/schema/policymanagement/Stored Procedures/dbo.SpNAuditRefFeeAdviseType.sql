SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefFeeAdviseType]
	@StampUser varchar (255),
	@RefFeeAdviseTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFeeAdviseTypeAudit
( RefFeeAdviseTypeName,  ConcurrencyId, RefFeeAdviseTypeId, StampAction, StampDateTime, StampUser) 
SELECT RefFeeAdviseTypeName, ConcurrencyId, RefFeeAdviseTypeId, @StampAction, GetDate(), @StampUser
FROM TRefFeeAdviseType
WHERE RefFeeAdviseTypeId = @RefFeeAdviseTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
