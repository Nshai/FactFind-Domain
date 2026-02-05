SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE dbo.SpNCustomRetrievePlanTypeWrappers
AS

WITH t (Id, RefPlanTypeId, RefProdProviderId, RefPlanType2ProdSubTypeId)
AS
(
	SELECT ROW_NUMBER() OVER (ORDER BY P2PforPlantype.RefPlanType2ProdSubTypeId, WP.RefProdProviderId, P2P.RefPlanType2ProdSubTypeId), 
	      P2PforPlantype.RefPlanType2ProdSubTypeId, WP.RefProdProviderId, P2P.RefPlanType2ProdSubTypeId
	FROM
	 policymanagement..TWrapperProvider WP WITH(NOLOCK)
	 INNER JOIN policymanagement..TWrapperPlanType WPT  WITH(NOLOCK) ON wp.WrapperProviderId = WPT.WrapperProviderId
	 INNER JOIN PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK) ON WPT.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId
	 INNER JOIN PolicyManagement..TRefPlanType2ProdSubType P2PforPlantype  WITH(NOLOCK) ON WP.RefPlanTypeId = P2PforPlantype.RefPlanTypeId
	
)
select Id, RefPlanTypeId, RefProdProviderId, RefPlanType2ProdSubTypeId
from t
order by 2, 3, 4



GO
