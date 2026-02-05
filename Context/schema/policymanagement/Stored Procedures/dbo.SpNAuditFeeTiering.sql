SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFeeTiering]
	@StampUser VARCHAR (50),
	@FeeTieringId BIGINT,
	@StampAction CHAR(1)
AS

INSERT INTO TFeeTieringAudit (
	FeeTieringId,
	FeeId, 
	Threshold, 
	[Percentage], 
	TenantId, 
	ConcurrencyId, 
	StampAction, 
	StampDateTime, 
	StampUser) 
SELECT 
	FeeTieringId, 
	FeeId, 
	Threshold, 
	[Percentage], 
	TenantId, 
	ConcurrencyId, 
	@StampAction, 
	GetDate(), 
	@StampUser
FROM
	TFeeTiering
WHERE
	FeeTieringId = @FeeTieringId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
