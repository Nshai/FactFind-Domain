SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomDeleteEntityKeysByUserIdAndRoleId]
	(
	@nUserId bigint,
	@nRoleId bigint
	)
AS

DELETE FROM CRM.dbo.TCRMContactKey WHERE (UserId = @nUserid OR CreatorId = @nUserid) AND RoleId = @nRoleId
DELETE FROM CRM.dbo.TLeadKey WHERE (UserId = @nUserid OR CreatorId = @nUserid) AND RoleId = @nRoleId
DELETE FROM CRM.dbo.TPractitionerKey WHERE (UserId = @nUserid OR CreatorId = @nUserid) AND RoleId = @nRoleId
DELETE FROM CRM.dbo.TAccountKey WHERE (UserId = @nUserid OR CreatorId = @nUserid) AND RoleId = @nRoleId

SELECT 1
GO
