SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditVerificationHistory]
	@StampUser varchar (255),
	@VerificationHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TVerificationHistoryAudit 
		([UserId]
		,[CRMContactId]
		,[VerificationDate]
		,[VerificationResult]
		,[AuthenticationId]
		,[ResultDocumentId]
		,[CertificateDocumentId]
		,[ConcurrencyId]
		,[VerificationHistoryId]
		,[StampAction]
		,[StampDateTime]
		,[StampUser]
		,[VerificationIssuer]
		,[VerificationReference]
		,[VerificationScore]
		,[IsManual]
		,[CreatedOn]
		,[UpdatedOn]) 
Select   [UserId]
		,[CRMContactId]
		,[VerificationDate]
		,[VerificationResult]
		,[AuthenticationId]
		,[ResultDocumentId]
		,[CertificateDocumentId]
		,[ConcurrencyId]
		,[VerificationHistoryId]
		,@StampAction
		,GetDate()
		,@StampUser
		,[VerificationIssuer]
		,[VerificationReference]
		,[VerificationScore]
		,[IsManual]
		,[CreatedOn]
		,[UpdatedOn]
FROM TVerificationHistory
WHERE VerificationHistoryId = @VerificationHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
