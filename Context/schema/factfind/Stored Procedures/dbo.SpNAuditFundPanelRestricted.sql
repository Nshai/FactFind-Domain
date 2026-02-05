SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFundPanelRestricted]
	@StampUser varchar (255),
	@FundPanelRestrictedId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundPanelRestrictedAudit 
(TenantId,
RoleId,
ConcurrencyId,
FundPanelRestrictedId,
StampAction,
StampUser,
StampDateTime)
SELECT  
TenantId,
RoleId,
ConcurrencyId,
FundPanelRestrictedId,
@StampAction,
@StampUser,
getdate()
FROM TFundPanelRestricted
WHERE FundPanelRestrictedId = @FundPanelRestrictedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
