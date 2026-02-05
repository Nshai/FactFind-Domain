SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateCertificateById]
@KeyCertificateId bigint,
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
    'U',
    GetDate(),
    @StampUser

  FROM TCertificate T1

  WHERE (T1.CertificateId = @KeyCertificateId)
  UPDATE T1
  SET 
    T1.UserId = @UserId,
    T1.CRMContactId = @CRMContactId,
    T1.Issuer = @Issuer,
    T1.Subject = @Subject,
    T1.ValidFrom = @ValidFrom,
    T1.ValidUntil = @ValidUntil,
    T1.SerialNumber = @SerialNumber,
    T1.IsRevoked = @IsRevoked,
    T1.HasExpired = @HasExpired,
    T1.LastCheckedOn = @LastCheckedOn,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TCertificate T1

  WHERE (T1.CertificateId = @KeyCertificateId)

SELECT * FROM TCertificate [Certificate]
  WHERE ([Certificate].CertificateId = @KeyCertificateId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
