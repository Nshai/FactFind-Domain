SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomRetrieveUserSetup]  
@UserId bigint  
  
as  
  
begin  
  
 declare @StampUser varchar(10)  
 declare @IsClientPortalUser bit
  
 set @StampUser = @UserId  
  
 IF NOT EXISTS (SELECT 1 FROM TValUserSetup WHERE UserId = @UserId)  
  exec SpCreateValUserSetup @StampUser, @UserId, 0, 0  
 else  
 begin  

	--Check to see if the user is a Client Portal User 
	select @IsClientPortalUser = Case When a.refusertypeid = 2 Then 1 Else 0 End
	from administration..tuser a
	where UserId = @UserId

	--if the User is a portal user, get their service adviser user Id
	If (@IsClientPortalUser = 1)
	Begin
		Select @UserId = c.UserId
		From administration..tuser a
		Inner Join crm..tcrmcontact b on a.crmcontactid = b.crmcontactid
		Inner Join administration..tuser c on IsNull(b.CurrentAdviserCRMId, 0) = c.crmcontactid
		Where a.UserId = @UserId
	End

	SELECT  
	1 AS Tag,  
	NULL AS Parent,  
	T1.ValUserSetupId AS [ValUserSetup!1!ValUserSetupId],   
	T1.UserId AS [ValUserSetup!1!UserId],   
	T1.UseValuationFundsFg AS [ValUserSetup!1!UseValuationFundsFg],   
	T1.UseValuationAssetsFg AS [ValUserSetup!1!UseValuationAssetsFg],   
	T1.ConcurrencyId AS [ValUserSetup!1!ConcurrencyId],
	@IsClientPortalUser As [ValUserSetup!1!IsClientPortalUser]
	FROM TValUserSetup T1  
	WHERE UserId = @UserID  
	ORDER BY [ValUserSetup!1!ValUserSetupId]  
	FOR XML EXPLICIT  

 end  
   
end  
  
GO
