SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefPlanType2ProdSubTypeExternalMapping]
	@StampUser varchar (255),
	@RefPlanType2ProdSubTypeExternalMappingId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanType2ProdSubTypeExternalMappingAudit
                      (RefPlanType2ProdSubTypeId, RefProdProviderId, ExternalCode, ConcurrencyId, RefPlanType2ProdSubTypeExternalMappingId, StampAction, StampDateTime, 
                      StampUser)
SELECT     RefPlanType2ProdSubTypeId, RefProdProviderId, ExternalCode, ConcurrencyId, RefPlanType2ProdSubTypeExternalMappingId, @StampAction AS StampAction, 
                      GETDATE() AS StampDateTime, @StampUser AS StampUser
FROM         TRefPlanType2ProdSubTypeExternalMapping
WHERE     (RefPlanType2ProdSubTypeExternalMappingId = @RefPlanType2ProdSubTypeExternalMappingId)

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
