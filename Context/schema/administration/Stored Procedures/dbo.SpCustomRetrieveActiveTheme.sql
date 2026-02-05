SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.[SpCustomRetrieveActiveTheme]
	@TenantId bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT
	T.Skin,
	T.ColourPrimary,
	T.ColourSecondary,
	T.ColourHighlight
FROM
	TAllocatedTheme AT
	JOIN TTheme T ON T.ThemeId = AT.ThemeId
WHERE
	TenantId = @TenantId
	AND IsActive = 1
GO
