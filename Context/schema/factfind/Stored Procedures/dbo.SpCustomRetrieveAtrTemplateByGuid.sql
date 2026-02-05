SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrTemplateByGuid]
	@Guid uniqueidentifier
AS

-- List of distinct template providers for this client
SELECT
	*
FROM
	TAtrTemplateCombined A
WHERE
	Guid = @Guid
FOR
	XML RAW
GO
