SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPortfolioConstruction]
	@StampUser varchar (255),
	@PortfolioConstructionId bigint,
	@StampAction char(1)
AS

INSERT INTO TPortfolioConstructionAudit 
( CRMContactId, CreatedDate, Status, DocVersionId, 
		XmlContent, ConcurrencyId, 
	PortfolioConstructionId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, CreatedDate, Status, DocVersionId, 
		XmlContent, ConcurrencyId, 
	PortfolioConstructionId, @StampAction, GetDate(), @StampUser
FROM TPortfolioConstruction
WHERE PortfolioConstructionId = @PortfolioConstructionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
