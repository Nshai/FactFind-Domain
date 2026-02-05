SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveBulkValuationReport]
	@bulkSummaryId bigint
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @DateStamp datetime2, @providername varchar(255), @valscheduleid bigint

SELECT @providername =  c.CorporateName, @valscheduleid = s.ValScheduleId
	from
		TValBulkSummary BS
		JOIN TValScheduleItem I ON bs.ValScheduleItemId = i.ValScheduleItemId
		JOIN TValSchedule s ON I.ValScheduleId = s.ValScheduleId
        JOIN TRefProdProvider RP ON RP.RefProdProviderId = S.RefProdProviderId
        JOIN CRM..TCrmcontact C ON C.CrmContactID = RP.CrmContactID
    WHERE BS.ValBulkSummaryId = @bulkSummaryId

select @DateStamp = max(Qtimestamp) from
(
select MAX(Qtimestamp) Qtimestamp from tvalbulkprocessed where ValScheduleId = @valscheduleid
union
select MAX(Qtimestamp) Qtimestamp from tvalbulknotmatched where ValScheduleId = @valscheduleid
) a

select 
	Case when @providername = 'Bulk Manual Template' then PolicyProviderName else @providername end ProviderName
	,PortfolioReference
	,CustomerReference
	,Sedol
	,MexId
	,ISIN
	,CitiCode
	,ProviderFundCode
	,_FundName FundName
	,FundQuantity Quantity
	,EffectiveDate
	,Price
	,FundPriceDate PriceDate
	,Currency
	,EpicCode
	,'Plan matched' Remarks
from tvalbulkprocessed 
where ValScheduleId = @valscheduleid and Qtimestamp = @DateStamp
union  all
select
	Case when @providername = 'Bulk Manual Template' then PolicyProviderName else @providername end ProviderName
	,PortfolioReference
	,CustomerReference
	,Sedol
	,MexId
	,ISIN
	,CitiCode
	,ProviderFundCode
	,_FundName
	,FundQuantity
	,EffectiveDate
	,Price
	,FundPriceDate
	,Currency
	,EpicCode
	,CASE WHEN PlanInEligibilityMask = 2 Then 'Duplicate fund grouping error' ELSE 'No eligible plan found in IO' END AS Remarks
from tvalbulknotmatched 
where ValScheduleId = @valscheduleid and Qtimestamp = @DateStamp

