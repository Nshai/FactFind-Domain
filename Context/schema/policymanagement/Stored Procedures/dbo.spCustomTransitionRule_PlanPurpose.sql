SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_PlanPurpose]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

DECLARE @RefPlanType2ProdSubTypeId bigint
DECLARE @IndigioClientId bigint

--   Check if this Plan Type has any Plan Purposes
SELECT @RefPlanType2ProdSubTypeId = TPlanDescription.RefPlanType2ProdSubTypeId,@IndigioClientId = TPolicyBusiness.IndigoClientId
FROM    TPlanDescription INNER JOIN
              TPolicyDetail ON TPlanDescription.PlanDescriptionId = TPolicyDetail.PlanDescriptionId INNER JOIN
              TPolicyBusiness ON TPolicyDetail.PolicyDetailId = TPolicyBusiness.PolicyDetailId 
WHERE TPolicyBusiness.PolicyBusinessId = @PolicyBusinessId



--    Check if  Plan Purpose is selected
       IF (SELECT COUNT(PlanTypePurposeId) FROM TPlanTypePurpose  A INNER JOIN TPlanPurpose B ON A.PlanPurposeId = B.PlanPurposeId WHERE A.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId AND B.IndigoClientId = @IndigioClientId) > 0
       BEGIN
           DECLARE @PlanPurposeCount int
           SET @PlanPurposeCount = (SELECT COUNT(PolicyBusinessPurposeId) FROM TPolicyBusinessPurpose WHERE PolicyBusinessId = @PolicyBusinessId)
           IF (@PlanPurposeCount = 0)
           BEGIN
             SELECT @ErrorMessage = 'PLANPURPOSE' 
           END
       END



GO
