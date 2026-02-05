create procedure p_BV_process_rowcount
@stampdatetime datetime2
as
select 'TPolicyBusinessFundAudit',Stampaction,count(1) from TPolicyBusinessFundAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TPolicyBusinessFund_LastUnitChangeDate','U',count(1) from TPolicyBusinessFund where LastUnitChangeDate = @stampdatetime 
union all
select 'TPolicyBusinessExtAudit',Stampaction,count(1) from TPolicyBusinessExtAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TPolicyBusinessAudit',Stampaction,count(1) from TPolicyBusinessAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TValBulkSummaryAudit',Stampaction,count(1) from TValBulkSummaryAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TNonFeedFundAudit',Stampaction,count(1) from TNonFeedFundAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TPlanValuationAudit',Stampaction,count(1) from TPlanValuationAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TPolicyBusinessFundTransactionAudit',Stampaction,count(1) from TPolicyBusinessFundTransactionAudit where StampDateTime = @stampdatetime group by Stampaction
union all
select 'TPlanValuation','C',count(1) from TPlanValuation where PlanValueDate = @stampdatetime
union all
select 'TBulkValProcessed','C',count(1) from TBulkValProcessed where Qtimestamp = @stampdatetime 
union all
select 'TBulkValNotMatched','C',count(1) from TBulkValNotMatched where Qtimestamp = @stampdatetime 
union all
select 'TValBulkSummaryAudit',null,count(1) from TValBulkSummaryAudit  where StampDateTime = @stampdatetime
