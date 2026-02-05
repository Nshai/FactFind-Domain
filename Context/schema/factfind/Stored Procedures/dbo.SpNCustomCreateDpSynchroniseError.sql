SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateDpSynchroniseError]
	@Error varchar(1000)  = NULL, 
	@StampDateTime datetime = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	IF @StampDateTime IS NULL SELECT @StampDateTime = GETDATE()
	
	INSERT INTO TDpSynchroniseError
	(Error, StampDateTime)
	VALUES(@Error, @StampDateTime)


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
