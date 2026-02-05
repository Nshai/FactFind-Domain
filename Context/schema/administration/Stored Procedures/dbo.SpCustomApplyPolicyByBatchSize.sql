CREATE   PROCEDURE [dbo].[SpCustomApplyPolicyByBatchSize]
	@PolicyId INT, 
	@MaxRowsPerKey INT = null
AS
BEGIN
/*
Extension to SpCustomApplyPolicy with additional features:
1. process records in batch if rows per policy over threshold
2. more logging for trouble-shot
3. use rigth datatype for @PolicyId  

Workflow:
APP_RebuildKeys (Job)
   --> SpCustomRebuildAllKeys 
      --> SpCustomApplyPolicyByBatchSize ( SHOULD BE ONLY CALLED BY SpCustomRebuildAllKeys)
         --> Is rows per RoleID > @MaxRowsPerKey (5,000,000)
           |--> No: SpCustomApplyPolicy @PolicyID  (trans per policy per tenant)
           |--> Yes: 
                |--> Get a List of UserID per RoleID (Loop )
                   |--> SpCustomApplyPolicy @PolicyID , @UserID (trans per userid per policy per tenant)
*/
-- Declarations
DECLARE @tx INT, @Sql nvarchar(4000), @Table varchar(256), @Propogate bit, @Sp varchar(64), @RoleId INT
DECLARE @NoOfKeys INT, @sqlCmd AS NVARCHAR(MAX),  @u_id INT,@SqlUserIDs NVARCHAR(MAX)='', @msg varchar(4000)  ;
DROP TABLE IF EXISTS #U;
CREATE TABLE #U(UserID INT)

SELECT @MaxRowsPerKey = ISNULL(@MaxRowsPerKey, 5000000)

BEGIN TRY

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

	IF (@@ROWCOUNT = 0) RETURN(0);

	-- If we're not propogating the keys then call a different SP
	IF @Propogate = 0 SELECT @Sp = @Sp + 'WithoutPropogation'

	/*Check if the rows per policy/role is bigger than @MaxRowsPerKey. If so, then need to break down to avoid TLog Full Error*/
	SELECT @sqlCmd = N'Select @NoOfKeys = COUNT(1) From '+@Table + 'Key WHERE RoleId = @RoleId '
	EXEC sp_executesql @sqlCmd, N'@RoleId INT, @NoOfKeys INT OUTPUT' ,@RoleId = @RoleId,  @NoOfKeys= @NoOfKeys OUTPUT;


	IF (@NoOfKeys < @MaxRowsPerKey ) 
	BEGIN
		-- Now update the policy record to indicate that it has been applied PER Policy

		-- Insert keys
		SET @Sql = N'DELETE FROM ' + @Table + 'Key WHERE RoleId = @RoleId AND CreatorId IS NOT NULL'
		SET @Sql = @Sql +
			N' INSERT INTO ' + @Table + 'Key (CreatorId, UserId, RightMask, AdvancedMask, RoleId)' +
			N' EXEC ' + @Sp + ' @PolicyId'

		SELECT @msg =  ( CONVERT(VARCHAR(19), GETDATE(), 121)) + ': PolicyID='+ cast(@PolicyId as varchar(100))  
		RAISERROR  (@msg , 0, 1 ) WITH NOWAIT 

		BEGIN TRANSACTION
			EXEC sp_executesql @Sql, N'@PolicyId INT, @RoleId INT', @PolicyId = @PolicyId, @RoleId = @RoleId
		COMMIT TRANSACTION
	END
	ELSE
	BEGIN
		SELECT @msg =  ( CONVERT(VARCHAR(19), GETDATE(), 121)) + ':  @NoOfKeys > @MaxRowsPerKey   @NoOfKeys ='+ cast(@NoOfKeys as varchar(100))+ ' @MaxRowsPerKey='+ cast(@MaxRowsPerKey as varchar(100))  
		RAISERROR  (@msg , 0, 1 ) WITH NOWAIT 

		SELECT @SqlUserIDs = N'INSERT INTO #U (UserID) SELECT DISTINCT UserId FROM ' + @Table + 'Key WHERE RoleId = @RoleId AND CreatorId IS NOT NULL;'
		EXEC sp_executesql @SqlUserIDs, N'@RoleId INT',   @RoleId = @RoleId 

		IF (@@ROWCOUNT > 0)
		BEGIN
			WHILE ( SELECT COUNT(1) FROM #U ) > 0
			BEGIN

				SELECT TOP (1 ) @u_id = UserID from #U ORDER BY UserID;

				SET @Sql = N'DELETE FROM ' + @Table + 'Key WHERE RoleId = @RoleId AND CreatorId IS NOT NULL'
				SET @Sql = @Sql + N' AND UserId = @UserId'

				IF EXISTS ( SELECT * FROM TUser WHERE UserId = @u_id AND Status NOT LIKE 'Access Denied%' )
				BEGIN
					/*If user status changed to access denied, then we will only do the delete. If still active, then re-populate right key mapping*/
					SET @Sql = @Sql +
						N' INSERT INTO ' + @Table + 'Key (CreatorId, UserId, RightMask, AdvancedMask, RoleId)' +
						N' EXEC ' + @Sp + ' @PolicyId, @UserId'
				END 

				SELECT @msg =  ( CONVERT(VARCHAR(19), GETDATE(), 121)) + ': PolicyID='+ cast(@PolicyId as varchar(100))+ ' UserId='+ cast(@u_id as varchar(100))  
				RAISERROR  (@msg , 0, 1 ) WITH NOWAIT 

				BEGIN TRANSACTION
					EXEC sp_executesql @Sql, N'@PolicyId INT, @RoleId INT, @UserId INT', @PolicyId = @PolicyId, @RoleId = @RoleId, @UserId = @u_id
				COMMIT TRANSACTION

				DELETE U FROM #U U WHERE UserID= @u_id;

			END
		END
	END


	UPDATE TPolicy SET Applied='yes' WHERE PolicyId=@PolicyId

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW 

END CATCH 

END

 
GO


