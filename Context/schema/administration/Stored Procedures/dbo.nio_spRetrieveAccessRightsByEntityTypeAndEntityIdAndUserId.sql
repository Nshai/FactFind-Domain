SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spRetrieveAccessRightsByEntityTypeAndEntityIdAndUserId]
	@DatabaseName VARCHAR(20) = 'CRM',
	@DatabaseEntityTypeName VARCHAR(12),
	@EntityId BIGINT,
	@UserId BIGINT
AS
BEGIN
	DECLARE @AccessQuery NVARCHAR(4000)
	DECLARE @RightMask int 
	-- AdvancedMask is not returned to NIO as it is not currently used and may be factored out in future as it is very rarely used in LIO too
	-- it does need to be in this sp thought because it is a required parameter for SpCustomGetSuperUserRights 
	DECLARE @AdvancedMask int
	SELECT @RightMask = 1, @AdvancedMask = 0

	-- SuperUser and SuperViewer Rights
	IF EXISTS (SELECT 1 FROM TUser WHERE (SuperUser = 1) AND UserId = ABS(@UserId))
	BEGIN
		SELECT @RightMask = 15, @AdvancedMask = 240
	END
    -- Check if the User is a Super Viewer, If so, use the TPolicy entries.
	ELSE IF EXISTS (SELECT 1 FROM TUser WHERE (SuperViewer = 1) AND UserId = ABS(@UserId))
	BEGIN		
		-- Get rights directly from the Policy - if access is denied then default to View rights.
		SELECT 
			@RightMask = CASE RightMask WHEN 0 THEN 1 ELSE RightMask END,	
			@AdvancedMask = AdvancedMask
		FROM
			VwPolicyRights
		WHERE
			UserId = ABS(@UserId)
			AND Entity = @DatabaseEntityTypeName				
	END
	Else -- If User is neither super user nor super viewer, then No access.
	Begin
		SELECT @RightMask = 0, @AdvancedMask = 0
	End

	-- Non SuperViewer and Non SuperUser rights
	SELECT @AccessQuery = 
	'SELECT
		TRoot.CRMContactId AS EntityId,
		'+CONVERT(VARCHAR(20), @UserId)+' AS UserId,
		'''+@DatabaseEntityTypeName+''' AS DatabaseEntityTypeName,
		''CRMContact'' AS RootDatabaseEntityName,
		CASE TRoot._OwnerId 
		  WHEN '+CONVERT(VARCHAR(20), @UserId)+' THEN 15 
		  ELSE ISNULL(TCKey.RightMask, '+CONVERT(VARCHAR(20), @RightMask)+')|ISNULL(TEKey.RightMask, '+CONVERT(VARCHAR(20), @RightMask)+')
		END AS RightMask
	FROM
		CRM.dbo.TCRMContact TRoot
		LEFT JOIN '+@DatabaseName+'.dbo.Vw'+@DatabaseEntityTypeName+'KeyByCreatorId TCKey ON TCKey.UserId = '+CONVERT(VARCHAR(20), @UserId)+' AND TCKey.CreatorId = TRoot._OwnerId
		LEFT JOIN '+@DatabaseName+'.dbo.Vw'+@DatabaseEntityTypeName+'KeyByEntityId TEKey ON TEKey.UserId = '+CONVERT(VARCHAR(20), @UserId)+' AND TEKey.EntityId = TRoot.CRMContactId
	WHERE
		TRoot.CRMContactId = '+CONVERT(VARCHAR(20), @EntityId)

	EXEC(@AccessQuery)	
END
GO
