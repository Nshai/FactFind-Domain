SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFactFind]
	@FactFindId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

	INSERT INTO TFactFindAudit 
	(CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, ConcurrencyId, 
		FactFindId, StampAction, StampDateTime, StampUser)
	SELECT T1.CRMContactId1, T1.CRMContactId2, T1.FactFindTypeId, T1.IndigoClientId, T1.ConcurrencyId,
		T1.FactFindId, 'D', GetDate(), @StampUser 
	FROM TFactFind T1	
	WHERE T1.FactFindId = @FactFindId --AND T1.ConcurrencyId = @ConcurrencyId

	DELETE T1 FROM TFactFind T1
	WHERE T1.FactFindId = @FactFindId --AND T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
