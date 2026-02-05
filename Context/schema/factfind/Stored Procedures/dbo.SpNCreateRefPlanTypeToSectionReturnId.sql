SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateRefPlanTypeToSectionReturnId]
	@StampUser varchar (255),
	@RefPlanType2ProdSubTypeId bigint, 
	@Section varchar(255) 	
AS


DECLARE @RefPlanTypeToSectionId bigint, @Result int
			
	
INSERT INTO TRefPlanTypeToSection
(RefPlanType2ProdSubTypeId, Section, ConcurrencyId)
VALUES(@RefPlanType2ProdSubTypeId, @Section, 1)

SELECT @RefPlanTypeToSectionId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditRefPlanTypeToSection @StampUser, @RefPlanTypeToSectionId, 'C'

IF @Result  != 0 GOTO errh


SELECT @RefPlanTypeToSectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
