SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomConfigureAtrForNewNetworkedTenant]
	@NewTenantId int,
	@NetworkTenantId int
AS
-- Declarations
DECLARE 
	@IntellifloGuid uniqueidentifier, @TillinghastGuid uniqueidentifier, @NewTenantGuid uniqueidentifier, @NetworkTenantGuid uniqueidentifier,
	@BaseAtrTemplate uniqueidentifier, @NewAtrTemplateGuid uniqueidentifier, @NewAtrTemplateId bigint,
	@NewAtrCategoryGuid uniqueidentifier, @AtrCategoryId bigint,
	@TemplateName varchar(255), @TemplateDescription varchar(1000)

-- These are the indigo clients for our Intelliflo and Tillinghast accounts
SET @IntellifloGuid = 'A68438C2-AB2C-4E2D-ABA2-502FD4E3876F'	
SET @TillinghastGuid = '9D7C163A-1166-45E9-B9E7-712388CE038E'	

-- Get Guid for our new indigoclient
SELECT @NewTenantGuid = [Guid] FROM TIndigoClient WHERE IndigoClientId = @NewTenantId
-- Get guid for the network
SELECT @NetworkTenantGuid = [Guid] FROM TIndigoClient WHERE IndigoClientId = @NetworkTenantId

---------------------------------------------------------------------
-- Add preference records so that clients can use templates from Iflo and Tillinghast
---------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM TIndigoClientPreference WHERE IndigoClientId = @NewTenantId AND PreferenceName = 'AtrProfileProvider')
BEGIN
	EXEC SpCustomCreateIndigoClientPreference 0, @NewTenantId, @NewTenantGuid, 'AtrProfileProvider', @IntellifloGuid, 0
	EXEC SpCustomCreateIndigoClientPreference 0, @NewTenantId, @NewTenantGuid, 'AtrProfileProvider', @TillinghastGuid, 0
	EXEC SpCustomCreateIndigoClientPreference 0, @NewTenantId, @NewTenantGuid, 'AtrProfileProvider', @NetworkTenantGuid, 0
	EXEC SpCustomCreateIndigoClientPreference 0, @NewTenantId, @NewTenantGuid, 'AtrModelProvider', @NetworkTenantGuid, 0
END

---------------------------------------------------------------------
-- Add a new ATR template for this indigo client 
---------------------------------------------------------------------
SET @NewAtrTemplateGuid = NEWID()
-- we'll base this on the active template for the network
SELECT 
	@BaseAtrTemplate = [Guid],
	@TemplateName = Identifier,
	@TemplateDescription = Descriptor
FROM 
	FactFind..TAtrTemplate 
WHERE 
	IndigoClientId = @NetworkTenantId AND Active = 1

IF NOT EXISTS (SELECT 1 FROM FactFind..TAtrTemplate WHERE IndigoClientId = @NewTenantId)
BEGIN
	EXEC FactFind..SpCreateAtrTemplate 0, @TemplateName, @TemplateDescription, 1, 0, @BaseAtrTemplate, @NewTenantId, @NewAtrTemplateGuid
	EXEC FactFind..SpCustomCreateAtrTemplateCombined 0, @NewAtrTemplateGuid
	-- Add settings for the template
	SELECT @NewAtrTemplateId = AtrTemplateId FROM FactFind..TAtrTemplate WHERE [Guid]	= @NewAtrTemplateGuid
	EXEC FactFind..SpCreateAtrTemplateSetting 0, @NewAtrTemplateId, 1
END

---------------------------------------------------------------------
-- Add Default Question Category
---------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM FactFind..TAtrCategory WHERE TenantId = @NewTenantId) BEGIN
	SET @NewAtrCategoryGuid = NEWID()

	-- Create Default Category
	INSERT FactFind..TAtrCategory([Guid], TenantId, TenantGuid, Name, IsArchived, ConcurrencyId)
	SELECT @NewAtrCategoryGuid, @NewTenantId, @NewTenantGuid, 'Default', 0, 1
	-- Get Id
	SET @AtrCategoryId = SCOPE_IDENTITY()
	-- Audit 
	EXEC FactFind..SpNAuditAtrCategory '0', @AtrCategoryId, 'C'
	EXEC FactFind..SpCustomCreateAtrCategoryCombined '0', @NewAtrCategoryGuid

	---------------------------------------------------------------------		
	-- Link Atr Questions to the new category
	---------------------------------------------------------------------		
	INSERT INTO FactFind..TAtrCategoryQuestion (AtrCategoryGuid, AtrQuestionGuid, AtrTemplateGuid)
	SELECT @NewAtrCategoryGuid, [Guid], @NewAtrTemplateGuid
	FROM FactFind..TAtrQuestionCombined
	WHERE AtrTemplateGuid = @BaseAtrTemplate

	INSERT INTO FactFind..TAtrCategoryQuestionAudit (AtrCategoryQuestionId, AtrCategoryGuid, AtrQuestionGuid, AtrTemplateGuid, ConcurrencyId, StampAction, StampDateTime, StampUser)
	SELECT AtrCategoryQuestionId, AtrCategoryGuid, AtrQuestionGuid, AtrTemplateGuid, ConcurrencyId, 'C', GETDATE(), 0
	FROM FactFind..TAtrCategoryQuestion
	WHERE AtrTemplateGuid = @NewAtrTemplateGuid
	
	---------------------------------------------------------------------		
	-- Set up default answers for each question
	---------------------------------------------------------------------		
	INSERT INTO FactFind..TAtrAnswerCategory (AtrCategoryQuestionId, AtrAnswerGuid, Ordinal, Weighting)
	SELECT CQ.AtrCategoryQuestionId, A.[Guid], A.Ordinal, A.Weighting
	FROM 
		FactFind..TAtrCategoryQuestion CQ
		JOIN FactFind..TAtrAnswerCombined A ON A.AtrQuestionGuid = CQ.AtrQuestionGuid		
	WHERE CQ.AtrTemplateGuid = @NewAtrTemplateGuid AND CQ.AtrCategoryGuid = @NewAtrCategoryGuid
		
	-- Audit
	INSERT INTO FactFind..TAtrAnswerCategoryAudit (AtrAnswerCategoryId, AtrCategoryQuestionId, AtrAnswerGuid, Ordinal, Weighting, ConcurrencyId, StampAction, StampDateTime, StampUser)
	SELECT AC.AtrAnswerCategoryId, AC.AtrCategoryQuestionId, AC.AtrAnswerGuid, AC.Ordinal, AC.Weighting, AC.ConcurrencyId, 'C', GETDATE(), 0
	FROM 	
		FactFind..TAtrCategoryQuestion CQ
		JOIN FactFind..TAtrAnswerCategory AC ON AC.AtrCategoryQuestionId = CQ.AtrCategoryQuestionId
	WHERE CQ.AtrTemplateGuid = @NewAtrTemplateGuid AND CQ.AtrCategoryGuid = @NewAtrCategoryGuid	
END
GO
