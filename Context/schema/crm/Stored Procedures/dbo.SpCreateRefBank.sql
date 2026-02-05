SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRefBank]
	@StampUser varchar (255),
	@Name varchar(255) 	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @RefBankId bigint
			
	
	INSERT INTO TRefBank (
		Name, 
		ConcurrencyId)
		
	VALUES(
		@Name,
		1)

	SELECT @RefBankId = SCOPE_IDENTITY()
	
	INSERT INTO TRefBankAudit (
		Name, 
		ConcurrencyId,
		RefBankId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		Name, 
		ConcurrencyId,
		RefBankId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TRefBank
	WHERE RefBankId = @RefBankId
	EXEC SpRetrieveRefBankById @RefBankId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
