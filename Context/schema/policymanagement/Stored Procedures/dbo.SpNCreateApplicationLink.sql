SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateApplicationLink]
	@StampUser varchar (255),
	@IndigoClientId bigint, 
	@RefApplicationId bigint, 
	@MaxLicenceCount int = NULL, 
	@CurrentLicenceCount int = NULL, 
	@AllowAccess bit = 1, 
	@ExtranetURL varchar(255)  = NULL	
AS


DECLARE @ApplicationLinkId bigint, @Result int
			
	
INSERT INTO TApplicationLink
(IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, AllowAccess, ExtranetURL, 
	ConcurrencyId)
VALUES(@IndigoClientId, @RefApplicationId, @MaxLicenceCount, @CurrentLicenceCount, @AllowAccess, @ExtranetURL, 1)

SELECT @ApplicationLinkId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditApplicationLink @StampUser, @ApplicationLinkId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveApplicationLinkByApplicationLinkId @ApplicationLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
