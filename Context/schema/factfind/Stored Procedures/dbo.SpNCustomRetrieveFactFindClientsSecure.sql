SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFactFindClientsSecure]
	@FactFindId int,
	@TenantId int,
	@UserId int
AS
DECLARE @CRMContactId1 int, @CRMContactId2 int, @IsSuperUser bit
	
SELECT  @CRMContactId1 = CRMContactId1, @CRMContactId2 = CRMContactId2
FROM TFactFind
WHERE FactFindId = @FactFindId AND IndigoClientId = @TenantId

IF @CRMContactId1 IS NULL
	THROW 51000, 'Fact Find could not be found.', 1;

SELECT @IsSuperUser = SuperUser | SuperViewer
FROM Administration..TUser
WHERE UserId = @UserId AND IndigoClientId = @TenantId

IF @IsSuperUser IS NULL
	THROW 51000, 'User could not be found.', 1;

IF @IsSuperUser = 1
	SELECT 
		@CRMContactId1 AS CRMContactId1, 

		(select FirstName + ' ' + LastName from CRM..TCRMContact where CRMContactId = @CRMContactId1 and IndClientId = @TenantId) as Client1FullName,
		@CRMContactId2 AS CRMContactId2,
		(select FirstName + ' ' + LastName from CRM..TCRMContact where CRMContactId = @CRMContactId2 and IndClientId = @TenantId) as Client2FullName

ELSE
	SELECT 
		@CRMContactId1 AS CRMContactId1, 
		(C.FirstName + ' ' + C.LastName) AS Client1FullName,
		@CRMContactId2 AS CRMContactId2,
		(select FirstName + ' ' + LastName from CRM..TCRMContact where CRMContactId = @CRMContactId2 and IndClientId = @TenantId) as Client2FullName
	FROM 
		CRM..TCRMContact C
		LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = C._OwnerId
		LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = C.CRMContactId
	WHERE
		CRMContactId = @CRMContactId1
		AND (C._OwnerId = @UserId OR TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)
GO
