SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomTransitionRuleRun]
   @LifecycleTransitionId bigint,
   @PolicyBusinessId bigint,
   @RunAllRules bit = 0,
   @CurrentDate date = null
AS


DECLARE @TenantId Bigint,
	@Count int, 
	@Counter int, 
	@SpName nvarchar(128), 
	@ResponseLocal varchar(Max) ,
	@ErrorCounter int, 
	@ResponseMessage varchar(Max), 
	@RunLifeCycleTransitionRuleId bigint, 
	@Code varchar(50)

DECLARE @Rules TABLE (MId bigint IDENTITY(1,1), Code varchar(50), SpName nvarchar(128),LifeCycleTransitionRuleId bigint, RowNumber int)

Set @TenantId = (Select MAX(IndigoClientId) from policymanagement..TPolicyBusiness Where PolicyBusinessId = @PolicyBusinessId)

/* Read stored procedure names INTO @Rule Variable */
INSERT INTO @Rules (Code, SpName, LifeCycleTransitionRuleId) 
SELECT B.Code, B.SpName, B.LifeCycleTransitionRuleId 
--FROM TTransitionRule 
FROM TLifeCycleTransitionToLifeCycleTransitionRule A
Inner join TLifeCycleTransitionRule B ON A.LifeCycleTransitionRuleId = B.LifeCycleTransitionRuleId
WHERE A.LifeCycleTransitionId = @LifecycleTransitionId
AND (B.TenantId IS NULL OR B.TenantId = @TenantId)

--Clear the cache if run all rules
IF @RunAllRules = 1
BEGIN

	DELETE FROM TlifeCycleTransitionRuleCache WHERE PolicyBusinessId = @PolicyBusinessId AND LifeCycleTransitionId = @LifecycleTransitionId
	
END
ELSE
BEGIN

	--Remove items from cache that are olde than 5 minutes
	DELETE FROM TlifeCycleTransitionRuleCache WHERE PolicyBusinessId = @PolicyBusinessId AND LifeCycleTransitionId = @LifecycleTransitionId
	AND [TimeOut] <= DATEADD(MINUTE, -5, GETDATE())

	--Delete Rules to run if they are already cached as successfull i nthe last 5 minutes
	DELETE FROM @Rules Where LifeCycleTransitionRuleId IN 
	( 
		Select LifeCycleTransitionRuleId FROM TLifeCycleTransitionRuleCache WHERE PolicyBusinessId = @PolicyBusinessId AND LifeCycleTransitionId = @LifecycleTransitionId
		AND [TimeOut] > DATEADD(MINUTE, -5, GETDATE())
	)
		
END



-- are we moving to Deleted? if so there is an extra sp to run (hackety hack!)
DECLARE @TargetStatus varchar(255)
SET @TargetStatus = (
	SELECT s.IntelligentOfficeStatusType
	FROM TLifeCycleTransition lct
	JOIN TLifeCycleStep lcs ON lcs.LifeCycleStepId = lct.ToLifeCycleStepId
	JOIN TStatus s ON s.StatusId = lcs.StatusId
	WHERE lct.LifeCycleTransitionId = @LifecycleTransitionId
)

IF @TargetStatus = 'Deleted'
BEGIN
	INSERT INTO @Rules (Code, SpName, LifeCycleTransitionRuleId)
	VALUES ('ACTIVETOPUPS', 'spCustomTransitionRule_CheckForActiveTopUps', 9999999)
END	


--renumber the rows (IMPORTANT)
SET @Count = 0
UPDATE @rules
SET @Count = RowNumber = @Count + 1
  


-- *******************************************************
-- *******************************************************
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- *******************************************************
-- *******************************************************



SELECT @Count = (SELECT Count(*) from @Rules)
SELECT @Counter = 1
SELECT @ErrorCounter = 1

/* Execute each SP in table */
WHILE @Counter <= @Count 
  BEGIN
     SELECT @Code = Code, @SpName = spName,  @RunLifeCycleTransitionRuleId = LifeCycleTransitionRuleId 
     From @Rules Where RowNumber  = @Counter

     IF(@Code = 'EMPLOYMENTSTATUS')
       EXECUTE @SpName @PolicyBusinessId, @CurrentDate, @ResponseLocal OUTPUT
     ELSE
       EXECUTE @SpName @PolicyBusinessId, @ResponseLocal OUTPUT 

     IF (ISNULL(@ResponseLocal,'') != '')
     BEGIN
		
         SELECT @ResponseMessage = ISNULL(@ResponseMessage,'') +  @Code + '_' + ISNULL(@ResponseLocal,'') + '##'
  
       SELECT @ResponseLocal = ''
       SELECT @ErrorCounter = @ErrorCounter + 1
     END
     ELSE IF (ISNULL(@ResponseLocal,'') = '') AND @RunAllRules = 0 -- add successful rules to 5 minute cache
     BEGIN
		
		DELETE FROM TlifeCycleTransitionRuleCache 
		WHERE PolicyBusinessId = @PolicyBusinessId AND LifecycleTransitionId = @LifecycleTransitionId AND LifeCycleTransitionRuleId  = @RunLifeCycleTransitionRuleId
		
		INSERT INTO TlifeCycleTransitionRuleCache
		SELECT @PolicyBusinessId, @LifecycleTransitionId, @RunLifeCycleTransitionRuleId, GETDATE()
		
     END
     
     
     SELECT @Counter = @Counter + 1
   END
   
  SELECT 'Result ' = @ResponseMessage



GO
