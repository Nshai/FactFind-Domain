SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomDashboardRetrieveDashboardForUser]
@UserId bigint

AS

BEGIN

DECLARE @ActiveRole bigint, @Dashboard varchar(255), @ShowGroupDashboard bit

SELECT @ActiveRole = ActiveRole FROM TUser WHERE UserId = @UserId

IF @ActiveRole IS NULL
	SET @ActiveRole = (select TOP 1 RoleId FROM TMembership WHERE UserId = @UserId)

IF @ActiveRole IS NOT NULL
	BEGIN
		SELECT @Dashboard = Dashboard, @ShowGroupDashboard = ShowGroupDashboard 
		FROM TRole
		WHERE RoleId = @ActiveRole
	END

IF @Dashboard = '' SET @Dashboard = 'default'

SELECT ISNULL(@Dashboard,'default') as Dashboard, ISNULL(@ShowGroupDashboard,0) as ShowGroupDashboard FOR XML RAW

END


GO
