SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCreateUpdateUIDomainFieldAttribute]
	@TenantId BIGINT,
	@DomainName VARCHAR(100),
	@FieldName VARCHAR(100),
	@AttributeName VARCHAR(100),
	@AttributeValue VARCHAR(100),
	@StampUser VARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @tx int = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN	
	DECLARE 
		@DomainId BIGINT,
		@FieldId BIGINT,
		@StampDateTime DATETIME = GETDATE()


	IF NOT EXISTS(SELECT 1 FROM TUIDomain WHERE DomainName = @DomainName AND TenantId = @TenantId)
		INSERT INTO TUIDomain (DomainName, TenantId)		
			-- Auditing -------------------------------------
			OUTPUT 
				INSERTED.[UIDomainId], INSERTED.[DomainName], INSERTED.[TenantId], INSERTED.[ConcurrencyId],
				'C', @StampDateTime, @StampUser
			INTO [TUIDomainAudit]
				([UIDomainId],[DomainName],[TenantId],[ConcurrencyId],
				 [StampAction], [StampDateTime], [StampUser])
			-------------------------------------------------			
		SELECT @DomainName, @TenantId

	SELECT @DomainId = UIDomainId 
	FROM TUIDomain
	WHERE DomainName = @DomainName AND TenantId = @TenantId



	IF NOT EXISTS(SELECT 1 FROM TUIFieldName WHERE UIDomainId = @DomainId AND FieldName = @FieldName AND TenantId = @TenantId)
		INSERT INTO TUIFieldName (UIDomainId, FieldName, TenantId)		
			 -- Auditing -------------------------------------
			OUTPUT 
				INSERTED.[UIFieldNameId], INSERTED.[UIDomainId], INSERTED.[FieldName], INSERTED.[TenantId], INSERTED.[ConcurrencyId],
				'C', @StampDateTime, @StampUser
			INTO [TUIFieldNameAudit]
				([UIFieldNameId],[UIDomainId],[FieldName],[TenantId],[ConcurrencyId],
				 [StampAction], [StampDateTime], [StampUser])
			-------------------------------------------------
		SELECT @DomainId, @FieldName, @TenantId

	SELECT @FieldId = UIDomainId
	FROM TUIFieldName
	WHERE UIDomainId = @DomainId AND FieldName = @FieldName AND TenantId = @TenantId



	IF NOT EXISTS(SELECT 1 FROM TUIFieldAttributes WHERE UIFieldNameId = @FieldId AND AttributesName = @AttributeName AND TenantId = @TenantId)	
		INSERT INTO TUIFieldAttributes(UIFieldNameId, AttributesName, AttributesValue, TenantId)		
			-- Auditing -------------------------------------
			OUTPUT 
				INSERTED.[UIFieldAttributesId], INSERTED.[UIFieldNameId], INSERTED.[AttributesName], INSERTED.[AttributesValue], INSERTED.[TenantId], INSERTED.[ConcurrencyId],
				'C', @StampDateTime, @StampUser
			INTO [TUIFieldAttributesAudit]
				([UIFieldAttributesId],[UIFieldNameId],[AttributesName],[AttributesValue],[TenantId],[ConcurrencyId],
				 [StampAction], [StampDateTime], [StampUser])
			-------------------------------------------------        
		SELECT @FieldId, @AttributeName, @AttributeValue, @TenantId
	
	ELSE
		UPDATE ATTR
		SET 
			ATTR.AttributesValue = @AttributeValue			
			
				-- Auditing -------------------------------------
				OUTPUT 
					DELETED.[UIFieldAttributesId], DELETED.[UIFieldNameId], DELETED.[AttributesName], DELETED.[AttributesValue], DELETED.[TenantId], DELETED.[ConcurrencyId],
					'U', @StampDateTime, @StampUser
				INTO [TUIFieldAttributesAudit]
					([UIFieldAttributesId],[UIFieldNameId],[AttributesName],[AttributesValue],[TenantId],[ConcurrencyId],
					 [StampAction], [StampDateTime], [StampUser])
				-------------------------------------------------

		FROM TUIFieldAttributes ATTR
		WHERE UIFieldNameId = @FieldId AND AttributesName = @AttributeName AND TenantId = @TenantId

	IF @@ERROR != 0 GOTO errh
	IF @tx = 0 COMMIT TRANSACTION TX
END

RETURN (0)

errh:
	IF @tx = 0 ROLLBACK TRANSACTION TX
	RETURN (100)
GO
