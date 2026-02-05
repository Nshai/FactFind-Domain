SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDeleteOrphanNonFeedFund]
@IndigoClientId bigint
AS  
  
BEGIN  
  

declare @stampdatetime datetime = getdate(), @stampuser varchar(1) = '0', @stampaction varchar(1) = 'D'
set nocount on

if OBJECT_ID('tempdb..#tmpNonFeedFundId') is not null drop table #tmpNonFeedFundId
create table #tmpNonFeedFundId(nonfeedfundId int, tag varchar(30), indigoclientid int)
insert into #tmpNonFeedFundId (nonfeedfundId, tag)

	select fundid , 'PolicyBusinessFund'  from TPolicyBusinessFund where FromFeedFg = 0
	union all
	select fundid,  'SuperSector'  from TFundToFundSuperSector where IsFromFeed = 0
	union all
	select fundid,  'FundDefaultRisk'  from TFundDefaultRisk where FromFeedFg = 0
	union all
	select fundid,  'FundPriceOverride'  from TFundPriceOverride where FromFeedFg = 0
	union all
	select NonFeedFundId, 'NonFeedFundAtrAssetClass' from TNonFeedFundAtrAssetClass 
	union all
	select fundid, 'AtrAssetClassFundId' from factfind..TAtrAssetClassFund where FromFeed = 0
	union all
	select FundUnitId, 'FundProposal' from TFundProposal where IsFromSeed = 0
	union all
	select nonfeedfundid, 'Sector' from TNonFeedFund where (coalesce(categoryid,'') <> '' or coalesce(categoryname,'') <> '') and IndigoClientId = @IndigoClientId
	
	update 	t set indigoclientid = nf.IndigoClientId
	from #tmpNonFeedFundId t 
		join  tnonfeedfund nf on t.nonfeedfundId = nf.NonFeedFundId

--select COUNT(1) NumberOfNonfeedfundsToBeDeleted, ic.IndigoClientId TenantId, ic.Identifier TenantName
--	from TNonFeedFund nf 
--		join Administration..TIndigoClient ic on nf.IndigoClientId = ic.IndigoClientId
--	where not exists (select 1 from #tmpNonFeedFundId where nonfeedfundId = nf.NonFeedFundId )	
--	group by ic.IndigoClientId, ic.Identifier
--	order by 1 desc
	
--select COUNT(1) NumberOfNonfeedfundsToBeRetained, ic.IndigoClientId TenantId, ic.Identifier TenantName
--	from TNonFeedFund nf 
--		join Administration..TIndigoClient ic on nf.IndigoClientId = ic.IndigoClientId
--	where exists (select 1 from #tmpNonFeedFundId where nonfeedfundId = nf.NonFeedFundId )	
--	group by ic.IndigoClientId, ic.Identifier
--	order by 1 desc

	declare @totalRecords int = 0, @recordsDeleted int = 0;

	while 1 = 1
	begin

		delete top (10000) nf
			output
				deleted.FundTypeId, deleted.FundTypeName, deleted.FundName, deleted.CompanyId, deleted.CompanyName, deleted.CategoryId, deleted.CategoryName, deleted.Sedol, 
				deleted.MexId, deleted.IndigoClientId, deleted.CurrentPrice, 
				deleted.PriceDate, deleted.PriceUpdatedByUser, deleted.IsClosed, deleted.IsArchived, deleted.IncomeYield, deleted.ConcurrencyId, deleted.NonFeedFundId, 
				@StampAction, @StampDateTime, @StampUser
			into [dbo].[TNonFeedFundAudit]
				(FundTypeId, FundTypeName, FundName, CompanyId, CompanyName, CategoryId, CategoryName, Sedol, MexId, IndigoClientId, CurrentPrice, 
				PriceDate, PriceUpdatedByUser, IsClosed, IsArchived, IncomeYield, ConcurrencyId, NonFeedFundId, StampAction, StampDateTime, StampUser)
		from TNonFeedFund nf 
			join Administration..TIndigoClient ic on nf.IndigoClientId = ic.IndigoClientId
			left join #tmpNonFeedFundId tmp on tmp.nonfeedfundId = nf.NonFeedFundId and tmp.indigoclientid = @IndigoClientId 
		where 
			ic.IndigoClientId = @IndigoClientId and tmp.nonfeedfundId is null

		set @recordsDeleted = @@ROWCOUNT

		if @recordsDeleted = 0
			break

		SET @totalRecords = @totalRecords + @recordsDeleted

	end

	return @totalRecords

set nocount off

end

GO
