SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateContactReturnId]
	@StampUser varchar (255),
	@IndClientId bigint, 
	@CRMContactId bigint, 
	@RefContactType varchar(50) , 
	@Description varchar(8000)  = NULL, 
	@Value varchar(255) , 
	@DefaultFg tinyint	
AS


DECLARE @ContactId bigint, @Result int
			
	
INSERT INTO TContact
(IndClientId, CRMContactId, RefContactType, Description, Value, DefaultFg, 
	ConcurrencyId)
VALUES(@IndClientId, @CRMContactId, @RefContactType, @Description, @Value, @DefaultFg, 1)

SELECT @ContactId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditContact @StampUser, @ContactId, 'C'

IF @Result  != 0 GOTO errh

SELECT @ContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
