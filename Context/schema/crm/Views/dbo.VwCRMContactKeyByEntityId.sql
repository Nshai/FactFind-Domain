SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =====================================================================================

Name : VwCRMContactKeyByEntityId

Date        Issue        Who     Description
----------  -----------  ---     -----------------------------
  ??			  ??		    ??	   Original version
05/07/2021   AIOSEC-211  W Webb  Addition of support for additional groups for users


===================================================================================== */
CREATE VIEW [dbo].[VwCRMContactKeyByEntityId]
AS
SELECT 
	EntityId,
	UserId, 
	MAX(RightMask) RightMask,
	MAX(AdvancedMask) AdvancedMask
FROM
	(	
	SELECT
		EntityId,
		UserId, 
		RightMask,
		AdvancedMask
	FROM 
		TCRMContactKey K With(NoLock)
	WHERE
		K.EntityId IS NOT NULL
		AND K.UserId IS NOT NULL
	
	UNION ALL

	SELECT
		K.EntityId,
		M.UserId, 
		K.RightMask,
		K.AdvancedMask
	FROM 
		TCRMContactKey K With(NoLock)
		JOIN TMembership M With(NoLock)  ON M.RoleId = K.RoleId
	WHERE
		K.EntityId IS NOT NULL
		AND K.RoleId IS NOT NULL

	UNION ALL
	-- Append the results from any additional groups a user may have (AIO project)
	-- And filter out the role policy where access mask is 0 deny
	-- This is the dynamic addition of keys as they are not part of the keygen process
	SELECT C.CrmContactId, UG.UserId, P.RightMask, P.AdvancedMask
	FROM Administration..TUserGroup UG
		JOIN CRM..TCrmContact C ON C.GroupId = UG.GroupId
		JOIN Administration..TPolicy P ON P.RoleId = UG.RoleId AND P.EntityId = 2 AND P.RightMask > 0 
	) AS Keys
GROUP BY
	UserId, EntityId

GO
