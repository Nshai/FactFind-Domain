SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePlanLifeCycle]
   	@StatusId bigint,
   	@IndigoClientId bigint,
	@UserId bigint, 
	@Descriptor varchar(50),
	@PolicyBusinessId bigint
AS

DECLARE @PreQueueBehaviour varchar(100), @Exclude varchar(100)

SELECT @PreQueueBehaviour=PreQueueBehaviour FROM TLifeCycle Where [Descriptor]=@Descriptor AND IndigoClientId = @IndigoClientId

IF @PreQueueBehaviour = 'Send all cases'
  Select @Exclude = 'Non-Compliance'
IF @PreQueueBehaviour = 'Use adviser/product profile'
  Select @Exclude = 'Non-Compliance'
IF @PreQueueBehaviour = 'Do not send'
  BEGIN
     IF (Select Count(*) From TPolicyBusiness A INNER JOIN TStatusHistory B ON A.PolicyBusinessId = B.PolicyBusinessId INNER JOIN TStatus C ON C.StatusId = B.StatusID WHERE B.CurrentStatusFg = 1 AND C.IntelligentOfficeStatusType = 'Submitted To T and C' AND A.PolicyBusinessId = @PolicyBusinessId) = 0
         Select @Exclude = 'Compliance'
     ELSE
         Select @Exclude = 'Non-Compliance'
  END

IF @PreQueueBehaviour = 'N/A' OR ISNULL(@PreQueueBehaviour,'') = ''
  Select @Exclude = '%'

BEGIN
  SELECT DISTINCT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusId AS [Status!1!StatusId], 
    T1.Name AS [Status!1!Name], 
    T1.OrigoStatusId AS [Status!1!OrigoStatusId], 
    T1.IntelligentOfficeStatusType AS [Status!1!IntelligentOfficeStatusType], 
    T1.PreComplianceCheck AS [Status!1!PreComplianceCheck], 
    T1.PostComplianceCheck AS [Status!1!PostComplianceCheck], 
    T1.IndigoClientId AS [Status!1!IndigoClientId], 
    T1.ConcurrencyId AS [Status!1!ConcurrencyId], 
    NULL AS [LifeCycle!2!LifeCycleStepId], 
    NULL AS [LifeCycle!2!StatusId], 
    NULL AS [LifeCycle!2!LifeCycleId], 
    NULL AS [LifeCycle!2!ConcurrencyId], 
    NULL AS [LifeCycleTransition!4!LifeCycleTransitionId], 
    NULL AS [LifeCycleTransition!4!LifeCycleStepId], 
    NULL AS [LifeCycleTransition!4!ToLifeCycleStepId], 
    NULL AS [LifeCycleTransition!4!OrderNumber], 
    NULL AS [LifeCycleTransition!4!Type], 
    NULL AS [LifeCycleTransition!4!HideStep], 
    NULL AS [LifeCycleTransition!4!AddToCommissionsFg], 
    NULL AS [LifeCycleTransition!4!ConcurrencyId], 
    NULL AS [NextLifeCycleStep!5!LifeCycleStepId], 
    NULL AS [NextLifeCycleStep!5!StatusId], 
    NULL AS [NextLifeCycleStep!5!LifeCycleId], 
    NULL AS [NextLifeCycleStep!5!ConcurrencyId], 
    NULL AS [NextStatus!6!NextStatusId], 
    NULL AS [NextStatus!6!Name],     
    NULL AS [NextStatus!6!IntelligentOfficeStatusType], 
    NULL AS [NextStatus!6!IndigoClientId], 
    NULL AS [NextStatus!6!ConcurrencyId], 
    NULL AS [StatusReason!7!StatusReasonId], 
    NULL AS [StatusReason!7!Name], 
    NULL AS [StatusReason!7!StatusId], 
    NULL AS [StatusReason!7!OrigoStatusId], 
    NULL AS [StatusReason!7!IntelligentOfficeStatusType], 
    NULL AS [StatusReason!7!IndigoClientId], 
    NULL AS [StatusReason!7!ConcurrencyId]
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    2 AS Tag,
    1 AS Parent,
    T1.StatusId, 
    T1.Name, 
    T1.OrigoStatusId, 
    T1.IntelligentOfficeStatusType, 
    T1.PreComplianceCheck, 
    T1.PostComplianceCheck, 
    T1.IndigoClientId, 
    T1.ConcurrencyId, 
    T2.LifeCycleStepId, 
    T2.StatusId, 
    T2.LifeCycleId, 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    4 AS Tag,
    2 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    T4.LifeCycleStepId, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    T4.Type, 
    T4.HideStep, 
    T4.AddToCommissionsFg, 
    T4.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    5 AS Tag,
    4 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    T4.LifeCycleStepId, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    T4.Type, 
    T4.HideStep, 
    T4.AddToCommissionsFg, 
    T4.ConcurrencyId, 
    T5.LifeCycleStepId, 
    T5.StatusId, 
    T5.LifeCycleId, 
    T5.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    6 AS Tag,
    5 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    NULL, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T5.LifeCycleStepId, 
    T5.StatusId, 
    T5.LifeCycleId, 
    T5.ConcurrencyId, 
    T6.StatusId, 
    T6.Name, 
    T6.IntelligentOfficeStatusType, 
    T6.IndigoClientId, 
    T6.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude


  UNION ALL

  SELECT DISTINCT
    7 AS Tag,
    6 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    NULL, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T5.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T6.StatusId, 
    T6.Name, 
    T6.IntelligentOfficeStatusType, 
    T6.IndigoClientId, 
    T6.ConcurrencyId, 
    T7.StatusReasonId, 
    T7.Name, 
    T7.StatusId, 
    T7.OrigoStatusId, 
    T7.IntelligentOfficeStatusType, 
    T7.IndigoClientId, 
    T7.ConcurrencyId
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN TStatus T6 ON T6.StatusId 	= T5.StatusId 
	JOIN TStatusReason T7 ON T7.StatusId = T6.StatusID 
	JOIN TStatusReasonRole StatusReasonRole ON StatusReasonRole.StatusReasonId = T7.StatusReasonId  
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

