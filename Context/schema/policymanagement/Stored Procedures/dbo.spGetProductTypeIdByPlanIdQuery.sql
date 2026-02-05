SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Description: Gets RefPlanType2ProdSubTypeId for PolicyBusiness by PolicyBusinessId
-- =============================================

CREATE PROCEDURE [dbo].[spGetProductTypeIdByPlanIdQuery]
    @planId INT
AS
BEGIN
    SELECT RefPlanType2ProdSubTypeId
    FROM TPlanDescription tpd
    INNER JOIN TPolicyDetail tpdet ON tpdet.PlanDescriptionId = tpd.PlanDescriptionId
    INNER JOIN TPolicyBusiness tpb ON tpb.PolicyDetailId = tpdet.PolicyDetailId
    WHERE tpb.PolicyBusinessId = @planId
END
GO