SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[nio_userexample_paged] (
	@pagesize int,
	@pagenumber int
) as

declare @firstrow int, @lastrow int

select	@firstrow = (@pagenumber - 1) * @pagesize + 1,
		@lastrow = (@pagenumber - 1) * @pagesize + @pagesize;

with PagedUsers as
(
	select
		au.userid, 
		au.identifier as useridentifier, 
		au.passwordhistory as passwordhistory,
		au.password,
		au.failedaccessattempts,
		au.SuperUser,
		au.SuperViewer,
		au.indigoclientid,
		au.groupid, 
		au.email,
		--ag.identifier as groupidentifier,
		row_number() over (order by au.identifier asc) as RowNumber
	from 
		administration..tuser au
	join 
		administration..tgroup ag on ag.groupid = au.groupid
)
select 
	*
from	
	PagedUsers
where 
	RowNumber between @firstrow and @lastrow
order by
	RowNumber asc
GO
