SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveCurrentTransition]
@PolicyBusinessId bigint,
@FromStatusId bigint,
@ToStatusId bigint

AS

BEGIN

	SELECT 
	1 as tag,
	null as parent,
	lct.LifeCycleTransitionId as [LifeCycleTransition!1!LifeCycleTransitionId],
	lct.LifeCycleStepId as [LifeCycleTransition!1!LifeCycleStepId],
	lct.ToLifeCycleStepId as [LifeCycleTransition!1!ToLifeCycleStepId],
	lct.OrderNumber as [LifeCycleTransition!1!OrderNumber],
	lct.Type as [LifeCycleTransition!1!Type],
	lct.AddToCommissionsFg AS [LifeCycleTransition!1!AddToCommissionsFg]

	from TPolicyBusiness pb
	JOIN TLifeCycle lc ON pb.LifeCycleId = lc.LifeCycleId
	JOIN TLifeCycleStep lsFrom ON lsFrom.LifeCycleId = lc.LifeCycleId
	JOIN TLifeCycleTransition lct ON lct.LifeCycleStepId = lsFrom.LifeCycleStepId
	JOIN TLifeCycleStep lsTo ON lsTo.LifeCycleStepId = lct.ToLifeCycleStepId
	WHERE PolicyBusinessId = @PolicyBusinessId
	AND lsTo.StatusId = @ToStatusId
	AND lsFrom.StatusId = @FromStatusId

	FOR XML EXPLICIT
END
GO
