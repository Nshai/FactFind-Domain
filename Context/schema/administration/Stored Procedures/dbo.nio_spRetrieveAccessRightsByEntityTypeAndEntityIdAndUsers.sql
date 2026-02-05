SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spRetrieveAccessRightsByEntityTypeAndEntityIdAndUsers]
	@DatabaseName varchar(20) = 'CRM',
	@DatabaseEntityTypeName varchar(10),
	@ListOfEntityIds varchar(max),
	@UserId bigint,
	@TenantId bigint

AS

/* test

Declare @EntityIds varchar(max), @UserId bigint
Select @EntityIds = '99685,99807,99844,99848,99863,  100933,100936,101114, 3093689,3093690,'
Select @UserId = 970 -- SuperUser - access all rights 15
Select @UserId = 2173 -- SuperViewer - access all rights 1
Select @UserId = 1066 -- NonSuperAnything - no access
Select @UserId = 1450 -- NonSuperAnything - access own 4 records rights 15
Select @UserId = 19351 -- NonSuperAnything - access all 

exec nio_spRetrieveAccessRightsByEntityTypeAndEntityIdAndUsers 'crm', 'CRMContact', @EntityIds, @UserId, 99

Select 0.116/.72 -- = 0.16
Select 0.116/.54 -- = 0.215
Select top 100 * From crm..TCRMContactKey Where CreatorId = 1450
*/

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

Declare @InternalListOfIds varchar(max)
Select @InternalListOfIds = LTrim(RTrim(@ListOfEntityIds))
If Right(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = @InternalListOfIds + ','
If Left(@InternalListOfIds, 1) <> ',' Select @InternalListOfIds = ',' + @InternalListOfIds

-- Declare @EntityIds Table ( EntityId bigint, RightMask int )
Create Table #EntityIds ( EntityId bigint, TenantId bigint, RightMask int )

Insert Into #EntityIds
( EntityId ) 
Select substring(@InternalListOfIds, N+1, CHARINDEX(',', @InternalListOfIds, N+1) -N -1)   
FROM #Tally  
WHERE N < LEN(@InternalListOfIds)
	AND SUBSTRING(@InternalListOfIds, N, 1) = ','
	
	Update B
	Set TenantId = IndClientId
	From CRM.dbo.TCRMContact A With(nolock)
	Join #EntityIds B with(nolock) On A.CRMContactId = B.EntityId
	Where A.IndClientId = @TenantId
	
	Delete #EntityIds Where TenantId Is Null
	
	/* Delete #EntityIds Where EntityId Not In 
	(Select CRMContactId From CRM.dbo.TCRMContact With(nolock)
		Where IndClientId = @TenantId And CRMContactId In 
			(Select EntityId From #EntityIds With(nolock) )) */
		
	DECLARE @AccessQuery NVARCHAR(4000), @RightMask int 
	
	-- SuperUser and SuperViewer Rights
	IF EXISTS (SELECT 1 FROM TUser WHERE (SuperUser = 1) AND UserId = ABS(@UserId))
	BEGIN
		Update #EntityIds
		Set RightMask = 15
	END
    -- Check if the User is a Super Viewer, If so, use the TPolicy entries.
	ELSE IF EXISTS (SELECT 1 FROM TUser WHERE (SuperViewer = 1) AND UserId = ABS(@UserId))
	BEGIN
		-- Update #EntityIds Set RightMask = 1
		Update #EntityIds
		Set RightMask = a.RightMask
		From VwPolicyRights a
		Where UserId = ABS(@UserId) And Entity = @DatabaseEntityTypeName
	END
	Else -- If User is neither super user nor super viewer, then No access.
	Begin
		Update #EntityIds Set RightMask = 0
	End

	Update #EntityIds Set RightMask = 0 Where RightMask Is Null

	-- Non SuperViewer and Non SuperUser rights
	SELECT @AccessQuery = 
	'Update B
	Set RightMask = CASE TRoot._OwnerId 
		  WHEN ' + CONVERT(VARCHAR(20), @UserId) + ' THEN 15 
		  ELSE ISNULL(TCKey.RightMask, B.RightMask) | ISNULL(TEKey.RightMask, B.RightMask) 
		END
	FROM CRM.dbo.TCRMContact TRoot
	JOIN #EntityIds B On TRoot.CRMContactId = B.EntityId
	LEFT JOIN ' + @DatabaseName + '.dbo.Vw' 
		+ @DatabaseEntityTypeName + 'KeyByCreatorId TCKey ON TCKey.UserId = ' 
			+ CONVERT(VARCHAR(20), @UserId) + ' AND TCKey.CreatorId = TRoot._OwnerId
	LEFT JOIN ' + @DatabaseName + '.dbo.Vw' 
		+ @DatabaseEntityTypeName+'KeyByEntityId TEKey ON TEKey.UserId = '
			+ CONVERT(VARCHAR(20), @UserId) + ' AND TEKey.EntityId = TRoot.CRMContactId
	WHERE 1=1 And B.RightMask < 15
	
	
	Select EntityId,
		' + CONVERT(VARCHAR(20), @UserId) + ' AS UserId,
		''' + @DatabaseEntityTypeName + ''' AS DatabaseEntityTypeName,
		''CRMContact'' AS RootDatabaseEntityName,
		RightMask
	From #EntityIds'
		

	--Select @AccessQuery
	EXEC(@AccessQuery)


GO
