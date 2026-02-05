SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateRelationship]
	@StampUser varchar (255),
	@RefRelTypeId bigint = NULL, 
	@RefRelCorrespondTypeId bigint = NULL, 
	@CRMContactFromId bigint, 
	@CRMContactToId bigint = NULL, 
	@ExternalContact varchar(255)  = NULL, 
	@ExternalURL varchar(255)  = NULL, 
	@OtherRelationship varchar(255)  = NULL, 
	@IsPartnerFg bit = NULL, 
	@IsFamilyFg bit = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @RelationshipId bigint
			
	
	INSERT INTO TRelationship (
		RefRelTypeId, 
		RefRelCorrespondTypeId, 
		CRMContactFromId, 
		CRMContactToId, 
		ExternalContact, 
		ExternalURL, 
		OtherRelationship, 
		IsPartnerFg, 
		IsFamilyFg, 
		ConcurrencyId)
		
	VALUES(
		@RefRelTypeId, 
		@RefRelCorrespondTypeId, 
		@CRMContactFromId, 
		@CRMContactToId, 
		@ExternalContact, 
		@ExternalURL, 
		@OtherRelationship, 
		@IsPartnerFg, 
		@IsFamilyFg,
		1)

	SELECT @RelationshipId = SCOPE_IDENTITY()
	
	INSERT INTO TRelationshipAudit (
		RefRelTypeId, 
		RefRelCorrespondTypeId, 
		CRMContactFromId, 
		CRMContactToId, 
		ExternalContact, 
		ExternalURL, 
		OtherRelationship, 
		IsPartnerFg, 
		IsFamilyFg, 
		ConcurrencyId,
		RelationshipId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		RefRelTypeId, 
		RefRelCorrespondTypeId, 
		CRMContactFromId, 
		CRMContactToId, 
		ExternalContact, 
		ExternalURL, 
		OtherRelationship, 
		IsPartnerFg, 
		IsFamilyFg, 
		ConcurrencyId,
		RelationshipId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TRelationship
	WHERE RelationshipId = @RelationshipId
	EXEC SpRetrieveRelationshipById @RelationshipId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
