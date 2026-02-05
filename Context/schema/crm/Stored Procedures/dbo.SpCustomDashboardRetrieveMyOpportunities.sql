SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomDashboardRetrieveMyOpportunities]
	@UserId bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ThisMonth BIGINT, @LastMonth BIGINT
DECLARE @ThisMonthValue MONEY, @LastMonthValue MONEY
DECLARE @ThisMonthAverage MONEY, @LastMonthAverage MONEY
DECLARE @ThisMonthStart DATETIME, @ThisMonthEnd DATETIME
DECLARE @LastMonthStart DATETIME, @LastMonthEnd DATETIME

SET @ThisMonthStart = DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)
SET @ThisMonthEnd = DATEADD(ms,-3,DATEADD(mm, DATEDIFF(m,0,getdate()  )+1, 0))
SET @LastMonthStart = DATEADD(mm,DATEDIFF(mm,0,DATEADD(mm,-0-DATEPART(day,0),getdate())),0)
SET @LastMonthEnd = DATEADD(ms,-3,DATEADD(mm, DATEDIFF(mm,0,getdate()  ), 0))

SELECT @ThisMonth = COUNT(DISTINCT o.OpportunityId), @ThisMonthValue = SUM(Amount)
FROM TOpportunity o
INNER JOIN TPractitioner p ON o.PractitionerId = p.PractitionerId
INNER JOIN administration..TUser u ON u.CRMContactId = p.CRMContactId
INNER JOIN TOpportunityCustomer oc on oc.OpportunityId = o.OpportunityId
AND oc.OpportunityCustomerId = (SELECT MIN(OpportunityCustomerId) 
                                FROM TOpportunityCustomer 
                                WHERE OpportunityId = o.OpportunityId) 
INNER JOIN TCRMContact c ON c.CRMContactId = oc.PartyId
WHERE u.UserId = @UserId
AND c.ArchiveFg = 0
AND o.CreatedDate BETWEEN @ThisMonthStart AND @ThisMonthEnd

SELECT @LastMonth = COUNT(DISTINCT o.OpportunityId), @LastMonthValue = SUM(Amount)
FROM TOpportunity o
INNER JOIN TPractitioner p ON o.PractitionerId = p.PractitionerId
INNER JOIN administration..TUser u ON u.CRMContactId = p.CRMContactId
INNER JOIN TOpportunityCustomer oc on oc.OpportunityId = o.OpportunityId
 AND oc.OpportunityCustomerId = (SELECT MIN(OpportunityCustomerId) 
                                 FROM TOpportunityCustomer 
                                WHERE OpportunityId = o.OpportunityId) 
INNER JOIN TCRMContact c ON c.CRMContactId = oc.PartyId
WHERE u.UserId = @UserId
AND c.ArchiveFg = 0
AND o.CreatedDate BETWEEN @LastMonthStart AND @LastMonthEnd

if @ThisMonth > 0 and @ThisMonthValue > 0
	set @ThisMonthAverage = @ThisMonthValue / @ThisMonth
else
	set @ThisMonthAverage = 0

if @LastMonth > 0 and @LastMonthValue > 0
	set @LastMonthAverage = @LastMonthValue / @LastMonth
else
	set @LastMonthAverage = 0

SELECT 
	ISNULL(@ThisMonth,0) as ThisMonthCount, 
	ISNULL(@ThisMonthValue,0) as ThisMonthValue, 
	ISNULL(@ThisMonthAverage,0) as ThisMonthAverage, 
	ISNULL(@LastMonth,0) as LastMonthCount, 
	ISNULL(@LastMonthValue,0) as LastMonthValue, 
	ISNULL(@LastMonthAverage,0) as LastMonthAverage
	
GO
