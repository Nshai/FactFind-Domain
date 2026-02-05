SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditApplicationLink]
	@StampUser varchar (255),
	@ApplicationLinkId bigint,
	@StampAction char(1)
AS

INSERT INTO TApplicationLinkAudit 
( IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, 
		AllowAccess,SystemArchived, WealthLinkEnabled, ExtranetURL, ConcurrencyId, 
	ApplicationLinkId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, 
		AllowAccess, SystemArchived, WealthLinkEnabled, ExtranetURL, ConcurrencyId, 
	ApplicationLinkId, @StampAction, GetDate(), @StampUser
FROM TApplicationLink
WHERE ApplicationLinkId = @ApplicationLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
