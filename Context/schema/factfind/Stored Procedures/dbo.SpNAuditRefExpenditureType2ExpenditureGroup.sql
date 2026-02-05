SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefExpenditureType2ExpenditureGroup]
	@StampUser varchar (255),
	@RefExpenditureType2ExpenditureGroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefExpenditureType2ExpenditureGroupAudit 
(RefExpenditureType2ExpenditureGroupId, ExpenditureTypeId, ExpenditureGroupId, StampAction, StampDateTime, StampUser)
SELECT  RefExpenditureType2ExpenditureGroupId, ExpenditureTypeId, ExpenditureGroupId, @StampAction, GetDate(), @StampUser
FROM TRefExpenditureType2ExpenditureGroup
WHERE RefExpenditureType2ExpenditureGroupId = @RefExpenditureType2ExpenditureGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
