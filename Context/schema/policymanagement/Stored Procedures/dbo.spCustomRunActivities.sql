SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomRunActivities]

@LifeCycleTransitionId BIGINT, 
@CRMContactId BIGINT, 
@PolicyBusinessId BIGINT, 
@IndigoClientId INT
AS

DECLARE @Count AS INT, 
@Counter AS INT, 
@ErrorMessage AS VARCHAR (MAX), 
@ActiveCount AS INT;
DECLARE @ActivityCategoryId AS BIGINT, 
@Name AS VARCHAR (200), 
@IsEntered AS BIGINT, 
@IsComplete AS BIGINT;
DECLARE @OrganiserActivityId AS BIGINT, 
@CheckOutcome AS INT, 
@OutcomeId AS BIGINT, 
@CheckDueDate AS INT, 
@DueDate AS DATE;
DECLARE @ExtraData AS VARCHAR (255);
DECLARE @FAILED AS BIT = 0;
DECLARE @ActivityCategory TABLE (
    AId                   BIGINT        IDENTITY (1, 1),
    ActivityCategoryId    BIGINT       ,
    LifeCycleTransitionId BIGINT       ,
    Name                  VARCHAR (200),
    CheckOutcome          INT          ,
    CheckDueDate          INT          );
    
/* Check Rule - Contact Level*/
INSERT INTO @ActivityCategory (ActivityCategoryId, LifeCycleTransitionId, Name, CheckOutcome, CheckDueDate)
SELECT A.ActivityCategoryId,
       A.LifeCycleTransitionId,
       B.Name,
       A.CheckOutcome,
       A.CheckDueDate
FROM   CRM..TActivityCategory2LifeCycleTransition AS A
       INNER JOIN
       CRM..TActivityCategory AS B
       ON A.ActivityCategoryId = B.ActivityCategoryId
WHERE  A.LifeCycleTransitionId = @LifeCycleTransitionId
       AND B.IndigoClientId = @IndigoClientId
       AND B.ClientRelatedFG = 1
       AND B.PlanRElatedFG = 0;
SELECT @Count = @@ROWCOUNT,
       @Counter = 1;
SELECT @ActiveCount = 1;
SELECT @ErrorMessage = ISNULL(@ErrorMessage, '');
WHILE @Counter <= @Count
    BEGIN
        SELECT @ActivityCategoryId = ActivityCategoryId,
               @Name = [Name],
               @CheckOutcome = CheckOutcome,
               @CheckDueDate = CheckDueDate
        FROM   @ActivityCategory
        WHERE  AId = @Counter;

		-- Reset values
		SELECT @OrganiserActivityId = NULL, @IsComplete = NULL, @DueDate = NULL, @OutcomeId = NULL

        SELECT TOP 1 @OrganiserActivityId = OrganiserActivityId,
                     @IsComplete = CompleteFG,
                     @DueDate = t.DueDate,
                     @OutcomeId = t.ActivityOutcomeId
        FROM   CRM..TOrganiserActivity AS oa
               JOIN CRM..TTask AS t ON oa.TaskId = t.TaskId
        WHERE  T.IndigoClientId = @IndigoClientId
			   AND ActivityCategoryId = @ActivityCategoryId
               AND oa.CRMContactId = @CRMContactId;

		-- If a task has not been found try to find a joint task
		IF @OrganiserActivityId IS NULL
			SELECT TOP 1 @OrganiserActivityId = OrganiserActivityId,
						 @IsComplete = CompleteFG,
						 @DueDate = t.DueDate,
						 @OutcomeId = t.ActivityOutcomeId
			FROM   CRM..TOrganiserActivity AS oa
				   JOIN CRM..TTask AS t ON oa.TaskId = t.TaskId
			WHERE  T.IndigoClientId = @IndigoClientId
				   AND ActivityCategoryId = @ActivityCategoryId
				   AND oa.JointCRMContactId = @CRMContactId
				   AND oa.IndigoClientId = @IndigoClientId;

        --reset    
        SET @FAILED = 0;
        SET @ExtraData = '';
        IF (@OrganiserActivityId IS NULL)
            BEGIN
                SET @FAILED = 1;
                SET @ExtraData = 'NOTEXISTS';
            END
        IF (@OrganiserActivityId IS NOT NULL)
            BEGIN
                SET @ExtraData = 'TASKEXISTS';
                IF (@IsComplete = 1)
                    BEGIN
                        SET @ExtraData = @ExtraData + '::COMPLETE';
                        IF (@CheckOutcome = 1)
                            BEGIN
                                IF (@OutcomeId IS NULL)
                                    BEGIN
                                        SET @FAILED = 1;
                                        SET @ExtraData = @ExtraData + '::NOOUTCOME';
                                    END
                            END
                    END
                ELSE
                    BEGIN
                        IF (@CheckDueDate = 0)
                            BEGIN
                                SET @FAILED = 1;
                                SET @ExtraData = @ExtraData + '::NOTCOMPLETE';
                            END
                        ELSE
                            IF (@CheckDueDate = 1
                                AND (@DueDate <= CAST (GETDATE() AS DATE)))
                                BEGIN
                                    SET @FAILED = 1;
                                    SET @ExtraData = @ExtraData + '::NOTCOMPLETE-DUEDATECHECKED';
                                END
                    END
            END
        IF ISNULL(@FAILED, 0) = 1
            BEGIN
                SELECT @ErrorMessage = @ErrorMessage + 'CLIENTACTIVITY_' + CONVERT (VARCHAR (30), ISNULL(@OrganiserActivityId, '0')) + '_' + @Name + '_' + @ExtraData + '##';
                SELECT @ActiveCount = @ActiveCount + 1;
            END
        SELECT @Counter = @Counter + 1;
    END

