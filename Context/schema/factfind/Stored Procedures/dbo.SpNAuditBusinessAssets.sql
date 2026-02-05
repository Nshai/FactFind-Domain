SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBusinessAssets]
	@StampUser varchar (255),
	@BusinessAssetsId bigint,
	@StampAction char(1)
AS

INSERT INTO TBusinessAssetsAudit 
( CRMContactId, Property, Equipment, Vehicles, 
		BankAndBuilding, OtherInvestments, TotalAssets, Notes, 
		ConcurrencyId, 
	BusinessAssetsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Property, Equipment, Vehicles, 
		BankAndBuilding, OtherInvestments, TotalAssets, Notes, 
		ConcurrencyId, 
	BusinessAssetsId, @StampAction, GetDate(), @StampUser
FROM TBusinessAssets
WHERE BusinessAssetsId = @BusinessAssetsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
