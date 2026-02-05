SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveVisiblePartiesCount]
@UserId bigint,
@IndigoClientId bigint,
@ClientId bigint = NULL,
@ServicingAdviserId bigint = NULL,
@GroupId bigint = NULL
AS

DECLARE @IsSuperUser TINYINT

SET @IsSuperUser = (
		SELECT SuperUser
		FROM Administration..TUser
		WHERE UserId = @UserId
		)

IF @IsSuperUser = 0
BEGIN
	SET @IsSuperUser = (
			SELECT SuperViewer
			FROM Administration..TUser
			WHERE UserId = @UserId
			)
END

CREATE TABLE #Advisers (
    Id INT
  )

  IF @GroupId IS NOT NULL
    INSERT INTO #Advisers
    SELECT Id
    FROM reports.dbo.FnCustomRetrieveAdvisersByGroup(@IndigoClientId, @GroupId)

SELECT COUNT(DISTINCT C.CRMContactId) AS VisibleParties
FROM CRM..TCRMContact C
JOIN PolicyManagement..TPolicyOwner O ON O.CRMContactId = C.CRMContactId
JOIN Reports..TAdviser A ON A.CRMContactId = C.CurrentAdviserCRMId -- Secure clause
LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.CreatorId = C._OwnerId
	AND TCKey.UserId = @UserId
LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.EntityId = C.CRMContactId
	AND TEKey.UserId = @UserId
WHERE C.IndClientId = @IndigoClientId
	AND C.ArchiveFg = 0
	AND (
		@IsSuperUser = 1
		OR (
			(
				C._OwnerId = @UserId
				OR (
					TCKey.CreatorId IS NOT NULL
					OR TEKey.EntityId IS NOT NULL
					)
				)
			)
		)
	AND (
            @ClientId IS NULL
              OR C.CRMContactId = @ClientId
            )
    AND (
            @ServicingAdviserId IS NULL
              OR A.PractitionerId = @ServicingAdviserId
            )
    AND (
            @GroupId IS NULL
              OR A.PractitionerId IN (SELECT Id FROM #Advisers)
            )   
GO
