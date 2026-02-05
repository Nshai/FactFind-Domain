SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientProfessionalAffiliations]
	@StampUser varchar (255),
	@ClientProfessionalAffiliationsId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientProfessionalAffiliationsAudit 
(ClientProfessionalAffiliationsId
      ,CRMContactId
      ,TenantId
      ,TenantAdvisoryFirm
      ,OtherAdvisoryFirm
      ,OtherFinancialInstitution
      ,SeniorPosition
      ,SeniorPoliticalFigure
      ,OtherBrokerageAccount, StampAction, StampDateTime, StampUser) 
SELECT ClientProfessionalAffiliationsId
      ,CRMContactId
      ,TenantId
      ,TenantAdvisoryFirm
      ,OtherAdvisoryFirm
      ,OtherFinancialInstitution
      ,SeniorPosition
      ,SeniorPoliticalFigure
      ,OtherBrokerageAccount, @StampAction, GetDate(), @StampUser
FROM TClientProfessionalAffiliations
WHERE ClientProfessionalAffiliationsId = @ClientProfessionalAffiliationsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
