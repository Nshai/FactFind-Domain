SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnIsUserSearchSecured](
	@TenantId bigint)
RETURNS bit
AS
BEGIN
	RETURN dbo.FnCustomTenantHasPreference(@TenantId, 'SecureUserSearch', 'True')
END
GO