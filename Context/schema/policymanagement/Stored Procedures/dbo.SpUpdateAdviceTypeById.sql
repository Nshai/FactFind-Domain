SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateAdviceTypeById]
@KeyAdviceTypeId bigint,
@StampUser varchar (255),
@Description varchar (50),
@IntelligentOfficeAdviceType varchar (50),
@ArchiveFg bit = 0,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TAdviceTypeAudit (
    Description, 
    IntelligentOfficeAdviceType, 
    ArchiveFg, 
    IndigoClientId, 
    ConcurrencyId,
    AdviceTypeId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Description, 
    T1.IntelligentOfficeAdviceType, 
    T1.ArchiveFg, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.AdviceTypeId,
    'U',
    GetDate(),
    @StampUser

  FROM TAdviceType T1

  WHERE (T1.AdviceTypeId = @KeyAdviceTypeId)
  UPDATE T1
  SET 
    T1.Description = @Description,
    T1.IntelligentOfficeAdviceType = @IntelligentOfficeAdviceType,
    T1.ArchiveFg = @ArchiveFg,
    T1.IndigoClientId = @IndigoClientId,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TAdviceType T1

  WHERE (T1.AdviceTypeId = @KeyAdviceTypeId)

SELECT * FROM TAdviceType [AdviceType]
  WHERE ([AdviceType].AdviceTypeId = @KeyAdviceTypeId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
