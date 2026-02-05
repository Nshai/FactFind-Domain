SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateVerificationHistory]
	@StampUser varchar (255),
	@UserId bigint = NULL, 
	@CRMContactId bigint = NULL, 
	@VerificationDate datetime = NULL, 
	@VerificationResult varchar(50)  = NULL, 
	@AuthenticationId varchar(50)  = NULL, 
	@ResultDocumentId varchar(50)  = NULL, 
	@CertificateDocumentId varchar(50)  = NULL	
AS


DECLARE @VerificationHistoryId bigint, @Result int
			
	
INSERT INTO TVerificationHistory
(UserId, CRMContactId, VerificationDate, VerificationResult, AuthenticationId, ResultDocumentId, 
	CertificateDocumentId, ConcurrencyId)
VALUES(@UserId, @CRMContactId, @VerificationDate, @VerificationResult, @AuthenticationId, @ResultDocumentId, 
	@CertificateDocumentId, 1)

SELECT @VerificationHistoryId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditVerificationHistory @StampUser, @VerificationHistoryId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveVerificationHistoryByVerificationHistoryId @VerificationHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
