SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAddressLookupConfig]
	@StampUser varchar (255),
	@AddressLookupConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO [dbo].TAddressLookupConfigAudit 
( UserName, Password,IndigoClientId,RefApplicationLinkId
	,ConcurrencyId,AddressLookupConfigId
	,StampAction, StampDateTime, StampUser) 
Select 
UserName, Password,IndigoClientId,RefApplicationLinkId
	,ConcurrencyId,AddressLookupConfigId
	,@StampAction, GetDate(), @StampUser
FROM TAddressLookupConfig
WHERE AddressLookupConfigId = @AddressLookupConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
