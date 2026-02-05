SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLifeCycleByPolicyIdForStatus]
	@PolicyBusinessId Bigint,
	@IntelligentOfficeStatusType varchar(255)
AS

Select ISNULL(T3.StatusId, 0) AS StatusId
from TStatus T3 
INNER JOIN TLifeCycleStep T2 ON T3.StatusId = T2.StatusId    
INNER JOIN TLifeCycle T1 ON T2.LifeCycleId = T1.LifeCycleId    
INNER JOIN TPolicyBusiness  T4 ON T1.LifeCycleId = T4.LifeCycleId

WHERE T4.policyBusinessId = @PolicyBusinessId
AND (T3.IntelligentOfficeStatusType = @IntelligentOfficeStatusType)
GO
