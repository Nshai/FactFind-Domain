SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateCampaign]
@StampUser varchar (255),
@CampaignTypeId bigint,
@IndigoClientId bigint,
@GroupId bigint = NULL,
@CampaignName varchar (255),
@ArchiveFG bit = 0,
@IsOrganisational bit = 0
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CampaignId bigint

  INSERT INTO TCampaign (
    CampaignTypeId, 
    IndigoClientId, 
    GroupId, 
    CampaignName, 
    ArchiveFG, 
    IsOrganisational, 
    ConcurrencyId ) 
  VALUES (
    @CampaignTypeId, 
    @IndigoClientId, 
    @GroupId, 
    @CampaignName, 
    @ArchiveFG, 
    @IsOrganisational, 
    1) 

  SELECT @CampaignId = SCOPE_IDENTITY()
  INSERT INTO TCampaignAudit (
    CampaignTypeId, 
    IndigoClientId, 
    GroupId, 
    CampaignName, 
    ArchiveFG, 
    IsOrganisational, 
    ConcurrencyId,
    CampaignId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.CampaignTypeId, 
    T1.IndigoClientId, 
    T1.GroupId, 
    T1.CampaignName, 
    T1.ArchiveFG, 
    T1.IsOrganisational, 
    T1.ConcurrencyId,
    T1.CampaignId,
    'C',
    GetDate(),
    @StampUser

  FROM TCampaign T1
 WHERE T1.CampaignId=@CampaignId
  EXEC SpRetrieveCampaignById @CampaignId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
