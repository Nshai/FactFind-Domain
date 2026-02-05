SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBankDetail]
	@StampUser varchar (255),
	@BankDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TBankDetailAudit 
( IndClientId, CRMOwnerId, SortCode, AccName, 
		AccNumber, CorporateId, CRMBranchId, RefAccTypeId, 
		RefAccUseId, AccBalance, ConcurrencyId, 
	BankDetailId, StampAction, StampDateTime, StampUser) 
Select IndClientId, CRMOwnerId, SortCode, AccName, 
		AccNumber, CorporateId, CRMBranchId, RefAccTypeId, 
		RefAccUseId, AccBalance, ConcurrencyId, 
	BankDetailId, @StampAction, GetDate(), @StampUser
FROM TBankDetail
WHERE BankDetailId = @BankDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
