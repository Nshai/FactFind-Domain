SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateTrust]
@StampUser varchar (255),
@RefTrustTypeId bigint,
@IndClientId bigint,
@TrustName varchar (250),
@EstDate datetime = NULL,
@ArchiveFG tinyint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @TrustId bigint

  INSERT INTO TTrust (
    RefTrustTypeId, 
    IndClientId, 
    TrustName, 
    EstDate, 
    ArchiveFG, 
    ConcurrencyId ) 
  VALUES (
    @RefTrustTypeId, 
    @IndClientId, 
    @TrustName, 
    @EstDate, 
    @ArchiveFG, 
    1) 

  SELECT @TrustId = SCOPE_IDENTITY()
  INSERT INTO TTrustAudit (
    RefTrustTypeId, 
    IndClientId, 
    TrustName, 
    EstDate, 
    ArchiveFG, 
    ConcurrencyId,
    TrustId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RefTrustTypeId, 
    T1.IndClientId, 
    T1.TrustName, 
    T1.EstDate, 
    T1.ArchiveFG, 
    T1.ConcurrencyId,
    T1.TrustId,
    'C',
    GetDate(),
    @StampUser

  FROM TTrust T1
 WHERE T1.TrustId=@TrustId
  EXEC SpRetrieveTrustById @TrustId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
