SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomDeletePolicyByRoleId](@nRoleId bigint) AS

DELETE FROM Administration.dbo.TPolicy WHERE RoleId = @nRoleId

SELECT 1
GO
