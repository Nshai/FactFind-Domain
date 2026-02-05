SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefExpenditureType]
	@StampUser varchar (255),
	@RefExpenditureTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefExpenditureTypeAudit 
(ConcurrencyId, RefExpenditureGroupId, Name, Ordinal, 
	RefExpenditureTypeId, Attributes, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, RefExpenditureGroupId, Name, Ordinal, 
	RefExpenditureTypeId, Attributes, @StampAction, GetDate(), @StampUser
FROM TRefExpenditureType
WHERE RefExpenditureTypeId = @RefExpenditureTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
