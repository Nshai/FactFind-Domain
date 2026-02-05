SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioClient]
	@StampUser varchar (255),
	@PortfolioClientId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioClientAudit 
( PortfolioId, CreatedBy, CreatedDate, CRMContactId, 
		ConcurrencyId, 
	PortfolioClientId, StampAction, StampDateTime, StampUser) 
Select PortfolioId, CreatedBy, CreatedDate, CRMContactId, 
		ConcurrencyId, 
	PortfolioClientId, @StampAction, GetDate(), @StampUser
FROM TPortfolioClient
WHERE PortfolioClientId = @PortfolioClientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
