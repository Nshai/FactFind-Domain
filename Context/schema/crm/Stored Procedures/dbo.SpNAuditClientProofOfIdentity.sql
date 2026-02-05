

CREATE PROCEDURE [dbo].[SpNAuditClientProofOfIdentity]
	@StampUser varchar (255),
	@ClientProofOfIdentityId int,
	@StampAction char(1)
AS

INSERT INTO [TClientProofOfIdentityAudit] 
(      ClientProofOfIdentityId
      ,ConcurrencyId
      ,CRMContactId
      ,[Type]
      ,Number
      ,IssuedOn
      ,ExpiresOn
      ,RefCountryId
      ,RefCountyId
      ,LastSeenOn
      ,DocumentHref
      ,IsDeleted
	  ,StampAction
	  ,StampDateTime
	  ,StampUser
	  ,TenantId) 
Select ClientProofOfIdentityId
      ,ConcurrencyId
      ,CRMContactId
      ,[Type]
      ,Number
      ,IssuedOn
      ,ExpiresOn
      ,RefCountryId
      ,RefCountyId
      ,LastSeenOn
      ,DocumentHref
      ,IsDeleted
	  ,@StampAction
	  ,GetDate()
	  ,@StampUser
	  ,TenantId
FROM TClientProofOfIdentity
WHERE ClientProofOfIdentityId = @ClientProofOfIdentityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO


