SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/* =====================================================================================

Name : nio_SpCustomNIOCRMContactClientRecent

Date        Issue        Who     Description
----------  -----------  ---     -----------------------------
  ??			  ??		    ??	   Original version
05/07/2021   AIOSEC-211  W Webb  Addition of support for additional groups for users

===================================================================================== */
CREATE Procedure [dbo].[nio_SpCustomNIOCRMContactClientRecent]
(
		@ListOfIds varchar(2000),
	    @_UserId bigint = -1,
	    @TenantId bigint
)
AS
Declare @spacer varchar(10)

Select @spacer = '00000000'

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
    
      
begin      
      
		SELECT
		T1.CRMContactId AS [PartyId], 
		ISNULL(T1.AdvisorRef, '') AS [AdvisorRef], 
		ISNULL(T1.ArchiveFg, '') AS [ArchiveFg], 
		ISNULL(T1.LastName, '') AS [LastName], 
		ISNULL(T1.FirstName, '') AS [FirstName], 
		ISNULL(T1.CorporateName, '') AS [CorporateName], 
		ISNULL(T1.CurrentAdviserName, '') AS [CurrentAdviserName], 
		CASE
			WHEN T1.CRMContactType = 1 THEN (T1.FirstName + ' ' + T1.LastName)
			WHEN T1.CRMContactType in (2,3,4) THEN (T1.CorporateName)
		END AS  [FullName],
		T1.IndClientId AS [TenantId]		
	FROM 
		TCRMContact T1
		LEFT JOIN TRefCRMContactStatus T2 ON T2.RefCRMContactStatusId = T1.RefCRMContactStatusId	
		LEFT JOIN
			(SELECT TKey.EntityId, TKey.UserId, 
			        MAX(TKey.RightMask&1) + MAX(TKey.RightMask&2) + MAX(TKey.RightMask&4) + MAX(TKey.RightMask&8) AS _RightMask,
			        MAX(TKey.AdvancedMask&16) + MAX(TKey.AdvancedMask&32) + MAX(TKey.AdvancedMask&64) + MAX(TKey.AdvancedMask&128) AS _AdvancedMask
			 FROM VwCRMContactKeyByEntityId TKey
			 WHERE TKey.UserId = ABS(@_UserId) AND (TKey.RightMask & 1) !=0
			 GROUP BY EntityId, UserId) AS TKey ON TKey.EntityId = T1.CRMContactId 	
		LEFT JOIN TAddress T3 ON T3.CRMContactId = T1.CRMContactId AND T3.DefaultFG = 1
		LEFT JOIN TAddressStore T4 ON T4.AddressStoreId = T3.AddressStoreId
		LEFT JOIN TRefCounty T5 ON T5.RefCountyId = T4.RefCountyId
		LEFT JOIN TRefCountry T6 ON T6.RefCountryId = T4.RefCountryId
		LEFT JOIN TPerson T8 ON T8.PersonId = T1.PersonId
		LEFT JOIN TContact T9 ON T9.CRMContactId = T1.CRMContactId AND T9.DefaultFG = 1 AND T9.RefContactType = 'Telephone'
		LEFT JOIN TContact T10 ON T10.CRMContactId = T1.CRMContactId AND T10.DefaultFG = 1 AND T10.RefContactType = 'Mobile'
		LEFT JOIN TContact T11 ON T11.CRMContactId = T1.CRMContactId AND T11.DefaultFG = 1 AND T11.RefContactType = 'Fax'
		LEFT JOIN TContact T12 ON T12.CRMContactId = T1.CRMContactId AND T12.DefaultFG = 1 AND T12.RefContactType = 'E-Mail'
		LEFT JOIN TContact T13 ON T13.CRMContactId = T1.CRMContactId AND T13.DefaultFG = 1 AND T13.RefContactType = 'Web Site'
	WHERE 
		  T1.IndClientId = @TenantId 
	AND T1.CRMContactId in (Select RecentId From @RecentIds)		
	ORDER BY [LastName] DESC, [FirstName] DESC
	
END
GO
