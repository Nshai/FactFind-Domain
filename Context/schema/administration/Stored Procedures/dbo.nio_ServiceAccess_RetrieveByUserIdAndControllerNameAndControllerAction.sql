SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[nio_ServiceAccess_RetrieveByUserIdAndControllerNameAndControllerAction]
	@UserId varchar(128) = 0,
	@SuperUserOrSuperViewer bit = 0,
	@ServiceName varchar(255) = '',
	@ServiceAction varchar(255) = '',
	@ServiceActionSubType varchar(255) = ''
As

/*
exec nio_ServiceAccess_RetrieveByUserIdAndControllerNameAndControllerAction 6123, 
	'IntelliFlo.IO.Services.SecurityService', 'GetAllowedActionsForController'



exec nio_ServiceAccess_RetrieveByUserIdAndControllerNameAndControllerAction @UserId=9890,
	@ServiceName=N'IntelliFlo.IO.Services.SecurityService',@ServiceAction=N'CustomSearch',@ServiceActionSubType=N'User'

Select * from TServiceAction
Where ServiceName=N'IntelliFlo.IO.Services.SecurityService'
	And ServiceAction=N'CustomSearch'
	And ServiceActionSubType=N'User'

*/

SELECT DISTINCT 
	ServiceActionId AS ServiceAccess_ServiceAccessId, 
	ServiceName as ServiceAccess_ServiceName, 
	ServiceAction as ServiceAccess_ServiceAction, 
	NoSecurityContextRequired as ServiceAccess_NoSecurityContextRequired, 
	AccessForAllLoggedOnUsers as ServiceAccess_AccessForAllLoggedOnUsers, 
	0 AS ServiceAccess_RightMask, 
	MinimiumAccessRequired as ServiceAccess_MinimiumAccessRequired
FROM         dbo.TServiceAction AS A
WHERE (NoSecurityContextRequired = 1 OR AccessForAllLoggedOnUsers = 1) 
		AND (ServiceName = @ServiceName OR @ServiceName = '') 
		/*AND (ServiceAction = @ServiceAction OR @ServiceAction = '') 
		AND (IsNull(ServiceActionSubType,'') = @ServiceActionSubType OR @ServiceActionSubType = '')
*/
UNION

SELECT     MAX(A.ServiceActionId) AS Expr1, A.ServiceName, A.ServiceAction, CONVERT(bit, 0) AS Expr2, 
	CONVERT(bit, 0) AS Expr3, MAX(D.RightMask) AS Expr4, A.MinimiumAccessRequired
FROM dbo.TServiceAction AS A 
INNER JOIN dbo.TServiceActionToTSystem AS B ON A.ServiceActionId = B.ServiceActionId 
INNER JOIN dbo.TSystem AS C ON B.SystemId = C.SystemId 
LEFT JOIN dbo.TKey AS D ON C.SystemId = D.SystemId
Where 1=1
	And A.NoSecurityContextRequired = 0
	And A.AccessForAllLoggedOnUsers = 0
	And ((@SuperUserOrSuperViewer = 0 And D.UserId = @UserId) Or (@SuperUserOrSuperViewer = 1))
	And (A.ServiceName = @ServiceName Or @ServiceName = '')
	And (A.ServiceAction = @ServiceAction Or @ServiceAction = '')
	And (A.ServiceActionSubType = @ServiceActionSubType Or @ServiceActionSubType = '')
Group By A.ServiceName, A.ServiceAction, A.MinimiumAccessRequired
GO
