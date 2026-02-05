SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchGroupsByGroupingRecent]
	(
		@ListOfIds varchar(2000),
		@TenantId bigint
	)

as      
      
begin      

If object_id('tempdb..#Tally') Is Null
Begin
	Select Top 11000 Identity(int,1,1) AS N   
	Into #Tally
	From master.dbo.SysColumns sc1,        
	master.dbo.SysColumns sc2

	declare @sql nvarchar(255) = N'
	Alter Table #Tally
	Add Constraint PK_Tally_N' + cast(@@spid as nvarchar) + N'
	Primary Key Clustered (N) With FillFactor = 100'
	exec sp_executesql @sql
End

Declare @InternalListOfIds varchar(2000)
Select @InternalListOfIds = LTrim(RTrim(@ListOfIds))
If Right(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = @InternalListOfIds + ','
If Left(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = ',' + @InternalListOfIds

Declare @RecentIds Table ( RecentId int )

Insert Into @RecentIds
( RecentId ) 
Select substring(@InternalListOfIds, N+1, CHARINDEX(',', @InternalListOfIds, N+1) -N -1)   
FROM #Tally  
WHERE N < LEN(@InternalListOfIds)
	AND SUBSTRING(@InternalListOfIds, N, 1) = ','


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
	and a.groupid in (Select RecentId From @RecentIds)
	and ISNULL(d.ArchiveFg, 0) = 0
end
GO
