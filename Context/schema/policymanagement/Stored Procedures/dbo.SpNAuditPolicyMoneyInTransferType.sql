SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPolicyMoneyInTransferType]
	@StampUser varchar (255),
	@PolicyMoneyInTransferTypeId int,
	@StampAction char(1)
AS

INSERT INTO TPolicyMoneyInTransferTypeAudit
	( PolicyMoneyInId, TransferTypeId, ConcurrencyId, PolicyMoneyInTransferTypeId, StampAction, StampDateTime, StampUser)   
Select 
	policymoneyinid, transferTypeId, concurrencyId, policyMoneyInTransferTypeId, @StampAction, GetDate(), @StampUser  
FROM TPolicyMoneyInTransferType  
WHERE PolicyMoneyInTransferTypeId = @PolicyMoneyInTransferTypeId    

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
