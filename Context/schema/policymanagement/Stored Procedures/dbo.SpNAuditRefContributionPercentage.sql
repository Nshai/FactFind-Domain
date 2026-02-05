SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefContributionPercentage]
	@StampUser varchar (255),
	@RefContributionPercentageId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefContributionPercentageAudit 
( Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefContributionPercentageId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefContributionPercentageId, @StampAction, GetDate(), @StampUser
FROM TRefContributionPercentage
WHERE RefContributionPercentageId = @RefContributionPercentageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
