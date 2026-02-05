SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAssuredLife]
	@StampUser varchar (255),
	@AssuredLifeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAssuredLifeAudit
( ProtectionId, PartyId, BenefitId, AdditionalBenefitId, IndigoClientId, 
	Title, FirstName, LastName, DOB, GenderType, OrderKey,
	ConcurrencyId, AssuredLifeId, StampAction, StampDateTime, StampUser,PlanMigrationRef,PolicyBusinessId) 
	
SELECT ProtectionId, PartyId, BenefitId, AdditionalBenefitId, IndigoClientId, 
	Title, FirstName, LastName, DOB, GenderType, OrderKey,
	ConcurrencyId, AssuredLifeId, @StampAction, GetDate(), @StampUser,PlanMigrationRef,PolicyBusinessId
FROM TAssuredLife
WHERE AssuredLifeId = @AssuredLifeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
