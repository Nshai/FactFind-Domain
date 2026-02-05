SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_ControllerAccess_RetrieveByUserIdAndControllerNameAndControllerAction]
	@UserId BIGINT,
	@IsSuperUser bit = 0,
	@ControllerName varchar(255) = '',
	@ControllerAction varchar(255) = ''
As

-- handle active role (pre-checks)
declare @activerole bigint 
set @activerole = null
if not @userId is null
	select @activerole = activerole from tuser where UserId = @UserId



-- NoSecurityContextRequired OR AccessForAllLoggedOnUsers 
Select Distinct A.ControllerActionId As 'ControllerAccess_ControllerAccessId', 
	A.ControllerName As 'ControllerAccess_ControllerName', 
	A.ControllerAction As 'ControllerAccess_ControllerAction', 
	A.NoSecurityContextRequired As 'ControllerAccess_NoSecurityContextRequired', 
	A.AccessForAllLoggedOnUsers As 'ControllerAccess_AccessForAllLoggedOnUsers', 
	Null As 'ControllerAccess_RightMask'
	--, Null As 'SystemPath', Null As 'SystemType'
From TControllerAction A
Where (A.NoSecurityContextRequired = 1 OR A.AccessForAllLoggedOnUsers = 1)
	And (A.ControllerName = @ControllerName Or @ControllerName = '')
	And (A.ControllerAction = @ControllerAction Or @ControllerAction = '')

Union

-- User specific access
Select Distinct A.ControllerActionId, A.ControllerName, A.ControllerAction, 
	A.NoSecurityContextRequired, A.AccessForAllLoggedOnUsers, D.RightMask
	-- , C.SystemPath, C.SystemType 
From TControllerAction A
Left Join TControllerActionToTSystem B On A.ControllerActionId = B.ControllerActionId
Left Join TSystem C On B.SystemId = C.SystemId
Left Join TKey D On C.SystemId = D.SystemId
Where 1=1
	And A.NoSecurityContextRequired = 0
	And A.AccessForAllLoggedOnUsers = 0
	And D.UserId = @UserId And @IsSuperUser = 0 And @UserId > 0
	And (A.ControllerName = @ControllerName Or @ControllerName = '')
	And (A.ControllerAction = @ControllerAction Or @ControllerAction = '')
	And (D.RoleId = @ActiveRole OR @ActiveRole IS NULL)
Union

-- Super user/viewer access
Select Distinct A.ControllerActionId, A.ControllerName, A.ControllerAction, 
	A.NoSecurityContextRequired, A.AccessForAllLoggedOnUsers, Null
From TControllerAction A
Where 1=1
	And A.NoSecurityContextRequired = 0
	And A.AccessForAllLoggedOnUsers = 0
	And @IsSuperUser = 1 And @UserId > 0
	And (A.ControllerName = @ControllerName Or @ControllerName = '')
	And (A.ControllerAction = @ControllerAction Or @ControllerAction = '')
GO
