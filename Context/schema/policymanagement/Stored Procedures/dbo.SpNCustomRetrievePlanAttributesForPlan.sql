SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanAttributesForPlan]  
@PolicyBusinessId bigint
AS

BEGIN  
 

  --Attributes
  SELECT A.PolicyBusinessId,A.PolicyBusinessAttributeId,A.AttributeList2AttributeId,ISNULL(A.AttributeValue,'')'AttributeValue', B.AttributeListId
  FROM TPolicyBusinessAttribute A WITH(NOLOCK)
  JOIN TAttributeList2Attribute B WITH(NOLOCK) ON A.AttributeList2AttributeId=B.AttributeList2AttributeId
  WHERE A.PolicyBusinessId=@PolicyBusinessId

END  
RETURN (0)
GO
