SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveRefPlanningTypeByPlanningType]
	@RefPlanningType varchar(50)
AS

SELECT isnull(T1.RefPlanningTypeId,0) as RefPlanningTypeId
FROM TRefPlanningType  T1
WHERE T1.PlanningType = @RefPlanningType
GO
