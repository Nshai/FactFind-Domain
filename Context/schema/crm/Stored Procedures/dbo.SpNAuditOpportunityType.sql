SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditOpportunityType]
	@StampUser varchar (255),
	@OpportunityTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TOpportunityTypeAudit 
( OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, 
		InvestmentDefault, RetirementDefault, ConcurrencyId, 
	OpportunityTypeId, StampAction, StampDateTime, StampUser, ObjectiveType) 
Select OpportunityTypeName, IndigoClientId, ArchiveFG, SystemFG, 
		InvestmentDefault, RetirementDefault, ConcurrencyId, 
	OpportunityTypeId, @StampAction, GetDate(), @StampUser, ObjectiveType
FROM TOpportunityType
WHERE OpportunityTypeId = @OpportunityTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
