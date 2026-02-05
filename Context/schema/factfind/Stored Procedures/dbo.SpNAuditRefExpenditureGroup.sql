SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefExpenditureGroup]
	@StampUser varchar (255),
	@RefExpenditureGroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefExpenditureGroupAudit 
(ConcurrencyId, Name, Ordinal, [IsConsolidateEnabled],
	RefExpenditureGroupId, TenantId, RegionCode, Attributes, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, Name, Ordinal, [IsConsolidateEnabled],
	RefExpenditureGroupId, TenantId, RegionCode, Attributes, @StampAction, GetDate(), @StampUser
FROM TRefExpenditureGroup
WHERE RefExpenditureGroupId = @RefExpenditureGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
