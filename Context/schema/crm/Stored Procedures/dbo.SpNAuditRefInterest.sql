SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefInterest]
	@StampUser varchar (255),
	@RefInterestId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefInterestAudit 
( Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, 
		Probability, LeadVersionFG, IndigoClientId, ConcurrencyId, 	
	RefInterestId, StampAction, StampDateTime, StampUser, ArchiveFG, Ordinal, SystemFG, DefaultFG) 
Select Descriptor, Interest, OpportunityTypeId, OpportunityCreationFg, 
		Probability, LeadVersionFG, IndigoClientId, ConcurrencyId, 
		
	RefInterestId, @StampAction, GetDate(), @StampUser, ArchiveFG, Ordinal, SystemFG, DefaultFG
FROM TRefInterest
WHERE RefInterestId = @RefInterestId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
