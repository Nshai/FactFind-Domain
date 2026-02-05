SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[spCustomTransitionRule_Attributes]
  @PolicyBusinessId bigint,
  @ResponseCode varchar(512) output
AS


DECLARE @RefPlanTypeId bigint
DECLARE @AttributeListCount int
DECLARE @RefPlanTypeName varchar(50)

SELECT @RefPlanTypeId = TRefPlanType.RefPlanTypeId, @RefPlanTypeName=PlanTypeName
FROM    TPlanDescription INNER JOIN
              TPolicyDetail ON TPlanDescription.PlanDescriptionId = TPolicyDetail.PlanDescriptionId INNER JOIN
              TPolicyBusiness ON TPolicyDetail.PolicyDetailId = TPolicyBusiness.PolicyDetailId INNER JOIN
              TRefPlanType2ProdSubType ON 
              TPlanDescription.RefPlanType2ProdSubTypeId = TRefPlanType2ProdSubType.RefPlanType2ProdSubTypeId INNER JOIN
              TRefPlanType ON TRefPlanType2ProdSubType.RefPlanTypeId = TRefPlanType.RefPlanTypeId
WHERE TPolicyBusiness.PolicyBusinessId = @PolicyBusinessId

IF @RefPlanTypeName NOT IN ('Mortgage', 'Equity Release')
BEGIN
SELECT  @AttributeListCount = COUNT(TAttributeList.AttributeListId)
FROM      TRefPlanTypeAttribute INNER JOIN
                TAttributeList ON TRefPlanTypeAttribute.AttributeListId = TAttributeList.AttributeListId 
WHERE  TRefPlanTypeAttribute.RefPlanTypeId = @RefPlanTypeId AND TAttributeList.Name <>  'Fund Category'


IF (@AttributeListCount > 0)
      BEGIN
          DECLARE @Attributes int
          SET @Attributes = (
		SELECT Count(PolicyBusinessAttributeId) 
		FROM TPolicyBusinessAttribute T1 
		INNER JOIN TAttributeList2Attribute T2 ON T1.AttributeList2AttributeId = T2.AttributeList2AttributeId  
		WHERE PolicyBusinessId = @PolicyBusinessId
    AND T1.AttributeValue NOT IN ('__null', '') 
		AND T2.AttributeListId NOT IN (SELECT AttributeListId FROM TAttributeList WHERE [Name] = 'Fund Category'))
          IF (@Attributes = 0)
          BEGIN
             SELECT @ResponseCode = 'ATTRIBUTES'
          END
      END
END



GO
