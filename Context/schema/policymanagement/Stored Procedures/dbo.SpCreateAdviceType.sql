SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAdviceType]
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
  DECLARE @AdviceTypeId bigint

  INSERT INTO TAdviceType (
    Description, 
    IntelligentOfficeAdviceType, 
    ArchiveFg, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @Description, 
    @IntelligentOfficeAdviceType, 
    @ArchiveFg, 
    @IndigoClientId, 
    1) 

  SELECT @AdviceTypeId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TAdviceType T1
 WHERE T1.AdviceTypeId=@AdviceTypeId
  EXEC SpRetrieveAdviceTypeById @AdviceTypeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
