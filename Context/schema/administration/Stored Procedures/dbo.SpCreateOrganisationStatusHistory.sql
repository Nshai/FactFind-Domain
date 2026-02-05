SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateOrganisationStatusHistory]
@StampUser varchar (255),
@IndigoClientId bigint,
@Identifier varchar (50),
@ChangeDateTime datetime = NULL,
@ChangeUser bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  IF @ChangeDateTime IS NULL SET @ChangeDateTime = getdate()
  DECLARE @OrganisationStatusHistoryId bigint

  INSERT INTO TOrganisationStatusHistory (
    IndigoClientId, 
    Identifier, 
    ChangeDateTime, 
    ChangeUser, 
    ConcurrencyId ) 
  VALUES (
    @IndigoClientId, 
    @Identifier, 
    @ChangeDateTime, 
    @ChangeUser, 
    1) 

  SELECT @OrganisationStatusHistoryId = SCOPE_IDENTITY()
  INSERT INTO TOrganisationStatusHistoryAudit (
    IndigoClientId, 
    Identifier, 
    ChangeDateTime, 
    ChangeUser, 
    ConcurrencyId,
    OrganisationStatusHistoryId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndigoClientId, 
    T1.Identifier, 
    T1.ChangeDateTime, 
    T1.ChangeUser, 
    T1.ConcurrencyId,
    T1.OrganisationStatusHistoryId,
    'C',
    GetDate(),
    @StampUser

  FROM TOrganisationStatusHistory T1
 WHERE T1.OrganisationStatusHistoryId=@OrganisationStatusHistoryId
  EXEC SpRetrieveOrganisationStatusHistoryById @OrganisationStatusHistoryId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
