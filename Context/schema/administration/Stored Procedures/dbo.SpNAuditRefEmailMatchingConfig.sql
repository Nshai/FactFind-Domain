SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEmailMatchingConfig]
	@StampUser varchar (255),
	@RefEmailMatchingConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEmailMatchingConfigAudit 
( MatchingConfigName, ConcurrencyId, 
	RefEmailMatchingConfigId, StampAction, StampDateTime, StampUser) 
Select MatchingConfigName, ConcurrencyId, 
	RefEmailMatchingConfigId, @StampAction, GetDate(), @StampUser
FROM TRefEmailMatchingConfig
WHERE RefEmailMatchingConfigId = @RefEmailMatchingConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
