SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateGrouping]
@StampUser varchar (255),
@Identifier varchar (64),
@ParentId bigint = NULL,
@IsPayable bit = 0,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @GroupingId bigint

  INSERT INTO TGrouping (
    Identifier, 
    ParentId, 
    IsPayable, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @Identifier, 
    @ParentId, 
    @IsPayable, 
    @IndigoClientId, 
    1) 

  SELECT @GroupingId = SCOPE_IDENTITY()
  INSERT INTO TGroupingAudit (
    Identifier, 
    ParentId, 
    IsPayable, 
    IndigoClientId, 
    ConcurrencyId,
    GroupingId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Identifier, 
    T1.ParentId, 
    T1.IsPayable, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.GroupingId,
    'C',
    GetDate(),
    @StampUser

  FROM TGrouping T1
 WHERE T1.GroupingId=@GroupingId
  EXEC SpRetrieveGroupingById @GroupingId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)





GO
