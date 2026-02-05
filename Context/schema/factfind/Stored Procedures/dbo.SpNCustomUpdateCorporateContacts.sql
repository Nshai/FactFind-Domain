SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpNCustomUpdateCorporateContacts]
@StampUser varchar(255),
@CorporateContactsId BIGINT,
@IndClientId BIGINT = 0,
@CrmContactId BIGINT,
@RefContactType VARCHAR(255) = null,
@Name varchar(50)=null,
@Description VARCHAR(255) = null,
@Value VARCHAR(255) = null,
@DefaultFg bit = 0,
@ConcurrencyId bigint
AS

	--EXEC [CRM].[dbo].[SpUpdateContactByIdAndConcurrencyId] @ContactId, @ConcurrencyId, @StampUser, @IndClientId, @CRMContactId, @RefContactType, @Description, @Value, @DefaultFg

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	INSERT INTO Crm..TContactAudit 
	( IndClientId, CRMContactId, RefContactType, [Description], Value, DefaultFg, ConcurrencyId,
 	ContactId, StampAction, StampDateTime, StampUser)
	SELECT T1.IndClientId, T1.CRMContactId, T1.RefContactType, T1.[Description], T1.Value,  T1.DefaultFg, T1.ConcurrencyId,
	T1.ContactId, 'U', GetDate(), @StampUser
	FROM Crm..TContact T1
	WHERE (T1.ContactId = @CorporateContactsId) --AND (T1.ConcurrencyId = @ConcurrencyId)

	IF @@ERROR != 0 GOTO errh

	UPDATE T1
	SET  T1.CRMContactId = @CRMContactId, T1.RefContactType = @RefContactType,
		T1.[Description] = @Description, T1.Value = @Value, T1.DefaultFg = @DefaultFg, T1.ConcurrencyId = T1.ConcurrencyId + 1
	FROM Crm..TContact T1
	WHERE (T1.ContactId = @CorporateContactsId) --AND (T1.ConcurrencyId = @ConcurrencyId)

	IF @@ERROR != 0 GOTO errh

	If @DefaultFg = 1
		Exec SpNCustomUpdateContactDefaultFg @CorporateContactsId, @StampUser, @IndClientId, @CRMContactId, @RefContactType

	--Update factfind database TCorporateContact if record exists, otherwise create a new one.
	IF exists(Select CorporateContactId FROM FactFind..TCorporateContact WHERE ContactId=@CorporateContactsId AND CRMContactId=@CRMContactId)
	BEGIN
		INSERT FactFind..TCorporateContactAudit(CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,
							STAMPACTION,STAMPDATETIME,STAMPUSER)
		SELECT CRMContactId,ContactId,[Name],[Description],Details,isDefault,CorporateContactId,ConcurrencyId,'U',getdate(),@StampUser
		FROM FactFind..TCorporateContact WHERE ContactId=@CorporateContactsId AND CRMContactId=@CRMContactId
	END
	ELSE
	BEGIN
		DECLARE @CorporateContactId bigint
		INSERT FactFind..TCorporateContact(CRMContactId,ContactId,[Name],[Description],Details,isDefault,ConcurrencyId)
		Select @CRMContactId,@CorporateContactsId,@Name,@Description,@Value,@DefaultFg,1

		Select @CorporateContactId=SCOPE_IDENTITY()

		--Add the Audit record
		EXEC FactFind..SpNAuditCorporateContact @StampUser,@CorporateContactId,'C'
	END


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
