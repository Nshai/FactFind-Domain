SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanTypeToSection]
	@StampUser varchar (255),
	@RefPlanTypeToSectionId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanTypeToSectionAudit 
( RefPlanType2ProdSubTypeId, Section, ConcurrencyId, 
	RefPlanTypeToSectionId, StampAction, StampDateTime, StampUser) 
Select RefPlanType2ProdSubTypeId, Section, ConcurrencyId, 
	RefPlanTypeToSectionId, @StampAction, GetDate(), @StampUser
FROM TRefPlanTypeToSection
WHERE RefPlanTypeToSectionId = @RefPlanTypeToSectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
