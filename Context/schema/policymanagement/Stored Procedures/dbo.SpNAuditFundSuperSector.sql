SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFundSuperSector]
	@StampUser varchar (255),
	@FundSuperSectorId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundSuperSectorAudit 
(		
	Name, IsArchived, TenantId, ConcurrencyId, FundSuperSectorId,
	StampAction, StampDateTime, StampUser
)
SELECT Name,IsArchived, TenantId, ConcurrencyId, FundSuperSectorId,
		@StampAction, GetDate(), @StampUser
FROM TFundSuperSector
WHERE FundSuperSectorId = @FundSuperSectorId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
	

GO