--*******************************************************************************************************************************
--
--*******************************************************************************************************************************
UNION

  SELECT DISTINCT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusId AS [Status!1!StatusId], 
    T1.Name AS [Status!1!Name], 
    T1.OrigoStatusId AS [Status!1!OrigoStatusId], 
    T1.IntelligentOfficeStatusType AS [Status!1!IntelligentOfficeStatusType], 
    T1.PreComplianceCheck AS [Status!1!PreComplianceCheck], 
    T1.PostComplianceCheck AS [Status!1!PostComplianceCheck], 
    T1.IndigoClientId AS [Status!1!IndigoClientId], 
    T1.ConcurrencyId AS [Status!1!ConcurrencyId], 
    NULL AS [LifeCycle!2!LifeCycleStepId], 
    NULL AS [LifeCycle!2!StatusId], 
    NULL AS [LifeCycle!2!LifeCycleId], 
    NULL AS [LifeCycle!2!ConcurrencyId], 
    NULL AS [LifeCycleTransition!4!LifeCycleTransitionId], 
    NULL AS [LifeCycleTransition!4!LifeCycleStepId], 
    NULL AS [LifeCycleTransition!4!ToLifeCycleStepId], 
    NULL AS [LifeCycleTransition!4!OrderNumber], 
    NULL AS [LifeCycleTransition!4!Type], 
    NULL AS [LifeCycleTransition!4!HideStep], 
    NULL AS [LifeCycleTransition!4!AddToCommissionsFg], 
    NULL AS [LifeCycleTransition!4!ConcurrencyId], 
    NULL AS [NextLifeCycleStep!5!LifeCycleStepId], 
    NULL AS [NextLifeCycleStep!5!StatusId], 
    NULL AS [NextLifeCycleStep!5!LifeCycleId], 
    NULL AS [NextLifeCycleStep!5!ConcurrencyId], 
    NULL AS [NextStatus!6!NextStatusId], 
    NULL AS [NextStatus!6!Name],     
    NULL AS [NextStatus!6!IntelligentOfficeStatusType], 
    NULL AS [NextStatus!6!IndigoClientId], 
    NULL AS [NextStatus!6!ConcurrencyId], 
    NULL AS [StatusReason!7!StatusReasonId], 
    NULL AS [StatusReason!7!Name], 
    NULL AS [StatusReason!7!StatusId], 
    NULL AS [StatusReason!7!OrigoStatusId], 
    NULL AS [StatusReason!7!IntelligentOfficeStatusType], 
    NULL AS [StatusReason!7!IndigoClientId], 
    NULL AS [StatusReason!7!ConcurrencyId]
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN 
	(
		SELECT * FROM TStatus Where StatusId NOT IN (SELECT StatusId FROM TStatusReason)
	) T6 ON T6.StatusId = T5.StatusId 
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION 

  SELECT DISTINCT
    2 AS Tag,
    1 AS Parent,
    T1.StatusId, 
    T1.Name, 
    T1.OrigoStatusId, 
    T1.IntelligentOfficeStatusType, 
    T1.PreComplianceCheck, 
    T1.PostComplianceCheck, 
    T1.IndigoClientId, 
    T1.ConcurrencyId, 
    T2.LifeCycleStepId, 
    T2.StatusId, 
    T2.LifeCycleId, 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN 
	(
		SELECT * FROM TStatus Where StatusId NOT IN (SELECT StatusId FROM TStatusReason)
	) T6 ON T6.StatusId = T5.StatusId 
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    4 AS Tag,
    2 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    T4.LifeCycleStepId, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    T4.Type, 
    T4.HideStep, 
    T4.AddToCommissionsFg, 
    T4.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN 
	(
		SELECT * FROM TStatus Where StatusId NOT IN (SELECT StatusId FROM TStatusReason)
	) T6 ON T6.StatusId = T5.StatusId 
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    5 AS Tag,
    4 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    T4.LifeCycleStepId, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    T4.Type, 
    T4.HideStep, 
    T4.AddToCommissionsFg, 
    T4.ConcurrencyId, 
    T5.LifeCycleStepId, 
    T5.StatusId, 
    T5.LifeCycleId, 
    T5.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN 
	(
		SELECT * FROM TStatus Where StatusId NOT IN (SELECT StatusId FROM TStatusReason)
	) T6 ON T6.StatusId = T5.StatusId 

WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

  UNION ALL

  SELECT DISTINCT
    6 AS Tag,
    5 AS Parent,
    T1.StatusId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T2.LifeCycleStepId, 
    NULL, 
    NULL, 
    NULL, 
    T4.LifeCycleTransitionId, 
    NULL, 
    T4.ToLifeCycleStepId, 
    T4.OrderNumber, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T5.LifeCycleStepId, 
    T5.StatusId, 
    T5.LifeCycleId, 
    T5.ConcurrencyId, 
    T6.StatusId, 
    T6.Name, 
    T6.IntelligentOfficeStatusType, 
    T6.IndigoClientId, 
    T6.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM   
	TStatus T1
	JOIN TLifeCycleStep T2 ON T2.StatusID = T1.StatusId 
	JOIN TLifeCycle T3 ON T3.LifeCycleId = T2.LifeCycleId AND T3.[Descriptor]=@Descriptor
	JOIN TPolicyBusiness PolicyBusiness ON PolicyBusiness.LifeCycleId = T3.LifeCycleId AND PolicyBusiness.PolicyBusinessId = @PolicyBusinessId
 	JOIN TLifeCycleTransition T4 ON T4.LifeCycleStepId = T2.LifeCycleStepId 
	JOIN TTransitionRole TransitionRole ON TransitionRole.LifeCycleTransitionId = T4.LifeCycleTransitionId 
    JOIN [Administration].[dbo].[TMembership] TransitionRoleMembership ON TransitionRoleMembership.RoleId = TransitionRole.RoleId AND TransitionRoleMembership.UserId = @UserId
 	JOIN TLifeCycleStep T5 ON T5.LifeCycleStepId = T4.ToLifeCycleStepId 
	JOIN 
	(
		SELECT * FROM TStatus Where StatusId NOT IN (SELECT StatusId FROM TStatusReason)
	) T6 ON T6.StatusId = T5.StatusId 
WHERE  
	T1.StatusId = @StatusId 
	and T1.IndigoClientId = @IndigoClientId 
	AND ISNULL(T4.Type,'') <> @Exclude

ORDER BY 
	[Status!1!StatusId], [LifeCycle!2!LifeCycleStepId], [LifeCycleTransition!4!OrderNumber], [LifeCycleTransition!4!LifeCycleTransitionId], [NextLifeCycleStep!5!LifeCycleStepId], [NextStatus!6!NextStatusId], [StatusReason!7!StatusReasonId]

FOR XML EXPLICIT

END
RETURN (0)


GO
