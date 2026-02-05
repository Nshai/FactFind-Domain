SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateCorporateContacts]
	@StampUser varchar (255),
	@CRMContactId bigint,
	@RefContactType varchar (50) = NULL,
	@Name varchar(50)=NULL,
	@Description varchar (8000) = NULL,
	@Value varchar (255) = NULL,
	@DefaultFg tinyint = NULL
AS

--	EXEC [CRM].[dbo].[SpCreateContact] @StampUser, @IndClientId, @CRMContactId, @RefContactType, @RefContactType, @Value, @DefaultFg
DECLARE @IndClientId bigint

SELECT @IndClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId
SET NOCOUNT ON

DECLARE @tx int,@CorporateContactId bigint
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @ContactId bigint

	INSERT INTO Crm..TContact 
	( IndClientId, CRMContactId, RefContactType, [Description], Value, DefaultFg, ConcurrencyId ) 
	VALUES ( @IndClientId, @CRMContactId, @RefContactType, @Description,  @Value, ISNULL(@DefaultFg,0), 1) 

	SELECT @ContactId = SCOPE_IDENTITY()

	INSERT INTO Crm..TContactAudit 
	( IndClientId, CRMContactId, RefContactType, [Description], Value, DefaultFg, ConcurrencyId,
	ContactId, StampAction, StampDateTime, StampUser)
	SELECT T1.IndClientId, T1.CRMContactId, T1.RefContactType, T1.[Description],  T1.Value, T1.DefaultFg, T1.ConcurrencyId,
 	T1.ContactId, 'C', GetDate(), @StampUser
	FROM Crm..TContact T1
	WHERE T1.ContactId=@ContactId

	If @DefaultFg = 1
		Exec SpNCustomUpdateContactDefaultFg @ContactId, @StampUser, @IndClientId, @CRMContactId, @RefContactType

	--Create a record in FactFind database to store the name field, this is not part of the core app.
	INSERT FactFind..TCorporateContact(CRMContactId,ContactId,[Name],[Description],Details,isDefault,ConcurrencyId)
	Select @CRMContactId,@ContactId,@Name,@Description,@Value,@DefaultFg,1

	Select @CorporateContactId=SCOPE_IDENTITY()

	--Add the Audit record
	EXEC FactFind..SpNAuditCorporateContact @StampUser,@CorporateContactId,'C'


	SELECT ContactId AS CorporateContactsId FROM CRM..TContact WHERE ContactId = @ContactId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
