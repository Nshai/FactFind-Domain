SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create Procedure SpCustomDeleteExpiredUniPassCertificates
AS

--Clear TUserCombined wrt expired Certificates
Update b
Set b.UnipassSerialNbr = Null

	--Get Deleted values
	OUTPUT DELETED.Guid, DELETED.UserId, DELETED.Identifier, DELETED.IndigoClientId, 
		DELETED.IndigoClientGuid, DELETED.UnipassSerialNbr, DELETED.ConcurrencyId,
		'U', GetDate(), '0'
			
	--Add data to Audit
	INTO TUserCombinedAudit 
		(Guid, UserId, Identifier, IndigoClientId, IndigoClientGuid, UnipassSerialNbr, ConcurrencyId, 
		StampAction, StampDateTime, StampUser)

From TUserCombined b
Inner Join TUser a on a.Guid = b.Guid
Inner Join TCertificate c on a.UserId = c.UserId
Where c.validuntil < getdate()


--Delete Certificate TCertificate
Delete a

	--Get Deleted records
	OUTPUT DELETED.UserId, DELETED.CRMContactId, DELETED.Issuer, DELETED.Subject, 
		DELETED.ValidFrom, DELETED.ValidUntil, DELETED.SerialNumber, DELETED.IsRevoked, 
		DELETED.HasExpired, DELETED.LastCheckedOn, DELETED.CreatedDate, 
		DELETED.ConcurrencyId, DELETED.CertificateId, 'D', GetDate(), '0'

	--Audit the records
	INTO TCertificateAudit 
		(UserId, CRMContactId, Issuer, Subject, 
		ValidFrom, ValidUntil, SerialNumber, IsRevoked,
		HasExpired, LastCheckedOn, CreatedDate, 
		ConcurrencyId, CertificateId, StampAction, StampDateTime, StampUser)

From TCertificate a
Where a.validuntil < getdate()


GO
