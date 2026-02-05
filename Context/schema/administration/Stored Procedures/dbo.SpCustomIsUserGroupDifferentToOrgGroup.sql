SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomIsUserGroupDifferentToOrgGroup] @UserId bigint  
as  
  
DECLARE @UserGroupId bigint  
DECLARE @OrgGroupId bigint  
DECLARE @Result bit 
DECLARE @Exempt bit 
  
SET @Result=0  
  
SELECT @UserGroupId=GroupId FROM Administration..TUser WHERE UserId=@UserId  
SET @OrgGroupId=550  



--First are they in TAwkwardUser
SELECT @Exempt=IsExempt FROM Administration..TAwkwardUser WHERE UserId=@UserId
IF ISNULL(@Exempt,0)=0
--They are not exempt so carry on looking  
BEGIN
	IF @UserGroupId<>@OrgGroupId  
	BEGIN  
	 SELECT @Result=1  
	END  
END
  
SELECT @Result AS Result  
  
  
GO
