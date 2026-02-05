SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteAddress]
	@AddressId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
	
AS


Declare @Result int
Execute @Result = dbo.SpNAuditAddress @StampUser, @AddressId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TAddress T1
WHERE T1.AddressId = @AddressId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
