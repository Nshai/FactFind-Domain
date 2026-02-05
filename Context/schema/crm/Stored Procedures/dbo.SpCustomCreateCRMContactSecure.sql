SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[SpCustomCreateCRMContactSecure]
@StampUser varchar (255),
@RefCRMContactStatusId bigint = NULL,
@PersonId bigint = NULL,
@CorporateId bigint = NULL,
@TrustId bigint = NULL,
@AdvisorRef varchar (50) = NULL,
@Notes varchar (8000) = NULL,
@ArchiveFg tinyint = NULL,
@LastName varchar (50) = NULL,
@FirstName varchar (50) = NULL,
@CorporateName varchar (255) = NULL,
@DOB datetime = NULL,
@Postcode varchar (10) = NULL,
@OriginalAdviserCRMId bigint = 0,
@CurrentAdviserCRMId bigint = 0, 
@CurrentAdviserName varchar (255) = NULL,
@CRMContactType tinyint = 0,
@IndClientId bigint,
@FactFindId bigint = NULL,
@InternalContactFG bit = NULL,
@RefServiceStatusId bigint = NULL,
@MigrationRef varchar (255) = NULL,
@ExternalReference varchar(50) ='',
@AdditionalRef varchar(50) = '',
@CampaignDataId bigint = NULL,
@_ParentId bigint = NULL,
@_ParentTable varchar (64) = NULL,
@_ParentDb varchar (64) = NULL,
@_OwnerId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

Select @ArchiveFG=0

IF Exists(SELECT * FROM Administration..TFormatValidation WHERE IndigoClientId = @IndClientId AND Entity = 'ExternalReference') AND @ExternalReference = ''
	SELECT @ExternalReference = 'To be defined'

BEGIN
  DECLARE @CRMContactId bigint

  INSERT INTO TCRMContact (
    RefCRMContactStatusId, 
    PersonId, 
    CorporateId, 
    TrustId, 
    AdvisorRef, 
    Notes, 
    ArchiveFg, 
    LastName, 
    FirstName, 
    CorporateName, 
    DOB, 
    Postcode, 
    OriginalAdviserCRMId, 
    CurrentAdviserCRMId, 
    CurrentAdviserName, 
    CRMContactType, 
    IndClientId, 
    FactFindId, 
    InternalContactFG, 
    RefServiceStatusId, 
    MigrationRef, 
    ExternalReference,
    CampaignDataId,
    AdditionalRef,
    _ParentId, 
    _ParentTable, 
    _ParentDb, 
    _OwnerId, 
    ConcurrencyId ) 
  VALUES (
    @RefCRMContactStatusId, 
    @PersonId, 
    @CorporateId, 
    @TrustId, 
    @AdvisorRef, 
    @Notes, 
    @ArchiveFg, 
    @LastName, 
    @FirstName, 
    @CorporateName, 
    @DOB, 
    @Postcode, 
    @OriginalAdviserCRMId, 
    @CurrentAdviserCRMId, 
    @CurrentAdviserName, 
    @CRMContactType, 
    @IndClientId, 
    @FactFindId, 
    @InternalContactFG, 
    @RefServiceStatusId, 
    @MigrationRef, 
    @ExternalReference,
    @CampaignDataId,
    @AdditionalRef,
    @_ParentId, 
    @_ParentTable, 
    @_ParentDb, 
    @_OwnerId, 
    1) 

  SELECT @CRMContactId = SCOPE_IDENTITY()

	-- TD #5146 MM - If no external reference has been supplied we need to default this to a concatenation of
	-- 							 CRMContactId and CurrentAdviserCRMId. Can't do it in the CRMContact component because we
	--               would need to create the record, retrieve the CRMContactId and then update the record (2 DB calls)
	--							 BUT: If no External Reference had been supplied, but the IndigoClient does have a required format
	-- 										for this field (A record in Administration..TFormatValidation) then we can't use a default
	-- 										format. We then insert 'To be defined' into this column

	IF @ExternalReference = ''
		BEGIN
			UPDATE TCRMContact 
			SET ExternalReference = convert(varchar(10),CurrentAdviserCRMId) + '-' + replicate(0, (8-len(CRMContactId))) + convert(varchar(10),CRMContactId)
			WHERE CRMContactId = @CRMContactId
		END

  INSERT INTO TCRMContactAudit (
    RefCRMContactStatusId, 
    PersonId, 
    CorporateId, 
    TrustId, 
    AdvisorRef, 
    Notes, 
    ArchiveFg, 
    LastName, 
    FirstName, 
    CorporateName, 
    DOB, 
    Postcode, 
    OriginalAdviserCRMId, 
    CurrentAdviserCRMId, 
    CurrentAdviserName, 
    CRMContactType, 
    IndClientId, 
    FactFindId, 
    InternalContactFG, 
    RefServiceStatusId, 
    MigrationRef,
    ExternalReference,
    CampaignDataId,
    AdditionalRef,
    _ParentId, 
    _ParentTable, 
    _ParentDb, 
    _OwnerId, 
    ConcurrencyId,
    CRMContactId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.RefCRMContactStatusId, 
    T1.PersonId, 
    T1.CorporateId, 
    T1.TrustId, 
    T1.AdvisorRef, 
    T1.Notes, 
    T1.ArchiveFg, 
    T1.LastName, 
    T1.FirstName, 
    T1.CorporateName, 
    T1.DOB, 
    T1.Postcode, 
    T1.OriginalAdviserCRMId, 
    T1.CurrentAdviserCRMId, 
    T1.CurrentAdviserName, 
    T1.CRMContactType, 
    T1.IndClientId, 
    T1.FactFindId, 
    T1.InternalContactFG, 
    T1.RefServiceStatusId, 
    T1.MigrationRef, 
    T1.ExternalReference,
    T1.CampaignDataId,
    T1.AdditionalRef,
    T1._ParentId, 
    T1._ParentTable, 
    T1._ParentDb, 
    T1._OwnerId, 
    T1.ConcurrencyId,
    T1.CRMContactId,
    'C',
    GetDate(),
    @StampUser

  FROM TCRMContact T1
  WHERE T1.CRMContactId=@CRMContactId
  EXEC SpRetrieveCRMContactById @CRMContactId


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
-- Return CRMContact so it can be used by dataimport.
RETURN (@CRMContactId)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
