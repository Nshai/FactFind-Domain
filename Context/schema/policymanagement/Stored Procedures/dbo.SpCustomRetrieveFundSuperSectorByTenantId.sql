SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomRetrieveFundSuperSectorByTenantId
	@TenantId bigint
AS
SELECT
	FundSuperSectorId,
	[Name]
FROM
	TFundSuperSector
WHERE
	TenantId = @TenantId
ORDER BY [Name]	
FOR XML RAW('FundSuperSector')

GO
