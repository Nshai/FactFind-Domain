SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefContributionType]
	@StampUser varchar (255),
	@RefContributionTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefContributionTypeAudit 
( RefContributionTypeName, RetireFg, ConcurrencyId, 
	RefContributionTypeId, StampAction, StampDateTime, StampUser) 
Select RefContributionTypeName, RetireFg, ConcurrencyId, 
	RefContributionTypeId, @StampAction, GetDate(), @StampUser
FROM TRefContributionType
WHERE RefContributionTypeId = @RefContributionTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
