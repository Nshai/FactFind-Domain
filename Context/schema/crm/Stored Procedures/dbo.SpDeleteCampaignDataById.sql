SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteCampaignDataById]
@CampaignDataId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TCampaignDataAudit (
    CampaignId, 
    Description, 
    Cost, 
    ConcurrencyId,
    CampaignDataId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.CampaignId, 
    T1.Description, 
    T1.Cost, 
    T1.ConcurrencyId,
    T1.CampaignDataId,
    'D',
    GetDate(),
    @StampUser

  FROM TCampaignData T1

  WHERE (T1.CampaignDataId = @CampaignDataId)
        
  DELETE T1 FROM TCampaignData T1

  WHERE (T1.CampaignDataId = @CampaignDataId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
