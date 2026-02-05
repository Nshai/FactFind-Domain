SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveVerificationHistoryByVerificationHistoryId]
	@VerificationHistoryId bigint
AS

SELECT T1.VerificationHistoryId, T1.UserId, T1.CRMContactId, T1.VerificationDate, T1.VerificationResult, T1.AuthenticationId, 
	T1.ResultDocumentId, T1.CertificateDocumentId, T1.ConcurrencyId
FROM TVerificationHistory  T1
WHERE T1.VerificationHistoryId = @VerificationHistoryId
GO
