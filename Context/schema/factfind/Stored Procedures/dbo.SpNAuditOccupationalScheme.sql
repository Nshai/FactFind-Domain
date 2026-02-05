SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOccupationalScheme]
	@StampUser varchar (255),
	@OccupationalSchemeId bigint,
	@StampAction char(1)
AS

INSERT INTO TOccupationalSchemeAudit 
( CRMContactId, NameOfScheme, TypeOfScheme, Insurer, 
		StartDate, PlanContractedOutOfS2P, PaymentBasis, ConcurrencyId, 
		
	OccupationalSchemeId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NameOfScheme, TypeOfScheme, Insurer, 
		StartDate, PlanContractedOutOfS2P, PaymentBasis, ConcurrencyId, 
		
	OccupationalSchemeId, @StampAction, GetDate(), @StampUser
FROM TOccupationalScheme
WHERE OccupationalSchemeId = @OccupationalSchemeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
