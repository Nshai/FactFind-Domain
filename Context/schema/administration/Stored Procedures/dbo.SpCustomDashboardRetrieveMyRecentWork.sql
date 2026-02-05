SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveMyRecentWork]
	@UserId int
AS
declare @recent TABLE (Descriptor varchar(1000), URL varchar(1000), ClientIdString varchar(20), ClientId int)
declare @recentWork varchar(8000)
declare @StartPos int, @EndPos int, @Current varchar(8000)
declare @CurrentName varchar(1000), @CurrentUrl varchar(1000)

SET NOCOUNT ON
--------------------------------------------------------------------
-- Extract recent work items from string
--------------------------------------------------------------------
set @RecentWork = (select convert(varchar(8000),RecentWork) from tUserSession where UserId = @UserId)
set @StartPos = 1
set @EndPos = 1

while @EndPos > 0  
begin  
	set @EndPos = charIndex('!',@RecentWork, @StartPos)  
	if @EndPos = 0  
		set @Current =  substring(@RecentWork, @StartPos, (len(@RecentWork) - @StartPos)+1)  
	else  
		set @Current =  substring(@RecentWork, @StartPos, @EndPos - @StartPos)  
  
	if len(@Current) > 0
	begin
		set @CurrentName = left(@Current, charindex('~', @Current)-1)  
		set @CurrentUrl = substring(@Current, charindex('~', @Current)+1, len(@Current)-charindex('~', @Current))  
	    
		INSERT INTO @recent(Descriptor, Url) VALUES (@CurrentName, replace(@CurrentUrl,'£',''))  
	end

  	SET @StartPos = @endPos + 1
end

--------------------------------------------------------------------
-- we need to determine if clients in recent work have been archived
--------------------------------------------------------------------
-- try to extract client id from recent clients
UPDATE @recent
SET ClientIdString = REPLACE(REPLACE(Url, '/nio/clientdashboard/', ''), '/dashboard', '')
FROM @recent
WHERE LEFT(Descriptor, 7) = 'client:'

-- try to extract client id from recent plans
UPDATE @recent
SET ClientIdString = SUBSTRING(url, CHARINDEX('/nio/plan/', url) + LEN('/nio/plan/') , CHARINDEX('/summaryplan/', url) - (CHARINDEX('/nio/plan/', url) + LEN('/nio/plan/')) )
FROM @recent
WHERE LEFT(Descriptor, 6) = 'plan:'


UPDATE @recent
SET ClientId = CONVERT(int, ClientIdString)
WHERE ISNUMERIC(ClientIdString) = 1

-- delete archived
DELETE R
FROM 
	@recent R
	JOIN CRM..TCRMContact C ON C.CRMContactId = R.ClientId
WHERE
	ClientId IS NOT NULL AND C.ArchiveFg = 1

-- delete archived
DELETE R
FROM 
	@recent R
	JOIN CRM..TCRMContact C ON C.CRMContactId = R.ClientId
WHERE
	ClientId IS NOT NULL AND C.IsDeleted = 1

--------------------------------------------------------------------
-- Return list of work
--------------------------------------------------------------------
SELECT Descriptor, Url FROM @recent
GO
