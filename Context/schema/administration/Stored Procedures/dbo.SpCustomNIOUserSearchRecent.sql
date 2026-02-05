SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SpCustomNIOUserSearchRecent]
(
		@ListOfIds varchar(2000),
		@UserId bigint
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

Declare @RefUserTypeId int
Select @RefUserTypeId = RefUserTypeId 
From Administration.dbo.TUser         
Where UserId = @UserId

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

	Select Distinct U.UserId  
	, U.CRMContactId As CRMContactId  
	, U.Identifier As UserIdentifier  
	, C.FirstName AS FirstName  
	, C.LastName As LastName  
	, C.FirstName + ' ' + C.LastName As UserFullName  
	, G.Identifier As GroupIdentifier  
	, dbo.FnCustomRetrieveUserRoles(U.UserId) As Roles  
	, U.Status As [Status]    
	, '' AS LicenceTypeName
	  
	From TUser U With(NoLock)  
	Inner Join CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId  
	Inner Join TGroup G With(NoLock) On G.GroupId = U.GroupId  
	Inner Join TIndigoClientLicense L With(NoLock) ON L.IndigoCLientId = U.IndigoClientId  

  WHERE 1 = 1    
  AND (U.RefUserTypeId = 1 OR (@RefUserTypeId = 6 AND U.RefUserTypeId = 6)) -- Filter Out All Users Except Standard User and Support User if the user searching is a Support User
  And U.UserId in (Select RecentId From @RecentIds)
  
End 
GO
