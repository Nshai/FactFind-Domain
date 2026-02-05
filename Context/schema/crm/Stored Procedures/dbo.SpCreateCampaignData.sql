SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateCampaignData]
@StampUser varchar (255),
@CampaignId bigint,
@Description varchar (255) = NULL,
@Cost money = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CampaignDataId bigint

  INSERT INTO TCampaignData (
    CampaignId, 
    Description, 
    Cost, 
    ConcurrencyId ) 
  VALUES (
    @CampaignId, 
    @Description, 
    @Cost, 
    1) 

  SELECT @CampaignDataId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TCampaignData T1
 WHERE T1.CampaignDataId=@CampaignDataId
  EXEC SpRetrieveCampaignDataById @CampaignDataId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
