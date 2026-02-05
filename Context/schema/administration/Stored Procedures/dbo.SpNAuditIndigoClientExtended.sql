SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIndigoClientExtended]
	@StampUser varchar (255),
	@IndigoClientExtendedId bigint,
	@StampAction char(1)
AS

INSERT INTO TIndigoClientExtendedAudit
( IndigoClientId, FinancialYearStartMonth, Website, LogEventsTo,
		ConcurrencyId, SftpUserName,GcdContractFileFormat,GcdPersonFileFormat,FpfDocumentFileFormat,
	IndigoClientExtendedId, StampAction, StampDateTime, StampUser,DocumentGeneratorVersion, TerminationOn, StatusReason)
Select IndigoClientId, FinancialYearStartMonth, Website, LogEventsTo,
		ConcurrencyId, SftpUserName,GcdContractFileFormat,GcdPersonFileFormat,FpfDocumentFileFormat,
	IndigoClientExtendedId, @StampAction, GetDate(), @StampUser,DocumentGeneratorVersion, TerminationOn, StatusReason
FROM TIndigoClientExtended
WHERE IndigoClientExtendedId = @IndigoClientExtendedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
