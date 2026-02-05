SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateCampaignType]
@StampUser varchar (255),
@IndigoClientId bigint,
@CampaignType varchar (255),
@ArchiveFG bit = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CampaignTypeId bigint

  INSERT INTO TCampaignType (
    IndigoClientId, 
    CampaignType, 
    ArchiveFG, 
    ConcurrencyId ) 
  VALUES (
    @IndigoClientId, 
    @CampaignType, 
    @ArchiveFG, 
    1) 

  SELECT @CampaignTypeId = SCOPE_IDENTITY()
  INSERT INTO TCampaignTypeAudit (
    IndigoClientId, 
    CampaignType, 
    ArchiveFG, 
    ConcurrencyId,
    CampaignTypeId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndigoClientId, 
    T1.CampaignType, 
    T1.ArchiveFG, 
    T1.ConcurrencyId,
    T1.CampaignTypeId,
    'C',
    GetDate(),
    @StampUser

  FROM TCampaignType T1
 WHERE T1.CampaignTypeId=@CampaignTypeId
  EXEC SpRetrieveCampaignTypeById @CampaignTypeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
