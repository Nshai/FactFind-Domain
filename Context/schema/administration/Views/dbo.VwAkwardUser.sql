SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VwAkwardUser] as

select 
au.AwkwardUserId,
crmcontactid,
au.userid,
au.IsExempt,
au.DateAdded,
au.ConcurrencyId
from	TAwkwardUser au
inner join Tuser u on u.userid = au.userid
GO
