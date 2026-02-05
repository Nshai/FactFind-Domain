SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[SpCustomRebuildAllKeys]
	@IndigoClientId INT, @BatchPerPolicy BIT = NULL,@MaxRowsPerKey INT = null
AS
BEGIN
SELECT @BatchPerPolicy = ISNULL(@BatchPerPolicy,0)
SELECT @MaxRowsPerKey = ISNULL(@MaxRowsPerKey, 5000000)

IF ((SELECT RebuildKeys FROM TRunning WHERE IndigoClientId=@IndigoClientId)=0)
BEGIN
	-- Lock this process
	UPDATE TRunning SET RebuildKeys=1 WHERE IndigoClientId=@IndigoClientId
	

	DECLARE @PolicyId bigint

	-- Build cursor for all roles and entities in the new user's 'stream' that require security keys to be built. 
	-- The called SP SpCustomApplyPolicy also checks if keys need to be built, however, checking here also will 
	-- ensure the nightly regeneration of keys does not do unnecessary work
	DECLARE CKeys CURSOR FOR SELECT P.PolicyId 
									FROM TPolicy P 
										JOIN TEntity E ON E.EntityId = P.EntityId
									WHERE P.Applied = 'yes' AND P.IndigoClientId = @IndigoClientId
	FOR READ ONLY
	
	OPEN CKeys
	 
	FETCH NEXT FROM CKeys INTO @PolicyId
	 
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	  -- Rebuild keys for each creator   
	  /* EXEC SpCustomApplyPolicy @PolicyId */
	  IF (@BatchPerPolicy =0) 
	  BEGIN 
		EXEC SpCustomApplyPolicy @PolicyId 
	  END 
	  ELSE
	  BEGIN
		EXEC SpCustomApplyPolicyByBatchSize @PolicyId=@PolicyId , @MaxRowsPerKey =@MaxRowsPerKey
	  END
 
	  FETCH NEXT FROM CKeys INTO @PolicyId
	END
	 
	CLOSE CKeys
	DEALLOCATE CKeys
	

	-- Unlock this process
	UPDATE TRunning SET RebuildKeys=0 WHERE IndigoClientId=@IndigoClientId
END

END
RETURN (0)

errh:

  -- Unlock this process
  UPDATE TRunning SET RebuildKeys=0 WHERE IndigoClientId=@IndigoClientId
  RETURN (100)
GO
