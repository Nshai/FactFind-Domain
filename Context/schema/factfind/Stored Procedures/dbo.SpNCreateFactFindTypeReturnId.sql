SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFactFindTypeReturnId]
	@StampUser varchar (255),
	@Identifier varchar(128) , 
	@Descriptor varchar(255) , 
	@CRMContactType tinyint, 
	@IndigoClientId bigint	
AS
DECLARE @FactFindTypeId bigint, @Result int
			
INSERT INTO TFactFindType
(Identifier, Descriptor, CRMContactType, IndigoClientId, ConcurrencyId)
VALUES(@Identifier, @Descriptor, @CRMContactType, @IndigoClientId, 1)

SELECT @FactFindTypeId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFactFindType @StampUser, @FactFindTypeId, 'C'

IF @Result  != 0 GOTO errh


SELECT @FactFindTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
