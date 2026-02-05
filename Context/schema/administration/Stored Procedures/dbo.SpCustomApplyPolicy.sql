SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomApplyPolicy]
	@PolicyId bigint,
	@UserId bigint = null
AS
BEGIN
-- Declarations
DECLARE @tx int, @Sql nvarchar(4000), @Table varchar(256), @Propogate bit, @Sp varchar(64), @RoleId bigint

SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

-- Get information about the policies that require key generation. Although this SP is called from SpCustomRebuildAllKeys
-- which checks to see if key generation is required, this SP can also be called on its own from IO.
SELECT
	@Table = E.Db + '..T' + E.Identifier,
	@Propogate = P.Propogate,
	@RoleId = P.RoleId,
	@Sp = 'SpCustomApplyPolicyGetKeys'
FROM
	TPolicy P
	JOIN TEntity E ON P.EntityId = E.EntityId
WHERE
	P.PolicyId = @PolicyId

-- Check that we have a policy that requires key generation
IF (@@ROWCOUNT > 0)
BEGIN
	-- If we're not propogating the keys then call a different SP
	IF @Propogate = 0 SELECT @Sp = @Sp + 'WithoutPropogation'

	-- Insert keys
	SET @Sql =
		N'DELETE FROM ' + @Table + 'Key WHERE RoleId = @RoleId AND CreatorId IS NOT NULL'

	IF @UserId IS NOT NULL
		SET @Sql = @Sql + N' AND UserId = @UserId'

	SET @Sql = @Sql +
		N' INSERT INTO ' + @Table + 'Key (CreatorId, UserId, RightMask, AdvancedMask, RoleId)' +
		N' EXEC ' + @Sp + ' @PolicyId, @UserId'

	EXEC sp_executesql @Sql, N'@PolicyId bigint, @RoleId bigint, @UserId bigint', @PolicyId = @PolicyId, @RoleId = @RoleId, @UserId = @UserId

	-- Now update the policy record to indicate that it has been applied
	UPDATE TPolicy SET Applied='yes' WHERE PolicyId=@PolicyId
END

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
