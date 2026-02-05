SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveGroupSchemesForClientAndProvider] @TenantId bigint,@CRMContactId bigint, @RefProdProviderId bigint
AS


SELECT 1 AS Tag,
NULL AS Parent,
A.GroupSchemeId AS [GroupScheme!1!GroupSchemeId],
CASE ISNULL(A.SchemeNumber,'')
	WHEN '' THEN B.SequentialRef + ': ' + A.SchemeName
	ELSE  B.SequentialRef + ': ' + A.SchemeName + '(' + A.SchemeNumber + ')' 
END AS [GroupScheme!1!SchemeName],
A.SchemeName AS [GroupScheme!1!HideName!hide]


FROM PolicyManagement..TGroupScheme A
JOIN PolicyManagement..TPolicyBusiness B ON A.PolicyBusinessId=B.PolicyBusinessId
JOIN PolicyManagement..TPolicyDetail C ON B.PolicyDetailId=C.PolicyDetailId
JOIN PolicyManagement..TPlanDescription D ON C.PlanDescriptionId=D.PlanDescriptionId


WHERE A.TenantId=@TenantId
AND A.OwnerCRMContactId=@CRMContactId
AND D.RefProdProviderId=@RefProdProviderId

ORDER BY [GroupScheme!1!HideName!hide]

FOR XML EXPLICIT

GO
