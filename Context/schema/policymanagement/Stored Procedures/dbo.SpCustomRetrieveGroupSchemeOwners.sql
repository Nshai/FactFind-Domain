SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveGroupSchemeOwners]
(
    @TenantId bigint,
    @UserId bigint,
    @CorporateName VARCHAR(255) = NULL
)
AS
    DECLARE @IsSuperUserOrSuperViewer BIT = 0
    
    SELECT @IsSuperUserOrSuperViewer = SuperUser | SuperViewer
    FROM Administration..TUser WHERE UserId = @UserId AND IndigoClientId = @TenantId;
    
    SELECT DISTINCT
        gs.OwnerCRMContactId As OwnerId, 
        c.CorporateName AS OwnerName
    FROM policymanagement..TGroupScheme gs
        INNER JOIN CRM..TCRMContact c ON c.CRMContactId = gs.OwnerCRMContactId AND c.IndClientId = gs.TenantId
        LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey With(NoLock) ON TCKey.UserId = @UserId AND TCKey.CreatorId = c._OwnerId
        LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey With(NoLock) ON TEKey.UserId = @UserId AND TEKey.EntityId = c.CRMContactId
    WHERE gs.TenantId = @TenantId
        AND (@CorporateName IS NULL OR c.CorporateName LIKE @CorporateName + '%')
        And (@IsSuperUserOrSuperViewer = 1 OR (c._OwnerId = @UserId Or TCKey.CreatorId Is Not Null OR TEKey.EntityId IS NOT NULL));

GO