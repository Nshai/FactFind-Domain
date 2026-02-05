SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveMyRecentClients]
	@UserId BIGINT,
	@TopN INT = 10,
	@SearchType NVARCHAR(20) = 'clientsearch'
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @SuperUser BIT, @SuperViewer BIT

--Check if superuser / superviwer
SELECT @SuperUser = SuperUser, @SuperViewer = SuperViewer
FROM Administration..TUser WHERE UserId = @UserId

IF (@SuperUser = 1 or @SuperViewer = 1)
BEGIN
	SELECT TOP (@TopN)
		RecentItemId AS ClientId,
		ISNULL(CorporateName, '') + ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS ClientName,
		IIF(CorporateName IS NULL, SUBSTRING(ISNULL(FirstName, ''), 1, 1) + SUBSTRING(ISNULL(LastName, ''), 1, 1), NULL) AS ClientInitials,
		RefCRMContactStatusId AS CustomerType
	FROM
		TRecentNItem rni
		JOIN TRecentSearchAndReport rsar ON rsar.RecentSearchAndReportId = rni.RecentSearchAndReportId
		JOIN CRM..TCRMContact T1 ON T1.CRMContactId = rni.RecentItemId
	WHERE
		rsar.userid = @UserId
		AND rsar.controller = @SearchType
		AND rsar.action = 'index'
		AND ISNULL(T1.ArchiveFg, 0) = 0
    ORDER BY rni.LastUpdated DESC
END
ELSE
BEGIN
	SELECT TOP (@TopN)
		RecentItemId AS ClientId,
		ISNULL(CorporateName, '') + ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') AS ClientName,
		IIF(CorporateName IS NULL, SUBSTRING(ISNULL(FirstName, ''), 1, 1) + SUBSTRING(ISNULL(LastName, ''), 1, 1), NULL) AS ClientInitials,
		RefCRMContactStatusId AS CustomerType
	FROM
		TRecentNItem rni
		JOIN TRecentSearchAndReport rsar ON rsar.RecentSearchAndReportId = rni.RecentSearchAndReportId
		JOIN CRM..TCRMContact T1 ON T1.CRMContactId = rni.RecentItemId
		-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)
		LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId =  @UserId AND TCKey.CreatorId = T1._OwnerId
		LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = T1.CRMContactId
	WHERE
		rsar.userid = @UserId
		AND rsar.controller = @SearchType
		AND rsar.action = 'index'
		AND ISNULL(T1.ArchiveFg, 0) = 0
		AND ((T1._OwnerId = @UserId) OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))
    ORDER BY rni.LastUpdated DESC
END

GO
