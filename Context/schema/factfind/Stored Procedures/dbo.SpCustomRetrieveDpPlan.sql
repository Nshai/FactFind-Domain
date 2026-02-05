SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveDpPlan]
	@DpPlanId bigint
AS

SELECT T1.DpPlanId, T1.CRMContactId, T1.AdviserId, T1.IndigoClientId, T1.PlanGuid, T1.PlanXml, T1.ConcurrencyId
FROM TDpPlan T1
	
WHERE T1.DpPlanId = @DpPlanId

GO
