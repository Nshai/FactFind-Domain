SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (latest first)

Issue    	Modifier     Date     Description of Change
-----    	--------     -----    ----------------------
CRMPM-14372 	Nick Fairway 20241011 Performance improvement (8* improvement) - needed for CRMPM-2892
IP-62227 	Nick Fairway 20191010 Performance issue with SpCustomDashboardRetrieveMyLeads

*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveMyLeads
@userid int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @now datetime;
declare @TotalInitialLeads bigint, @ConvertedLastMonth bigint, @ConvertedThisMonth bigint
declare @ThisMonthStart datetime, @ThisMonthEnd datetime
declare @LastMonthStart datetime, @LastMonthEnd datetime

SELECT @now = ISNULL(@now, getdate())
set @ThisMonthStart = DATEADD(mm, DATEDIFF(mm,0,@now), 0)
set @ThisMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,@now )+1, 0))
set @LastMonthStart = dateadd(mm,DATEDIFF(mm,0,DATEADD(mm,-0-DATEPART(day,0),@now)),0)
set @LastMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,@now ), 0))

--SELECT ThisMonthStart = @ThisMonthStart, ThisMonthEnd = @ThisMonthEnd, LastMonthStart = @LastMonthStart, LastMonthEnd = @LastMonthEnd

SET @TotalInitialLeads = (
SELECT COUNT(l.LeadId)
FROM crm..TCRMContact c
INNER JOIN crm..TLead l ON l.CRMContactId = c.CRMContactId
INNER JOIN crm..TLeadStatusHistory lsh ON lsh.LeadId = l.LeadId
INNER JOIN crm..TLeadStatus ls ON ls.LeadStatusId = lsh.LeadStatusId
INNER JOIN administration..TUser u ON C.IndClientId = u.IndigoClientId AND c.CurrentAdviserCRMId = u.CRMContactId
WHERE u.UserId = @userid
AND lsh.CurrentFG = 1
AND ls.OrderNumber = 1 --initial
AND (c.ArchiveFg =0 OR c.ArchiveFg IS NULL)
)

;WITH Last2Months AS (
SELECT Ccnt= COUNT(l.LeadId)
, ConvertedLastMonth = sum(iif (lsh.DateChanged BETWEEN @LastMonthStart AND @LastMonthEnd , 1, 0) )
, ConvertedThisMonth = sum(iif (lsh.DateChanged BETWEEN @ThisMonthStart AND @ThisMonthEnd , 1, 0) )
FROM crm..TCRMContact c
INNER JOIN crm..TLead l ON l.CRMContactId = c.CRMContactId
INNER JOIN crm..TLeadStatusHistory lsh ON lsh.LeadId = l.LeadId
INNER JOIN crm..TLeadStatus ls ON ls.LeadStatusId = lsh.LeadStatusId
INNER JOIN administration..TUser u ON C.IndClientId = u.IndigoClientId AND c.CurrentAdviserCRMId = u.CRMContactId
WHERE u.UserId = @userid
AND lsh.CurrentFG = 1
AND ls.CanConvertToClientFg = 1 --initial
AND lsh.DateChanged BETWEEN @LastMonthStart AND @ThisMonthEnd
AND (c.ArchiveFg =0 OR c.ArchiveFg IS NULL)
)
SELECT @ConvertedThisMonth = isnull(ConvertedThisMonth, 0), @ConvertedLastMonth = isnull(ConvertedLastMonth, 0)
FROM Last2Months

SELECT @TotalInitialLeads as TotalInitialLeads, @ConvertedLastMonth as ConvertedLastMonth, @ConvertedThisMonth as ConvertedThisMonth

GO
