SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[SpCustomDashboardRetrieveGroupOpportunities]  
	@UserId bigint,  
	@GroupId bigint = 0,
	@CurrentUserDate datetime
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  
declare @ThisMonth bigint, @LastMonth bigint  

declare @ThisMonthValue money, @LastMonthValue money  

declare @ThisMonthAverage money, @LastMonthAverage money  

declare @ThisMonthStart datetime, @ThisMonthEnd datetime  

declare @LastMonthStart datetime, @LastMonthEnd datetime  

  

set @ThisMonthStart = DATEADD(mm, DATEDIFF(mm,0,@CurrentUserDate), 0)  

set @ThisMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,@CurrentUserDate)+1, 0))  

set @LastMonthStart = dateadd(mm,DATEDIFF(mm,0,DATEADD(mm,-0-DATEPART(day,0),@CurrentUserDate)),0)  

set @LastMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,@CurrentUserDate), 0))  



-- basic security check

IF NOT EXISTS(

	select 1

	FROM administration..TUser u

	JOIN administration..TGroup g on g.IndigoClientId = u.IndigoClientId

	WHERE u.UserId = @UserId AND g.GroupId = @GroupId

) 

RETURN

  

declare @Groups TABLE (GroupId bigint)  

  

if @GroupId > 0  

 begin  

  INSERT INTO @Groups   

  SELECT GroupId FROM administration..fnGetChildGroupsForGroup(@GroupId,0)  

 end  

else  

 begin  

  INSERT INTO @Groups   

  SELECT GroupId FROM administration..fnGetChildGroupsForGroup(0,@UserId)   

 end  

  

  

SELECT @ThisMonth = Count(o.OpportunityId), @ThisMonthValue = sum(Amount)  

FROM crm..TOpportunity o  

INNER JOIN crm..TPractitioner p ON o.PractitionerId = p.PractitionerId  

INNER JOIN administration..TUser u ON u.CRMContactId = p.CRMContactId  

INNER JOIN @Groups g ON u.GroupId = g.GroupId  

INNER JOIN crm..TOpportunityCustomer oc ON o.OpportunityId = oc.OpportunityId

INNER JOIN crm..TCRMContact c ON oc.PartyId = c.CRMContactId

WHERE   

 o.CreatedDate BETWEEN @ThisMonthStart AND @ThisMonthEnd AND c.ArchiveFg = 0

--GROUP BY OpportunityId  

  

SELECT @LastMonth = Count(o.OpportunityId), @LastMonthValue = sum(Amount)  

FROM crm..TOpportunity o  

INNER JOIN crm..TPractitioner p ON o.PractitionerId = p.PractitionerId  

INNER JOIN administration..TUser u ON u.CRMContactId = p.CRMContactId  

INNER JOIN @Groups g ON u.GroupId = g.GroupId  

INNER JOIN crm..TOpportunityCustomer oc ON o.OpportunityId = oc.OpportunityId

INNER JOIN crm..TCRMContact c ON oc.PartyId = c.CRMContactId

WHERE   

 o.CreatedDate BETWEEN @LastMonthStart AND @LastMonthEnd AND c.ArchiveFg = 0

--GROUP BY OpportunityId  

  

if @ThisMonth > 0 and @ThisMonthValue > 0  

 set @ThisMonthAverage = @ThisMonthValue / @ThisMonth  

else  

 set @ThisMonthAverage = 0  

  

if @LastMonth > 0 and @LastMonthValue > 0  

 set @LastMonthAverage = @LastMonthValue / @LastMonth  

else  

 set @LastMonthAverage = 0  

  

SELECT   

 isnull(@ThisMonth,0) as ThisMonthCount,   

 isnull(@ThisMonthValue,0) as ThisMonthValue,   

 isnull(@ThisMonthAverage,0) as ThisMonthAverage,   

 isnull(@LastMonth,0) as LastMonthCount,   

 isnull(@LastMonthValue,0) as LastMonthValue,   

 isnull(@LastMonthAverage,0) as LastMonthAverage  

GO
