SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPensionContributions]
	@StampUser varchar (255),
	@PensionContributionsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPensionContributionsAudit 
( CRMContactId, EmployerPercentage, EmployeePercentage, EmployerFixedCost, 
		EmployeeFixedCost, ConcurrencyId, 
	PensionContributionsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, EmployerPercentage, EmployeePercentage, EmployerFixedCost, 
		EmployeeFixedCost, ConcurrencyId, 
	PensionContributionsId, @StampAction, GetDate(), @StampUser
FROM TPensionContributions
WHERE PensionContributionsId = @PensionContributionsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
