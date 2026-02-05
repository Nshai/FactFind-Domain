SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveCertificateById]
	@CertificateId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.CertificateId AS [Certificate!1!CertificateId], 
	T1.UserId AS [Certificate!1!UserId], 
	T1.CRMContactId AS [Certificate!1!CRMContactId], 
	ISNULL(T1.Issuer, '') AS [Certificate!1!Issuer], 
	ISNULL(T1.Subject, '') AS [Certificate!1!Subject], 
	ISNULL(CONVERT(varchar(24), T1.ValidFrom, 120), '') AS [Certificate!1!ValidFrom], 
	ISNULL(CONVERT(varchar(24), T1.ValidUntil, 120), '') AS [Certificate!1!ValidUntil], 
	ISNULL(T1.SerialNumber, '') AS [Certificate!1!SerialNumber], 
	ISNULL(T1.IsRevoked, '') AS [Certificate!1!IsRevoked], 
	ISNULL(T1.HasExpired, '') AS [Certificate!1!HasExpired], 
	ISNULL(CONVERT(varchar(24), T1.LastCheckedOn, 120), '') AS [Certificate!1!LastCheckedOn], 
	ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120), '') AS [Certificate!1!CreatedDate], 
	T1.ConcurrencyId AS [Certificate!1!ConcurrencyId]
	FROM TCertificate T1
	
	WHERE T1.CertificateId = @CertificateId
	ORDER BY [Certificate!1!CertificateId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
