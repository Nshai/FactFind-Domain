SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create Procedure SpCustomUpdateRevokedUnipassCertificates
AS


--Update TCertificate wrt IsRevoked
Update a  
Set a.IsRevoked = 1, lastcheckedon = GetDate()
  
 --Get Updated values  
 OUTPUT DELETED.UserId, DELETED.CRMContactId, DELETED.Issuer, DELETED.Subject,   
  DELETED.ValidFrom, DELETED.ValidUntil, DELETED.SerialNumber, DELETED.IsRevoked,
  DELETED.HasExpired, DELETED.LastCheckedOn, DELETED.CreatedDate, DELETED.ConcurrencyId,  
  DELETED.CertificateId, 'U', GetDate(), '0'  
     
 --Add data to Audit  
 INTO TCertificateAudit   
  (UserId, CRMContactId, Issuer, Subject, 
  ValidFrom, ValidUntil, SerialNumber, IsRevoked,
  HasExpired, LastCheckedOn, CreatedDate, ConcurrencyId,
  CertificateId, StampAction, StampDateTime, StampUser)
  
From TCertificate a  
Inner Join TUnipassCertificateRevocationList b on a.SerialNumber = b.SerialNumber

GO
