SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteCertificateById]
	@CertificateId Bigint,
	@StampUser varchar (255)
	
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
		CreatedDate, 
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
		T1.CreatedDate, 
		T1.ConcurrencyId,
		T1.CertificateId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TCertificate T1	
	WHERE T1.CertificateId = @CertificateId

	DELETE T1 FROM TCertificate T1
	WHERE T1.CertificateId = @CertificateId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
