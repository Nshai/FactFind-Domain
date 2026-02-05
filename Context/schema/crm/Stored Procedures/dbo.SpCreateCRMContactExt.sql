SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateCRMContactExt]
@StampUser varchar (255),
@CRMContactId bigint,
@CreditedGroupId bigint = NULL,
@ExternalId varchar (255) = NULL,
@ExternalSystem varchar (255) ='No External'
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CRMContactExtId bigint

  INSERT INTO TCRMContactExt (
    CRMContactId, 
    CreditedGroupId, 
    ExternalId,
	ExternalSystem,
    ConcurrencyId ) 
  VALUES (
    @CRMContactId, 
    @CreditedGroupId, 
    @ExternalId,
	@ExternalSystem,
    1) 

  SELECT @CRMContactExtId = SCOPE_IDENTITY()
  INSERT INTO TCRMContactExtAudit (
    CRMContactId, 
    CreditedGroupId, 
    ExternalId,
	ExternalSystem,
    ConcurrencyId,
    CRMContactExtId,    
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.CRMContactId, 
    T1.CreditedGroupId, 
    T1.ExternalId,
	T1.ExternalSystem,
    T1.ConcurrencyId,
    T1.CRMContactExtId,
    'C',
    GetDate(),
    @StampUser

  FROM TCRMContactExt T1
 WHERE T1.CRMContactExtId=@CRMContactExtId
  EXEC SpRetrieveCRMContactExtById @CRMContactExtId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO

