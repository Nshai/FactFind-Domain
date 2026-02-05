SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAvailableStatusChangesForPolicyBusiness]
	@IndigoClientId bigint,
	@PolicyBusinessId bigint,
	@UserId bigint
AS
DECLARE @LifeCycleId bigint, @StatusId bigint, @CurrentStatus varchar(255), @PreQueueBehaviour varchar(100), @Exclude varchar(100)

SELECT @LifeCycleId = LifeCycleId FROM PolicyManagement..TPolicyBusiness A WHERE A.PolicyBusinessId = @PolicyBusinessId
SELECT @StatusId = StatusId FROM PolicyManagement..TStatusHistory WHERE PolicyBusinessId = @PolicyBusinessId AND CurrentStatusFg = 1
SELECT @CurrentStatus = IntelligentOfficeStatusType FROM PolicyManagement..TStatus WHERE [StatusId] = @StatusId
SELECT @PreQueueBehaviour = PreQueueBehaviour FROM PolicyManagement..TLifeCycle WHERE LifeCycleId = @LifeCycleId

IF ISNULL(@PreQueueBehaviour, 'N/A') = 'N/A' 
	SELECT @Exclude = '%'
ELSE IF @PreQueueBehaviour = 'Do not send' BEGIN  
     IF @CurrentStatus != 'Submitted To T and C'
         SELECT @Exclude = 'Compliance'  
     ELSE  
         SELECT @Exclude = 'Non-Compliance'  
END  
ELSE
	SELECT @Exclude = 'Non-Compliance'
  
SELECT DISTINCT -- distinct in case user has several roles
	NextStatus.StatusId As NextStatusId,   
	NextStatus.Name,   
	NextStatus.IntelligentOfficeStatusType,   
	NextStatus.IndigoClientId,   
	NextStatus.ConcurrencyId 
FROM   
	PolicyManagement..TLifeCycle LC 
	JOIN PolicyManagement..TLifeCycleStep LCS ON LCS.LifeCycleId = LC.LifeCycleId
	JOIN PolicyManagement..TLifeCycleTransition LifeCycleTransition ON LifeCycleTransition.LifeCycleStepId = LCS.LifeCycleStepId
	JOIN PolicyManagement..TLifeCycleStep NextLifeCycleStep ON NextLifeCycleStep.LifeCycleStepId = LifeCycleTransition.ToLifeCycleStepId   
	JOIN PolicyManagement..TStatus NextStatus ON NextStatus.StatusId  = NextLifeCycleStep.StatusId
	JOIN PolicyManagement..TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = LifeCycleTransition.LifeCycleTransitionId   
	JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId
WHERE  
	LC.LifeCycleId = @LifeCycleId
	AND LC.IndigoClientId = @IndigoClientId 	
	AND LCS.StatusId = @StatusId
	AND TransitionRoleMembership.UserId = @UserId
	AND ISNULL(LifeCycleTransition.[Type], '') <> @Exclude
GO
