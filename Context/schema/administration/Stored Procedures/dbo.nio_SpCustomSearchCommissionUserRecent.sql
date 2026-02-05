SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchCommissionUserRecent]
(
		@ListOfIds varchar(2000),
		@TenantId bigint
)		
as
  
BEGIN  

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


SELECT Distinct  
   T1.UserId,T1.CRMContactId,  
   T2.FirstName, T2.LastName,  
   T5.Identifier AS GroupingName,   
   T4.Identifier AS GroupName  
  FROM [Administration].[dbo].TUser T1  
  Inner Join CRM..TCRMContact T2 on T1.CRMContactId=T2.CRMcontactId
  Left Join CRM..TPractitioner T3 on T3.CRMContactId=T2.CRMContactId
  Inner JOIN [Administration].[dbo].TGroup T4 ON T4.GroupId = T1.GroupId  
  Inner JOIN [Administration].[dbo].TGrouping T5 ON T5.GroupingId = T4.GroupingId  
  
  WHERE 
  T1.UserId in (Select RecentId From @RecentIds)
  
end 
GO
