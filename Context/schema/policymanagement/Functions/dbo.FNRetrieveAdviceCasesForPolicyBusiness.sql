SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description: This function returns a string of advice cases for a PolicyBusiness
-- in the format: 1|Advice Case One||2|Advice Case Two
-- =============================================
CREATE FUNCTION [dbo].[FNRetrieveAdviceCasesForPolicyBusiness]
(
	-- Add the parameters for the function here
	@PolicyBusinessId bigint
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(max)

	-- Add the T-SQL statements to compute the return value here
SELECT @ResultVar = 
substring(
			( 
			SELECT '||' + CAST(ac.AdviceCaseId AS varchar(15)) + '|' + ac.CaseName
			from TPolicyBusiness p
			LEFT JOIN CRM..TAdviceCasePlan AP ON AP.PolicyBusinessId = P.PolicyBusinessId
			LEFT JOIN CRM..TAdviceCase AC ON AC.AdviceCaseId = AP.AdviceCaseId
			where p.PolicyBusinessId = @PolicyBusinessId
			FOR XML PATH ('')
			)
,2,200000)
-- Return the result of the function
	RETURN @ResultVar

END
GO
