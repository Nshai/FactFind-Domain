SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spCustomRetrievePortfolios] 
@IndigoClientId bigint,
@UserId bigint

as

select 
1 as tag,
null as parent,
p.PortfolioId as [Portfolio!1!PortfolioId], 
p.Title as [Portfolio!1!Title]
from policymanagement..TPortfolio p
inner join administration..TUser u on u.crmcontactid = p.createdby
where 
--correct tenant
u.IndigoclientId = @IndigoClientId and
--if the portfolio is private then it can only be viewed by its creator
--if it is public then ensure it is active
((IsPublic = 0 and u.userid = @UserId) or (IsPublic = 0 and IsActive = 1)) and
--check the group restrictions
(	
	--not group restricted
	IsGroupRestricted = 0 or
	--group restricted but user is in the group named
	(IsGroupRestricted = 1 and u.GroupId = isnull(p.GroupId,0)) or
	--group restricted but user is in a subgroup
	(IsGroupRestricted = 1 and exists(	
		select	g.groupId as g, 
		g1.groupId as g1, 
		g2.groupId as g2 ,
		g3.groupId as g3 ,
		g4.groupId as g4 ,
		g5.groupId as g5 ,
		g6.groupId as g6 ,
		g7.groupId as g7 ,
		g8.groupId as g8 ,
		g9.groupId as g9
		from administration..TGroup g
		left join administration..Tgroup g1 on g1.parentId = g.groupId
		left join administration..Tgroup g2 on g2.parentId = g1.groupId
		left join administration..Tgroup g3 on g3.parentId = g2.groupId
		left join administration..Tgroup g4 on g4.parentId = g3.groupId
		left join administration..Tgroup g5 on g5.parentId = g4.groupId
		left join administration..Tgroup g6 on g6.parentId = g5.groupId
		left join administration..Tgroup g7 on g7.parentId = g6.groupId
		left join administration..Tgroup g8 on g8.parentId = g8.groupId
		left join administration..Tgroup g9 on g9.parentId = g8.groupId
		where g.indigoclientid = @IndigoClientId and p.GroupId = g.groupid and
		(u.groupid = g1.groupid or
		u.groupid = g2.groupid or
		u.groupid = g3.groupid or
		u.groupid = g4.groupid or
		u.groupid = g5.groupid or
		u.groupid = g6.groupid or
		u.groupid = g7.groupid or
		u.groupid = g8.groupid or
		u.groupid = g9.groupid)
	)
))
order by p.portfolioid

FOR XML EXPLICIT
GO
