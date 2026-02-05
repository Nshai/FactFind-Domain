SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  dbo.FnCustomRetrievePlanAttributes(@PolicyBusinessId INT, @AttributeListID INT)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @AttributesList	varchar(255)
	
	SELECT @AttributesList = isnull(@AttributesList+', ','') + TA.Value
	FROM
	PolicyManagement..TPolicyBusinessAttribute TPBA  
	LEFT JOIN PolicyManagement..TAttributeList2Attribute TAL2A ON TAL2A.AttributeList2AttributeId = tpba.AttributeList2AttributeId
	LEFT JOIN PolicyManagement..TAttribute TA ON TA.AttributeId = TAL2A.AttributeId
	WHERE (TPBA.policybusinessId = @PolicyBusinessId) AND (TAL2A.AttributeListId = @AttributeListID OR @AttributeListID = 0)
	
	RETURN (@AttributesList)
END






GO
