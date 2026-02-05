SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_CustomDeleteKeysByUserIdAndRoleId](@nUserId bigint,@nRoleId bigint) AS

DELETE FROM Administration.dbo.TKey WHERE UserId = @nUserid AND RoleId = @nRoleId

SELECT 1
GO
