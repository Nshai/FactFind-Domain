SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAtrTemplate]
	@StampUser varchar (255),
	@Identifier varchar(255)  = NULL, 
	@Descriptor varchar(1000)  = NULL, 
	@Active bit = 0, 
	@HasModels bit = 0, 
	@BaseAtrTemplate uniqueidentifier = NULL, 
	@IndigoClientId bigint, 
	@Guid uniqueidentifier = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @Guid IS NULL SET @Guid = newid()
	
	DECLARE @AtrTemplateId bigint
			
	
	INSERT INTO TAtrTemplate (
		Identifier, 
		Descriptor, 
		Active, 
		HasModels, 
		BaseAtrTemplate, 
		IndigoClientId, 
		Guid, 
		ConcurrencyId)
		
	VALUES(
		@Identifier, 
		@Descriptor, 
		@Active, 
		@HasModels, 
		@BaseAtrTemplate, 
		@IndigoClientId, 
		@Guid,
		1)

	SELECT @AtrTemplateId = SCOPE_IDENTITY()
	
	INSERT INTO TAtrTemplateAudit (
		Identifier, 
		Descriptor, 
		Active, 
		HasModels, 
		BaseAtrTemplate, 
		IndigoClientId, 
		Guid, 
		ConcurrencyId,
		AtrTemplateId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		Identifier, 
		Descriptor, 
		Active, 
		HasModels, 
		BaseAtrTemplate, 
		IndigoClientId, 
		Guid, 
		ConcurrencyId,
		AtrTemplateId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TAtrTemplate
	WHERE AtrTemplateId = @AtrTemplateId

	EXEC SpRetrieveAtrTemplateById @AtrTemplateId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