/* Check Rule - Plan Level*/    

SELECT @ActiveCount = 0;
DECLARE @ActivityCategoryPlan TABLE (
    AId                   BIGINT        IDENTITY (1, 1),
    ActivityCategoryId    BIGINT       ,
    LifeCycleTransitionId BIGINT       ,
    Name                  VARCHAR (200),
    CheckOutcome          INT          ,
    CheckDueDate          INT          );
    

INSERT INTO @ActivityCategoryPlan (ActivityCategoryId, LifeCycleTransitionId, Name, CheckOutcome, CheckDueDate)
SELECT A.ActivityCategoryId,
       A.LifeCycleTransitionId,
       B.Name,
       CheckOutcome,
       CheckDueDate
FROM   CRM..TActivityCategory2LifeCycleTransition AS A
       INNER JOIN
       CRM..TActivityCategory AS B
       ON A.ActivityCategoryId = B.ActivityCategoryId
WHERE  A.LifeCycleTransitionId = @LifeCycleTransitionId
       AND B.IndigoClientId = @IndigoClientId
       AND B.PlanRelatedFG = 1;
SELECT @Count = @@ROWCOUNT,
       @Counter = 1;
SELECT @ActiveCount = 1;
SELECT @ErrorMessage = ISNULL(@ErrorMessage, '');
WHILE @Counter <= @Count
    BEGIN
		
		--Reset variables prior to setting them. Not doing this was the cause of IO-6672 defect
		SET @ActivityCategoryId = NULL;
		SET @Name = NULL;
		SET @CheckOutcome = NULL;
		SET @CheckDueDate = NULL;
		SET @OrganiserActivityId = NULL;
		SET @IsComplete = NULL;
		SET @DueDate = NULL;
		SET @OutcomeId = NULL;
    
       
        SELECT @ActivityCategoryId = ActivityCategoryId,
               @Name = [Name],
               @CheckOutcome = CheckOutcome,
               @CheckDueDate = CheckDueDate
        FROM   @ActivityCategoryPlan
        WHERE  AId = @Counter;

        SELECT TOP 1 @OrganiserActivityId = OrganiserActivityId,
                     @IsComplete = CompleteFG,
                     @DueDate = t.DueDate,
                     @OutcomeId = t.ActivityOutcomeId
        FROM   CRM..TOrganiserActivity AS oa
               LEFT OUTER JOIN
               CRM..TTask AS t
               ON oa.TaskId = t.TaskId
        WHERE  T.IndigoClientId = @IndigoClientId
			   AND oa.ActivityCategoryId = @ActivityCategoryId
               AND oa.PolicyId = @PolicyBusinessId;
                       
        --reset    
        SET @FAILED = 0;
        SET @ExtraData = '';
        IF (@OrganiserActivityId IS NULL)
            BEGIN
                SET @FAILED = 1;
                SET @ExtraData = 'NOTEXISTS';
            END
        IF (@OrganiserActivityId IS NOT NULL)
            BEGIN
                SET @ExtraData = 'TASKEXISTS';
                IF (@IsComplete = 1)
                    BEGIN
                        SET @ExtraData = @ExtraData + '::COMPLETE';
                        IF (@CheckOutcome = 1)
                            BEGIN
                                IF (@OutcomeId IS NULL)
                                    BEGIN
                                        SET @FAILED = 1;
                                        SET @ExtraData = @ExtraData + '::NOOUTCOME';
                                    END
                            END
                    END
                ELSE
                    BEGIN
                        IF (@CheckDueDate = 0)
                            BEGIN
                                SET @FAILED = 1;
                                SET @ExtraData = @ExtraData + '::NOTCOMPLETE';
                            END
                        ELSE
                            IF (@CheckDueDate = 1
                                AND (@DueDate <= CAST (GETDATE() AS DATE)))
                                BEGIN
                                    SET @FAILED = 1;
                                    SET @ExtraData = @ExtraData + '::NOTCOMPLETE-DUEDATECHECKED';
                                END
                    END
            END
        IF ISNULL(@FAILED, 0) = 1
            BEGIN
                SELECT @ErrorMessage = @ErrorMessage + 'PLANACTIVITY_' + CONVERT (VARCHAR (30), ISNULL(@OrganiserActivityId, '0')) + '_' + @Name + '_' + @ExtraData + '##';
                SELECT @ActiveCount = @ActiveCount + 1;
            END
        SELECT @Counter = @Counter + 1;
    END

