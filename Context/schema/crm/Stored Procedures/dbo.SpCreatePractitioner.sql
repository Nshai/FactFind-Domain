SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePractitioner]
@StampUser varchar (255),
@IndClientId bigint,
@PersonId bigint = NULL,
@CRMContactId bigint = NULL,
@TnCCoachId bigint = NULL,
@AuthorisedFG bit,
@PIARef varchar (255) = NULL,
@AuthorisedDate datetime = NULL,
@ExperienceLevel tinyint = NULL,
@FSAReference varchar (24) = NULL,
@MultiTieFg bit = 0,
@OffPanelFg bit = 0,
@PractitionerTypeId bigint = NULL,
@_ParentId bigint = NULL,
@_ParentTable varchar (64) = NULL,
@_ParentDb varchar (64) = NULL,
@_OwnerId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PractitionerId bigint

  INSERT INTO TPractitioner (
    IndClientId, 
    PersonId, 
    CRMContactId, 
    TnCCoachId, 
    AuthorisedFG, 
    PIARef, 
    AuthorisedDate, 
    ExperienceLevel, 
    FSAReference, 
    MultiTieFg, 
    OffPanelFg, 
    PractitionerTypeId, 
    _ParentId, 
    _ParentTable, 
    _ParentDb, 
    _OwnerId, 
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @PersonId, 
    @CRMContactId, 
    @TnCCoachId, 
    @AuthorisedFG, 
    @PIARef, 
    @AuthorisedDate, 
    @ExperienceLevel, 
    @FSAReference, 
    @MultiTieFg, 
    @OffPanelFg, 
    @PractitionerTypeId, 
    @_ParentId, 
    @_ParentTable, 
    @_ParentDb, 
    @_OwnerId, 
    1) 

  SELECT @PractitionerId = SCOPE_IDENTITY()
  INSERT INTO TPractitionerAudit (
    IndClientId, 
    PersonId, 
    CRMContactId, 
    TnCCoachId, 
    AuthorisedFG, 
    PIARef, 
    AuthorisedDate, 
    ExperienceLevel, 
    FSAReference, 
    MultiTieFg, 
    OffPanelFg, 
    PractitionerTypeId, 
    _ParentId, 
    _ParentTable, 
    _ParentDb, 
    _OwnerId, 
    ConcurrencyId,
    PractitionerId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.PersonId, 
    T1.CRMContactId, 
    T1.TnCCoachId, 
    T1.AuthorisedFG, 
    T1.PIARef, 
    T1.AuthorisedDate, 
    T1.ExperienceLevel, 
    T1.FSAReference, 
    T1.MultiTieFg, 
    T1.OffPanelFg, 
    T1.PractitionerTypeId, 
    T1._ParentId, 
    T1._ParentTable, 
    T1._ParentDb, 
    T1._OwnerId, 
    T1.ConcurrencyId,
    T1.PractitionerId,
    'C',
    GetDate(),
    @StampUser

  FROM TPractitioner T1
 WHERE T1.PractitionerId=@PractitionerId
  EXEC SpRetrievePractitionerById @PractitionerId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
