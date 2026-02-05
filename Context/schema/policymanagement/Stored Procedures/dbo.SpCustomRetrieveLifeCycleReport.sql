SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE SpCustomRetrieveLifeCycleReport
@LifeCycleId bigint

AS

	select 
	1 AS tag, 
	NULL AS parent, 
	H.LifeCycleId AS [LifeCycle!1!LifeCycleId], 
	H.Name AS [LifeCycle!1!LifeCycleName], 
	NULL AS [LifeCycleTransition!2!LifeCycleTransitionid], 
	NULL AS [LifeCycleTransition!2!OrderNumber], 
	NULL AS [LifeCycleTransition!2!Type], 
	NULL AS [LifeCycleTransition!2!FromStatus], 
	NULL AS [LifeCycleTransition!2!ToStatus], 
	NULL AS [Role!3!Identifier],
	NULL AS [TransitionRule!4!TransitionRuleId], 
	NULL AS [TransitionRule!4!RuleDescription], 
	NULL AS [ActivityCategory!5!ActivityCategoryId],
	NULL AS [ActivityCategory!5!ActivityCategoryName]
	from TLifeCycleStep A
	JOIN TLifeCycleTransition B ON A.LifeCycleStepId = B.LifeCycleStepId 
	JOIN TLifeCycleStep C ON C.LifeCycleStepId = B.ToLifeCycleStepId
	JOIN TStatus D ON D.StatusId = A.StatusId
	JOIN TStatus E ON E.StatusId = C.StatusId
	JOIN TTransitionRole F ON F.LifeCycleTransitionId = b.LifeCycleTransitionId
	JOIN Administration..TRole G ON f.RoleId = G.RoleId
	JOIN TLifeCycle H ON h.LifeCycleId = A.LifeCycleId
	Where H.LifeCycleId =  @LifeCycleId
	
	UNION
	select 
	2 AS tag, 
	1 AS parent, 
	H.lifeCycleId, 
	H.Name, 
	B.LifeCycleTransitionId, 
	isNULL(B.OrderNumber, ''), 
	isNULL(B.Type,'n/a'), 
	D.Name, 
	E.Name, 
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
	from TLifeCycleStep A
	JOIN TLifeCycleTransition B ON A.LifeCycleStepId = B.LifeCycleStepId
	JOIN TLifeCycleStep C ON C.LifeCycleStepId = B.ToLifeCycleStepId
	JOIN TStatus D ON D.StatusId = A.StatusId
	JOIN TStatus E ON E.StatusId = C.StatusId
	JOIN TTransitionRole F ON F.LifeCycleTransitionId = b.LifeCycleTransitionId
	JOIN Administration..TRole G ON f.RoleId = G.RoleId
	JOIN TLifeCycle H ON h.LifeCycleId = A.LifeCycleId
	Where H.LifeCycleId =  @LifeCycleId
	
	UNION
	select 
	3 AS tag,
	2 AS parent,
	H.lifeCycleId,
	H.Name,
	B.LifeCycleTransitionId,
	NULL, 
	NULL,
	NULL,
	NULL,
	G.Identifier,
	NULL,
	NULL,
	NULL,
	NULL
	from TLifeCycleStep A
	JOIN TLifeCycleTransition B ON A.LifeCycleStepId = B.LifeCycleStepId
	JOIN TLifeCycleStep C ON C.LifeCycleStepId = B.ToLifeCycleStepId
	JOIN TStatus D ON D.StatusId = A.StatusId
	JOIN TStatus E ON E.StatusId = C.StatusId
	JOIN TTransitionRole F ON F.LifeCycleTransitionId = b.LifeCycleTransitionId
	JOIN Administration..TRole G ON f.RoleId = G.RoleId
	JOIN TLifeCycle H ON h.LifeCycleId = A.LifeCycleId
	Where H.LifeCycleId =  @LifeCycleId
	
	UNION
	
	select 
	4 AS tag, 
	2 AS parent, 
	H.LifeCycleId, 
	H.Name, 
	B.LifeCycleTransitionId, 
	NULL, 
	NULL,
	NULL,
	NULL,
	NULL,
	r.LifeCycleTransitionRuleId,
	r.Description,
	NULL,
	NULL
	from TLifeCycleStep A
	JOIN TLifeCycleTransition B ON A.LifeCycleStepId = B.LifeCycleStepId
	JOIN TLifeCycleStep C ON C.LifeCycleStepId = B.ToLifeCycleStepId
	JOIN TStatus D ON D.StatusId = A.StatusId 
	JOIN TStatus E ON E.StatusId = C.StatusId
	JOIN TLifeCycle H ON h.LifeCycleId = A.LifeCycleId
	JOIN TLifeCycleTransitionToLifeCycleTransitionRule t on t.LifeCycleTransitionId = b.LifeCycleTransitionId
	JOIN TLifeCycleTransitionRule r on r.LifeCycleTransitionRuleId = t.LifeCycleTransitionRuleId
	Where H.LifeCycleId = @LifeCycleId
	
	UNION
	
	select 
	5 AS tag, 
	2 AS parent, 
	H.LifeCycleId, 
	H.Name, 
	B.LifeCycleTransitionId, 
	NULL, 
	NULL,
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	NULL, 
	J.ActivityCategoryId, 
	K.Name
	from TLifeCycleStep A
	JOIN TLifeCycleTransition B ON A.LifeCycleStepId = B.LifeCycleStepId
	JOIN TLifeCycleStep C ON C.LifeCycleStepId = B.ToLifeCycleStepId
	JOIN TLifeCycle H ON h.LifeCycleId = A.LifeCycleId
	JOIN crm..tactivitycategory2lifecycletransition J on J.LifeCycleTransitionId = b.LifeCycleTransitionId
	JOIN crm..tactivitycategory K ON K.ActivityCategoryId = J.ActivityCategoryId
	Where H.LifeCycleId =  @LifeCycleId

	ORDER BY [LifeCycle!1!LifeCycleId], [LifeCycleTransition!2!LifeCycleTransitionId], [Role!3!Identifier]
	
	FOR XML EXPLICIT