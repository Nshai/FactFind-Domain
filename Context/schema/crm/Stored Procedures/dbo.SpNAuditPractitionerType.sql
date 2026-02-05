SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPractitionerType]
	@StampUser varchar (255),
	@PractitionerTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPractitionerTypeAudit 
( IndigoClientId, Description, CreatedDate, ConcurrencyId, 
		
	PractitionerTypeId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, Description, CreatedDate, ConcurrencyId, 
		
	PractitionerTypeId, @StampAction, GetDate(), @StampUser
FROM TPractitionerType
WHERE PractitionerTypeId = @PractitionerTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
