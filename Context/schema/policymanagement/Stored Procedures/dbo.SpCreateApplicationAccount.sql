SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateApplicationAccount]
	@StampUser varchar (255),
	@RefApplicationId bigint, 
	@UserId bigint, 
	@UserName varchar(50)  = NULL, 
	@Password varchar(50)  = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ApplicationAccountId bigint
			
	
	INSERT INTO TApplicationAccount (
		RefApplicationId, 
		UserId, 
		UserName, 
		Password, 
		ConcurrencyId)
		
	VALUES(
		@RefApplicationId, 
		@UserId, 
		@UserName, 
		@Password,
		1)

	SELECT @ApplicationAccountId = SCOPE_IDENTITY()

	INSERT INTO TApplicationAccountAudit (
		RefApplicationId, 
		UserId, 
		UserName, 
		Password, 
		ConcurrencyId,
		ApplicationAccountId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		RefApplicationId, 
		UserId, 
		UserName, 
		Password, 
		ConcurrencyId,
		ApplicationAccountId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TApplicationAccount
	WHERE ApplicationAccountId = @ApplicationAccountId

	EXEC SpRetrieveApplicationAccountById @ApplicationAccountId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
