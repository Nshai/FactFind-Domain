SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListValuationProviders]
AS
BEGIN
	SELECT
		1 AS Tag,
		NULL AS Parent,
		RPP.RefProdProviderId AS [Row!1!RefProdProviderId],
		C.CorporateName AS [Row!1!Identifier]
	FROM
		TValProviderConfig VPC
		JOIN TRefProdProvider RPP ON RPP.RefProdProviderId = VPC.RefProdProviderId
		JOIN CRM..TCRMContact C ON C.CRMContactId = RPP.CRMContactId
	ORDER BY
		C.CorporateName
	FOR XML EXPLICIT
END
GO
