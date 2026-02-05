SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchAdvisersRecent]
	(
		@ListOfIds varchar(2000),
		@TenantId bigint,  
		@UserId bigint,
		@IsSuperUserOrSuperViewer bit,
		@_TopN int = 0  
	)

as    
-- don't know why this makes a difference, but it reduces the cost from 1.68 to 0.117  
declare @IndClientId2 bigint  
set @IndClientId2 = @TenantId  

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

SELECT  
T1.PractitionerId AS [PractitionerId],    
T2.CRMContactID AS [PartyId],   
T2.FirstName,        
T2.LastName,         
T2.FirstName + ' ' + T2.LastName AS [AdviserName],        
T5.Identifier AS [GroupingName],     
T4.Identifier AS [GroupName],    
T3.Identifier AS [UserName],    
T1.AuthorisedFG AS [AuthorisedFG],    
T3.Reference AS [Reference],
T3.UserId AS [AdviserRef]    
FROM [CRM].[dbo].TPractitioner T1  With(NoLock)    
INNER JOIN [CRM].[dbo].TCRMContact T2 With(NoLock)    
ON T1.CRMContactId = T2.CRMContactId AND T2.IndClientId = Convert(varchar(25), @IndClientId2)    
INNER JOIN [Administration].[dbo].TUser T3 With(NoLock)    
ON T1.CRMContactId = T3.CRMContactId  AND T3.IndigoClientId = Convert(varchar(25), @IndClientId2)    
INNER JOIN [Administration].[dbo].TGroup T4 With(NoLock)    
ON T4.GroupId = T3.GroupId   AND T4.IndigoClientId = Convert(varchar(25), @IndClientId2)     
INNER JOIN [Administration].[dbo].TGrouping T5 With(NoLock)    
ON T5.GroupingId = T4.GroupingId   AND T5.IndigoClientId = Convert(varchar(25), @IndClientId2)   
WHERE 
	T1.IndClientId = Convert(varchar(25), @IndClientId2) 
	And T2.CRMContactId in (Select RecentId From @RecentIds)    
GO
