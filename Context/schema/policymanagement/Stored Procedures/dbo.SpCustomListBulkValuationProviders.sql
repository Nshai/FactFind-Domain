SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListBulkValuationProviders]
AS
BEGIN
	SELECT
		RPP.RefProdProviderId,
		C.CorporateName
	FROM
		TValProviderConfig VPC
		JOIN TRefProdProvider RPP ON RPP.RefProdProviderId = VPC.RefProdProviderId
		JOIN CRM..TCRMContact C ON C.CRMContactId = RPP.CRMContactId
	WHERE
		VPC.BulkValuationType IS NOT NULL
	ORDER BY
		C.CorporateName
	FOR XML RAW
END
GO
