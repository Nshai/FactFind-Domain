SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceType]
	@StampUser varchar (255),
	@AdviceTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceTypeAudit 
( Description, IntelligentOfficeAdviceType, ArchiveFg, IndigoClientId, 
		ConcurrencyId, 
	AdviceTypeId, StampAction, StampDateTime, StampUser, IsSystem) 
Select Description, IntelligentOfficeAdviceType, ArchiveFg, IndigoClientId, 
		ConcurrencyId, 
	AdviceTypeId, @StampAction, GetDate(), @StampUser, IsSystem
FROM TAdviceType
WHERE AdviceTypeId = @AdviceTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
