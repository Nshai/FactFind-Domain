SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEmailStorageConfig]
	@StampUser varchar (255),
	@RefEmailStorageConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEmailStorageConfigAudit 
( StorageConfigName, IsTenantOnly, ConcurrencyId, 
	RefEmailStorageConfigId, StampAction, StampDateTime, StampUser) 
Select StorageConfigName, IsTenantOnly, ConcurrencyId, 
	RefEmailStorageConfigId, @StampAction, GetDate(), @StampUser
FROM TRefEmailStorageConfig
WHERE RefEmailStorageConfigId = @RefEmailStorageConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
