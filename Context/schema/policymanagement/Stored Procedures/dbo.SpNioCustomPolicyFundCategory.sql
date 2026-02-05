SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create Procedure SpNioCustomPolicyFundCategory	
	@PolicyBusinessIds  VARCHAR(8000),
	@TenantId bigint
AS

	DECLARE @pbs TABLE(PolicyBusinessId INT) 

	INSERT INTO @pbs(PolicyBusinessId)
	SELECT
		CAST(ISNULL(Value, '0') AS INT)  
	FROM policymanagement..FnSplit(@PolicyBusinessIds, ',')

	Select 
		pbs.PolicyBusinessId as PolicyBusinessId ,  
		pbf.PolicyBusinessFundId as PolicyFundId,  
		cat.Name as CategoryName  
	from @pbs pbs
		inner join policymanagement..TPolicyBusinessFund pbf on pbf.PolicyBusinessId= pbs.PolicyBusinessId and pbf.FundIndigoClientId = @TenantId  
		inner join fund2..Tentitycategory ec on ec.entityID = pbf.FundId   
		and   
		  ec.EntityType =   
		   case  
			when pbf.FromFeedFg=1 and pbf.FundTypeId <> 8 then 'Fund'  
			when pbf.FromFeedFg=1 and pbf.FundTypeId = 8 then 'Equity'  
			when pbf.FromFeedFg=0 and pbf.FundTypeId <> 8 then 'ManualFund'  
			when pbf.FromFeedFg=0 and pbf.FundTypeId = 8 then 'ManualEquity'  
		   end   
		and ec.TenantId = @TenantId  
		inner join fund2..TCategory cat on cat.CategoryId=ec.CategoryId

