SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveMyOpenServiceCasesByStatus] 
	@UserId INT,
	@TenantId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN

-- basic security check
	IF NOT EXISTS(
		SELECT 1
		FROM administration..TUser u
		WHERE u.UserId = @UserId AND u.IndigoClientId = @TenantId
	) 
	RETURN

	--count service cases statuses for Advisers, Servicing Admin and Paraplanner
	SELECT s.Descriptor, COUNT(*)
	FROM vadvicecase ac 
		INNER JOIN administration..TUser u WITH (NOLOCK) ON u.CRMContactId = AC.AdviserCRMContactId
		INNER JOIN TAdviceCaseStatus s WITH (NOLOCK) ON s.AdviceCaseStatusId = ac.StatusId AND s.IsComplete = 0 AND s.IsAutoClose = 0
	WHERE ((u.UserId = @Userid OR ac.ParaplannerUserId = @UserId OR ac.ServicingAdminUserId = @UserId) AND u.IndigoClientId = @TenantId)
	GROUP BY s.Descriptor
	ORDER BY s.Descriptor

END
GO


