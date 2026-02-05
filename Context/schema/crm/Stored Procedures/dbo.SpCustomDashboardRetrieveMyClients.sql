SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomDashboardRetrieveMyClients]
	@UserId bigint
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @ThisMonth bigint
declare @LastMonth bigint
declare @TotalPersonClients bigint
declare @TotalCorporateClients bigint
declare @TotalTrustClients bigint
declare @ThisMonthStart datetime, @ThisMonthEnd datetime
declare @LastMonthStart datetime, @LastMonthEnd datetime

set @ThisMonthStart = DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)
set @ThisMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,getdate()  )+1, 0))
set @LastMonthStart = dateadd(mm,DATEDIFF(mm,0,DATEADD(mm,-0-DATEPART(day,0),getdate())),0)
set @LastMonthEnd = dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,getdate()  ), 0))

SET @ThisMonth = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	WHERE u.UserId = @UserId	
	AND c.RefCRMContactStatusId = 1
	AND CreatedDate BETWEEN @ThisMonthStart AND @ThisMonthEnd
	AND ISNULL(c.ArchiveFg, 0) = 0
		)

SET @LastMonth = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	WHERE u.UserId = @UserId
	AND c.RefCRMContactStatusId = 1
	AND CreatedDate BETWEEN @LastMonthStart AND @LastMonthEnd
	AND ISNULL(c.ArchiveFg, 0) = 0
		)

SET @TotalPersonClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	WHERE u.UserId = @UserId
	AND c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 1
	AND ISNULL(c.ArchiveFg, 0) = 0
		)

SET @TotalCorporateClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	WHERE u.UserId = @UserId
	AND c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 2
	AND ISNULL(c.ArchiveFg, 0) = 0
		)

SET @TotalTrustClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	WHERE u.UserId = @UserId
	AND c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 3
	AND ISNULL(c.ArchiveFg, 0) = 0
		)


SELECT 
	@ThisMonth as ClientsAddedThisMonth, 
	@LastMonth as ClientsAddedLastMonth, 
	@TotalPersonClients + @TotalCorporateClients + @TotalTrustClients as TotalClients
	
GO
