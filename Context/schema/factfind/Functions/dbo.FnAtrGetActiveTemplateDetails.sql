SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnAtrGetActiveTemplateDetails](@IndigoClientId bigint)
RETURNS @ATR TABLE (AtrTemplateGuid uniqueidentifier, AtrRefProfilePreferenceId tinyint)
AS
BEGIN
DECLARE 
	@Guid uniqueidentifier,
	@BaseGuid uniqueidentifier,
	@ProfilePreference tinyint

-- Get the active template for this indigo client
SELECT 
	@Guid = Guid,
	@BaseGuid = BaseAtrTemplate,
	@ProfilePreference = AtrRefProfilePreferenceId
FROM
	TAtrTemplate T
	JOIN TAtrTemplateSetting S ON S.AtrTemplateId = T.AtrTemplateId
WHERE	
	IndigoClientId = @IndigoClientId
	AND Active = 1		

-- if there's a base template then use this instead
IF @BaseGuid IS NOT NULL
	SET @Guid = @BaseGuid

INSERT INTO @ATR 
VALUES (@Guid, @ProfilePreference)

RETURN
END
GO
