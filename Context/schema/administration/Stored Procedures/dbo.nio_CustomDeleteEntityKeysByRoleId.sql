SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomDeleteEntityKeysByRoleId](@nRoleId bigint) AS

DELETE FROM CRM.dbo.TCRMContactKey WHERE RoleId = @nRoleId
DELETE FROM CRM.dbo.TLeadKey WHERE RoleId = @nRoleId
DELETE FROM CRM.dbo.TPractitionerKey WHERE RoleId = @nRoleId
DELETE FROM CRM.dbo.TAccountKey WHERE RoleId = @nRoleId

SELECT 1
GO
