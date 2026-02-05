USE [policymanagement]
GO

/****** Object:  UserDefinedFunction [dbo].[FnCustomIsRetirementOrInvestmentsPlans]    Script Date: 18/12/2017 17:39:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION [dbo].[FnCustomIsRetirementOrInvestmentsPlans] (@RefPlanTypeId BIGINT)
RETURNS BIT
AS
BEGIN
	IF EXISTS (SELECT TOP 1 b.RefPlanTypeId FROM TRefPlanType2ProdSubType a
			LEFT JOIN TRefPlanType b ON a.RefPlanTypeId=b.RefPlanTypeId
			LEFT JOIN TRefFactFindCategoryPlanType f ON a.RefPlanTypeId=f.RefPlanTypeId
			LEFT JOIN TRefFactFindCategory d ON d.RefFactFindCategoryId=f.RefFactFindCategoryId
			WHERE d.RefFactFindCategoryId IN (2,4) AND b.RefPlanTypeId =@RefPlanTypeId)
	RETURN 1

	RETURN 0

END

GO


