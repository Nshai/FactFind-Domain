SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_CustomCreateEntityKeysByUserIdAndRoleId]
	@UserId bigint,
	@RoleId bigint

As

-- exec nio_CustomCreateEntityKeysByUserIdAndRoleId 12, 12

Declare @sql varchar(8000)

Select @sql = IsNull(@sql,'') + 'Exec Administration.dbo.SpCustomApplyPolicy @PolicyId = '
	+ Convert(varchar(50), PolicyId) + ', @UserId = '
	+ Convert(varchar(50), @UserId) + '
'
From TPolicy Where RoleId = @RoleId And Applied = 'yes'


Execute( @sql)

Select 1
GO
