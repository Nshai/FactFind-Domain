SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAvailableAttributesByRefPlanTypeId]  
@RefPlanTypeId bigint  
AS  
  
BEGIN  
	--AttributeList
	SELECT B.AttributeListId,ISNULL(B.Type,'')'Type',ISNULL(B.[Name],'')'AttributeListName',B.ConcurrencyId
	FROM TRefPlanTypeAttribute A 
	JOIN TAttributeList B ON A.AttributeListId=B.AttributeListId
	

	WHERE A.RefPlanTypeId=@RefPlanTypeId
    ORDER BY B.AttributeListId


	--Attribute
	SELECT B.AttributeListId,C.AttributeList2AttributeId,D.AttributeId,ISNULL(D.Value,'')'Value'
	FROM TRefPlanTypeAttribute A 
	JOIN TAttributeList B ON A.AttributeListId=B.AttributeListId
	JOIN TAttributeList2Attribute C ON B.AttributeListId=C.AttributeListId
	LEFT JOIN TAttribute D ON C.AttributeId=D.AttributeId

	WHERE A.RefPlanTypeId=@RefPlanTypeId
	ORDER BY B.AttributeListId
	

END
GO
