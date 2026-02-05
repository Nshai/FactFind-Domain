SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchGroupsByGrouping]
	(
		@TenantId bigint,  
		@GroupName varchar (64) = '%',
		@GroupingId bigint = 0,
		@_TopN int = 0  
	)

as      
      
begin      

If @GroupName <> '%'    
 Select @GroupName = '%' + @GroupName + '%'   

select	a.GroupId as GroupId, 
		a.identifier as GroupName,		
		b.identifier as GroupingName, 
		c.identifier as ParentGroupName,
		b.groupingid as GroupingId,		 
		c.GroupId as ParentGroupId,
		d.CRMContactId as GroupPartyId,
		e.CRMContactId as ParentGroupPartyId
	from tgroup a	
	join tgrouping b on b.groupingid=a.groupingid 	
	left outer join tgroup c on c.groupid = a.parentid
	left outer join crm..tcrmcontact d on a.CRMContactId = d.CRMContactId
	left outer join crm..tcrmcontact e on c.CRMContactId = e.CRMContactId
 where a.indigoclientid=@TenantId
	and (a.identifier like @GroupName or a.identifier = '')
	and (b.groupingid=@GroupingId or @GroupingId=0)
	and ISNULL(d.ArchiveFg, 0) = 0
end
GO
