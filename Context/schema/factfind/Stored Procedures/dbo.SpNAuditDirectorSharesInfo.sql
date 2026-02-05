SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDirectorSharesInfo]
	@StampUser varchar (255),
	@DirectorSharesInfoId bigint,
	@StampAction char(1)
AS

INSERT INTO TDirectorSharesInfoAudit 
( CRMContactId, AgreementForSharesYesNo, AgreementForSharesType, PowerToPurchaseSharesYesNo, 
		notes, ConcurrencyId, 
	DirectorSharesInfoId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, AgreementForSharesYesNo, AgreementForSharesType, PowerToPurchaseSharesYesNo, 
		notes, ConcurrencyId, 
	DirectorSharesInfoId, @StampAction, GetDate(), @StampUser
FROM TDirectorSharesInfo
WHERE DirectorSharesInfoId = @DirectorSharesInfoId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
