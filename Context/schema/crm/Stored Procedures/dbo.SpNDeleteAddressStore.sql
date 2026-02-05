SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteAddressStore]
	@AddressStoreId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
	
AS

Declare @Result int
Execute @Result = dbo.SpNAuditAddressStore @StampUser, @AddressStoreId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TAddressStore T1
WHERE T1.AddressStoreId = @AddressStoreId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
