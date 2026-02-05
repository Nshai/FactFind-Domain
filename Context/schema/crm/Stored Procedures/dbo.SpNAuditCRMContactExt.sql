SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCRMContactExt]
	@StampUser varchar (255),
	@CRMContactExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TCRMContactExtAudit
           (CRMContactId, CreditedGroupId, ConcurrencyId, CRMContactExtId, StampAction, StampDateTime, StampUser, ExternalSystemId, 
		    ExternalId,ServicingAdminUserId,ParaplannerUserId,ReportFrequency,ReportStartDate, ClientServicingDeliveryMethod,TaxReferenceNumber,
			IsTargetMarket,TargetMarketExplanation,DateClientRestricted)
SELECT     CRMContactId, CreditedGroupId, ConcurrencyId, CRMContactExtId, @StampAction AS Expr1, GETDATE() AS Expr2, @StampUser AS Expr3, ExternalSystemId, 
                      ExternalId,ServicingAdminUserId,ParaplannerUserId,ReportFrequency,ReportStartDate,ClientServicingDeliveryMethod,TaxReferenceNumber,
			IsTargetMarket,TargetMarketExplanation,DateClientRestricted
FROM         TCRMContactExt
WHERE     (CRMContactExtId = @CRMContactExtId)

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
