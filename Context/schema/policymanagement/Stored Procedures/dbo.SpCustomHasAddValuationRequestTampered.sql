SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomHasAddValuationRequestTampered]
@PolicybusinessId BIGINT ,
@IndigoClientId BIGINT,
@_UserId BIGINT
AS

SET NOCOUNT ON 

    DECLARE @CRMContactId BIGINT

	SELECT
        @CRMContactId = t3.CRMContactId
		FROM 
			PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)                   
				Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId
				Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId AND  T3.PolicyOwnerId = 
							(SELECT TOP 1 PolicyOwnerId FROM policymanagement..TPolicyOwner WITH (NOLOCK) WHERE  PolicyDetailId =  T2.PolicyDetailId order by  PolicyOwnerId ASC)
		WHERE 
			t1.PolicyBusinessId = @PolicybusinessId

IF EXISTS (SELECT * FROM Administration..TUser WITH (NOLOCK) WHERE UserId = @_UserId  and (SuperUser = 1 OR SuperViewer = 1))
	SET @_UserId  = -1

IF EXISTS 
(
	SELECT
           T1.CRMContactId
    FROM 
           CRM..TCRMContact T1
           -- Secure clause
           LEFT JOIN CRM..VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId
           LEFT JOIN CRM..VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId
    WHERE 
           (T1.CRMContactId = @CRMContactId)
        AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))) 
)
	SELECT RequestTampered = 0
ELSE
	SELECT RequestTampered = 1


SET NOCOUNT OFF

RETURN (0)
GO
