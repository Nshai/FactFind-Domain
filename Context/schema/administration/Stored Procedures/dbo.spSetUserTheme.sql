SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSetUserTheme] @NewTenantID bigint, @UserId bigint = null
as
begin
	insert into Administration..TProfileItem(ProfileItemId, [Key], [Value], LastUpdated, UserId, TenantId)
	select NEWID(), 'usertheme', 'True', GetDate(), u.UserId, u.IndigoClientId
	from Administration.dbo.TUser u
	left join Administration..TProfileItem PItem on PItem.UserId = u.UserId and pItem.TenantId = u.IndigoClientId
	where u.IndigoClientId = @NewTenantID and u.UserId = isnull(@UserId, u.UserId)
		and PItem.UserId is null
end

GO
