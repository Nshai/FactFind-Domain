SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomFPGetScenarioIdForOLWI]

@indigoclientid bigint,
		@financialplanningid bigint
		
as



declare 
		@lumpsum decimal,
		@newfundcount bigint,
		@scenarioid bigint



--check the tenant has access first
if(select isnull(allowaccess,0)
	from	policymanagement..TApplicationLink a
	inner join policymanagement..TRefApplication b on b.refapplicationid = a.refapplicationid
	where	applicationname = 'L & G Bond Illustration' and 			
			indigoclientid = @indigoclientid) = 1  begin
			
	-- get the chosen scenario lumpsum		
	select @lumpsum = isnull(initiallumpsum,0),
			@scenarioid = isnull(FinancialPlanningScenarioId,0)
	from	TFinancialPlanningScenario 
	where	financialplanningid = @financialplanningid and 
			PrefferedScenario = 1
			
	-- get the count of new funds associated with the session
	select @newfundcount = count(*) from TFinancialPlanningAdditionalFund where financialplanningid = @financialplanningid
	
	if(@lumpsum > 0 and @newfundcount > 0)
		select @scenarioid
			
end			
		
GO
