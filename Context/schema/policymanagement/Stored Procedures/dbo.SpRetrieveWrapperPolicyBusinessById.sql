SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveWrapperPolicyBusinessById]
	@WrapperPolicyBusinessId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.WrapperPolicyBusinessId AS [WrapperPolicyBusiness!1!WrapperPolicyBusinessId], 
	T1.ParentPolicyBusinessId AS [WrapperPolicyBusiness!1!ParentPolicyBusinessId], 
	T1.PolicyBusinessId AS [WrapperPolicyBusiness!1!PolicyBusinessId], 
	T1.ConcurrencyId AS [WrapperPolicyBusiness!1!ConcurrencyId]
	FROM TWrapperPolicyBusiness T1
	
	WHERE T1.WrapperPolicyBusinessId = @WrapperPolicyBusinessId
	ORDER BY [WrapperPolicyBusiness!1!WrapperPolicyBusinessId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
