SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditApplicationLinkByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TApplicationLinkAudit 
( IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, 
		AllowAccess, WealthlinkEnabled, ExtranetURL, ConcurrencyId, SystemArchived,
	ApplicationLinkId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, 
		AllowAccess, WealthlinkEnabled, ExtranetURL, ConcurrencyId, SystemArchived,
	ApplicationLinkId, @StampAction, GetDate(), @StampUser
FROM TApplicationLink
WHERE ApplicationLinkId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
