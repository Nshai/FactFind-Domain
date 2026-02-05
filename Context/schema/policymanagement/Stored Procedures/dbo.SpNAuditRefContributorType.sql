SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefContributorType]
	@StampUser varchar (255),
	@RefContributorTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefContributorTypeAudit 
( RefContributorTypeName, RetireFg, ConcurrencyId, 
	RefContributorTypeId, StampAction, StampDateTime, StampUser) 
Select RefContributorTypeName, RetireFg, ConcurrencyId, 
	RefContributorTypeId, @StampAction, GetDate(), @StampUser
FROM TRefContributorType
WHERE RefContributorTypeId = @RefContributorTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
