SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[nio_SpRetrieveLegacyRecentWorkByUrlAndTenantId]
	@Url varchar(1000),
	@TenantId bigint
AS

-- Exec nio_SpRetrieveLegacyRecentWorkByUrlAndTenantId '/nio/plan/1894137/summaryplan/3400544', 99

Select A.UserSessionId, A.RecentWork, A.UserId, A.ConcurrencyId
From TUserSession a
Join TUser b On A.UserId = B.UserId
Where 1=1
	And B.IndigoClientId = @TenantId
	And A.RecentWork Like '%' + @Url + '%'

GO
