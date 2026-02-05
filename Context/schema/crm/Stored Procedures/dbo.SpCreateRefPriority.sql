SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRefPriority]
@StampUser varchar (255),
@PriorityName varchar (255),
@IndClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @RefPriorityId bigint

  INSERT INTO TRefPriority (
    PriorityName, 
    IndClientId, 
    ConcurrencyId ) 
  VALUES (
    @PriorityName, 
    @IndClientId, 
    1) 

  SELECT @RefPriorityId = SCOPE_IDENTITY()
  INSERT INTO TRefPriorityAudit (
    PriorityName, 
    IndClientId, 
    ConcurrencyId,
    RefPriorityId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PriorityName, 
    T1.IndClientId, 
    T1.ConcurrencyId,
    T1.RefPriorityId,
    'C',
    GetDate(),
    @StampUser

  FROM TRefPriority T1
 WHERE T1.RefPriorityId=@RefPriorityId
  EXEC SpRetrieveRefPriorityById @RefPriorityId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