-- Checking Oppertunity Level Tasks. Checks are carried out only if the plan has any linked opportunities
IF EXISTS (SELECT 1 FROM crm..TOpportunityPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
BEGIN	

	DECLARE @OppertunityId bigint

	SELECT @ActiveCount = 0;
	DECLARE @ActivityCategoryOppertunity TABLE (
		AId                   BIGINT        IDENTITY (1, 1),
		ActivityCategoryId    BIGINT       ,
		LifeCycleTransitionId BIGINT       ,
		Name                  VARCHAR (200),
		CheckOutcome          INT          ,
		CheckDueDate          INT          );
	    
	INSERT INTO @ActivityCategoryOppertunity (ActivityCategoryId, LifeCycleTransitionId, Name, CheckOutcome, CheckDueDate)
	SELECT A.ActivityCategoryId,
		   A.LifeCycleTransitionId,
		   B.Name,
		   CheckOutcome,
		   CheckDueDate
	FROM   CRM..TActivityCategory2LifeCycleTransition AS A
		   INNER JOIN
		   CRM..TActivityCategory AS B
		   ON A.ActivityCategoryId = B.ActivityCategoryId
	WHERE  A.LifeCycleTransitionId = @LifeCycleTransitionId
		   AND B.IndigoClientId = @IndigoClientId
		   AND B.PlanRelatedFG = 0
		   AND B.OpportunityRelatedFG = 1;

	       
	SELECT @Count = @@ROWCOUNT,
		   @Counter = 1;
	SELECT @ActiveCount = 1;
	SELECT @ErrorMessage = ISNULL(@ErrorMessage, '');
	WHILE @Counter <= @Count
		BEGIN
		
			--Reset variables prior to setting them. Not doing this was the cause of IO-6672 defect
			SET @ActivityCategoryId = NULL;
			SET @Name = NULL;
			SET @CheckOutcome = NULL;
			SET @CheckDueDate = NULL;
			SET @OrganiserActivityId = NULL;
			SET @IsComplete = NULL;
			SET @DueDate = NULL;
			SET @OutcomeId = NULL;
			set @OppertunityId = null					
	    
			SELECT @ActivityCategoryId = ActivityCategoryId,
				   @Name = [Name],
				   @CheckOutcome = CheckOutcome,
				   @CheckDueDate = CheckDueDate
			FROM   @ActivityCategoryOppertunity
			WHERE  AId = @Counter;       
	        
	        
	        
			SELECT TOP 1 @OrganiserActivityId = OrganiserActivityId,
						 @IsComplete = CompleteFG,
						 @DueDate = t.DueDate,
						 @OutcomeId = t.ActivityOutcomeId,
						 @OppertunityId = PB.OpportunityId
			FROM crm..TOpportunityPolicyBusiness PB 
								INNER JOIN CRM..TOrganiserActivity OA ON PB.OpportunityId = OA.OpportunityId						
							LEFT OUTER JOIN CRM..TTask AS t  ON oa.TaskId = t.TaskId
			WHERE T.IndigoClientId = @IndigoClientId
							AND PB.PolicyBusinessId = @PolicyBusinessId
							and ActivityCategoryId = @ActivityCategoryId  
							AND oa.CRMContactId = @CRMContactId
			ORDER BY OrganiserActivityId 
			
			/*
				@OppertunityId is used by the UI to navigate to the Oppertunity related page.
				OppertunityId gets set on above query only if the Oppertunity has a task of correct type associated with it ( due to inner join with TOrganiserActivity).
				If there's an oppertunity linked to the plan exisits without required task,  @OppertunityId is set using the query below in order to facilitate navigation.
				At the moment IO allows a plan to be linked to only a one Oppertunity. Therefore selecting first restult should not be an issue.
			*/
			IF(@OppertunityId is null)
			BEGIN        
				SELECT TOP 1 @OppertunityId = OpportunityId 
				FROM crm..TOpportunityPolicyBusiness
				WHERE PolicyBusinessId = @PolicyBusinessId
			END
	        
	               
			--reset    
			SET @FAILED = 0;
			SET @ExtraData = '';        
	        
			IF (@OrganiserActivityId IS NULL)
				BEGIN				
					SET @FAILED = 1;
					SET @ExtraData = 'NOTEXISTS';
				END
			IF (@OrganiserActivityId IS NOT NULL)
				BEGIN
					SET @ExtraData = 'TASKEXISTS';
					IF (@IsComplete = 1)
						BEGIN
							SET @ExtraData = @ExtraData + '::COMPLETE';
							IF (@CheckOutcome = 1)
								BEGIN
									IF (@OutcomeId IS NULL)
										BEGIN
											SET @FAILED = 1;
											SET @ExtraData = @ExtraData + '::NOOUTCOME';
										END
								END
						END
					ELSE
						BEGIN
							IF (@CheckDueDate = 0)
								BEGIN
									SET @FAILED = 1;
									SET @ExtraData = @ExtraData + '::NOTCOMPLETE';
								END
							ELSE
								IF (@CheckDueDate = 1
									AND (@DueDate <= CAST (GETDATE() AS DATE)))
									BEGIN
										SET @FAILED = 1;
										SET @ExtraData = @ExtraData + '::NOTCOMPLETE-DUEDATECHECKED';
									END
						END
				END
			IF ISNULL(@FAILED, 0) = 1
				BEGIN
					SELECT @ErrorMessage = @ErrorMessage + 'OPPORTUNITYACTIVITY_' + CONVERT (VARCHAR (30), ISNULL(@OppertunityId, '0')) + '_' + @Name + '_' + @ExtraData + '##';
					SELECT @ActiveCount = @ActiveCount + 1;
				END
			SELECT @Counter = @Counter + 1;
		END
    
END    
    
SELECT ISNULL(@ErrorMessage, '') AS 'Result ';
GO
