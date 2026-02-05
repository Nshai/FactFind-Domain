SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefFeeType]
	@StampUser varchar (255),
	@RefFeeTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFeeTypeAudit 
( FeeTypeName, RefVATId, FeeFg, RetainerFg, 
		ConcurrencyId, 
	RefFeeTypeId, StampAction, StampDateTime, StampUser) 
Select FeeTypeName, RefVATId, FeeFg, RetainerFg, 
		ConcurrencyId, 
	RefFeeTypeId, @StampAction, GetDate(), @StampUser
FROM TRefFeeType
WHERE RefFeeTypeId = @RefFeeTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
