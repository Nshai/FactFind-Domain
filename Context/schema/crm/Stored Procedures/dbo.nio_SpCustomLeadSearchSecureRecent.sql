SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomLeadSearchSecureRecent
  @ListOfIds varchar(2000),
  @TenantId bigint,    
  @_UserId bigint = 0  
  
AS        


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
     
BEGIN


-- SuperUser and SuperViewer processing   
-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers  
-- A negative Id results in Entity Security being overridden  
IF(@_UserId > 0) BEGIN  
  
 IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))   
  SET @_UserId = @_UserId * -1  
  
END  

-- User Rights
DECLARE @RightMask INT
DECLARE @AdvancedMask INT
DECLARE @HasPolicy BIT
SELECT @RightMask = 1, @AdvancedMask = 0, @HasPolicy = 0        
IF @_UserId < 0        
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'Lead', @RightMask OUTPUT, @AdvancedMask OUTPUT        
     

-- START SEARCHING
SELECT        
 L.LeadId AS [LeadId],   
 C.CRMContactId AS [PartyId],       
 C.IndClientId AS [TenantId],         
 CASE        
  WHEN C.CRMContactType = 1 THEN (C.FirstName + ' ' + C.LastName)        
  WHEN C.CRMContactType in (2,3,4) THEN (C.CorporateName)        
 END AS  [LeadFullName],        

 CASE        
  WHEN C.CRMContactType = 1 THEN 'Person'        
  WHEN C.CRMContactType = 2 THEN 'Trust'        
  WHEN C.CRMContactType = 3 THEN 'Corporate'        
  WHEN C.CRMContactType = 4 THEN 'Group'        
 END AS  [LeadTypeName],        

 ISNULL(C.CurrentAdviserName, '') AS [AdviserName],         
 IsNull(C.AdditionalRef,'') AS [SecondaryRef],        
 ISNULL(Ls.Descriptor, '') AS [LeadStatus],        
 ISNULL(tct.CampaignType,'') AS [CampaignType],        
 ISNULL(tc.CampaignName,'') AS [CampaignSource],        
 ISNULL(tcd.Description,'') AS [Description],        

  CASE C._OwnerId        
  WHEN ABS(@_UserId) THEN 15        
    ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
  END AS [_RightMask],        
  
  CASE C._OwnerId        
  WHEN ABS(@_UserId) THEN 240        
	ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
  END AS [_AdvancedMask] ,
  C.ArchiveFg AS [IsDeleted],
 C.FirstName,
 C.LastName       

FROM         
 CRM..TCRMContact C WITH(NOLOCK)      
 JOIN CRM..TLead L WITH(NOLOCK) ON L.CRMContactId = C.CRMContactId        
 JOIN CRM..TLeadStatusHistory Lsh WITH(NOLOCK) ON Lsh.LeadId = L.LeadId AND Lsh.CurrentFg = 1        
    JOIN CRM..TLeadStatus Ls WITH(NOLOCK) ON Ls.LeadStatusId = Lsh.LeadStatusId        
 LEFT JOIN CRM..TAddress Ad WITH(NOLOCK) ON Ad.CRMContactId = C.CRMContactId AND Ad.DefaultFG = 1        
 LEFT JOIN CRM..TAddressStore Ads WITH(NOLOCK) ON Ads.AddressStoreId = Ad.AddressStoreId        
 LEFT JOIN CRM..TPractitioner A WITH(NOLOCK) ON A.CRMContactId = C.CurrentAdviserCRMId    AND (C.CurrentAdviserCRMId != NULL)     
 LEFT JOIN CRM..TCampaignData tcd WITH(NOLOCK) ON tcd.CampaignDataId = c.CampaignDataId        
 LEFT JOIN CRM..TCampaign tc WITH(NOLOCK) ON tc.CampaignId = tcd.CampaignId        
 LEFT JOIN CRM..TCampaignType tct WITH(NOLOCK) ON tct.CampaignTypeId = tc.CampaignTypeId        
        
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)        
 LEFT JOIN VwLeadKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId        
 LEFT JOIN VwLeadKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId        
WHERE         
	C.CRMContactId In (Select RecentId From @RecentIds )
	AND C.ArchiveFg = 0
ORDER BY C.CRMContactId DESC   

END
GO
