SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnIsAdviserSearchSecured](
	@TenantId bigint)
RETURNS bit
AS
BEGIN
	RETURN dbo.FnCustomTenantHasPreference(@TenantId, 'SecureAdviserSearch', 'True')
END
GO