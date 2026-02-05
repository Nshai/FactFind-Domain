SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateCertificate]
@StampUser varchar (255),
@UserId bigint,
@CRMContactId bigint,
@Issuer varchar (2000) = NULL,
@Subject varchar (2000) = NULL,
@ValidFrom datetime = NULL,
@ValidUntil datetime = NULL,
@SerialNumber varchar (255) = NULL,
@IsRevoked bit = NULL,
@HasExpired bit = NULL,
@LastCheckedOn datetime = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CertificateId bigint

  INSERT INTO TCertificate (
    UserId, 
    CRMContactId, 
    Issuer, 
    Subject, 
    ValidFrom, 
    ValidUntil, 
    SerialNumber, 
    IsRevoked, 
    HasExpired, 
    LastCheckedOn, 
    ConcurrencyId ) 
  VALUES (
    @UserId, 
    @CRMContactId, 
    @Issuer, 
    @Subject, 
    @ValidFrom, 
    @ValidUntil, 
    @SerialNumber, 
    @IsRevoked, 
    @HasExpired, 
    @LastCheckedOn, 
    1) 

  SELECT @CertificateId = SCOPE_IDENTITY()
  INSERT INTO TCertificateAudit (
    UserId, 
    CRMContactId, 
    Issuer, 
    Subject, 
    ValidFrom, 
    ValidUntil, 
    SerialNumber, 
    IsRevoked, 
    HasExpired, 
    LastCheckedOn, 
    ConcurrencyId,
    CertificateId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.UserId, 
    T1.CRMContactId, 
    T1.Issuer, 
    T1.Subject, 
    T1.ValidFrom, 
    T1.ValidUntil, 
    T1.SerialNumber, 
    T1.IsRevoked, 
    T1.HasExpired, 
    T1.LastCheckedOn, 
    T1.ConcurrencyId,
    T1.CertificateId,
    'C',
    GetDate(),
    @StampUser

  FROM TCertificate T1
 WHERE T1.CertificateId=@CertificateId
  EXEC SpRetrieveCertificateById @CertificateId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
