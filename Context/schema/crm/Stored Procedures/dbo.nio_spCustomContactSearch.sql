SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_spCustomContactSearch](
	@TenantId bigint,
	--@ArchiveFg tinyint,
	--@RefCRMContactStatusId bigint,
	@CRMContactType tinyint = 0,
	@LastName varchar (50) = '',
	@FirstName varchar (50) = '',
	@CorporateName varchar (255) = '',
	@_UserId bigint,
	@_TopN int = 0  
)

as      
      
begin

  -- Set default ArchiveFG = 0
  DECLARE @ArchiveFg tinyint
  SET @ArchiveFg = 0

  -- User rights
  DECLARE @RightMask int, @AdvancedMask int
  SELECT @RightMask = 1, @AdvancedMask = 0

	-- SuperUser and SuperViewer processing 
	-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers
	-- A negative Id results in Entity Security being overridden
	IF(@_UserId > 0) BEGIN

		IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1)) 
			SET @_UserId = @_UserId * -1

	END

  -- SuperViewers won't have an entry in the key table so we need to get their rights now
  IF @_UserId < 0
      EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT

-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    


  SELECT 
	T1.CRMContactId AS [PartyId], 
    ISNULL(T1.RefCRMContactStatusId, '') AS [RefCRMContactStatusId], 
    --ISNULL(T1.PersonId, '') AS [PersonId], 
    --ISNULL(T1.CorporateId, '') AS [CorporateId], 
    --ISNULL(T1.TrustId, '') AS [TrustId], 
    --ISNULL(T1.AdvisorRef, '') AS [AdvisorRef], 
    --ISNULL(T1.RefSourceOfClientId, '') AS [RefSourceOfClientId], 
    --ISNULL(T1.SourceValue, '') AS [SourceValue], 
    --ISNULL(T1.Notes, '') AS [Notes], 
    --ISNULL(T1.ArchiveFg, '') AS [ArchiveFg], 
    ISNULL(T1.LastName, '') AS [LastName], 
    ISNULL(T1.FirstName, '') AS [FirstName], 
    ISNULL(T1.CorporateName, '') AS [CorporateName], 
    ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName, '') + ' ' + ISNULL(T1.LastName, '') AS [FullName],
    --ISNULL(CONVERT(varchar(24), T1.DOB, 120),'') AS [DOB], 
    ISNULL(T1.Postcode, '') AS [Postcode], 
    --T1.OriginalAdviserCRMId AS [OriginalAdviserCRMId], 
    --T1.CurrentAdviserCRMId AS [CurrentAdviserCRMId], 
    --ISNULL(T1.CurrentAdviserName, '') AS [CurrentAdviserName], 
    T1.CRMContactType AS [CRMContactType], 
    T1.IndClientId AS [TenantId], 
    --ISNULL(T1.FactFindId, '') AS [FactFindId], 
    --ISNULL(T1.InternalContactFG, '') AS [InternalContactFG], 
    --ISNULL(T1.RefServiceStatusId, '') AS [RefServiceStatusId], 
    ISNULL(T1.MigrationRef, '') AS [MigrationRef], 
    --CONVERT(varchar(24), T1.CreatedDate, 120) AS [CreatedDate], 
    ISNULL(T1.ExternalReference, '') AS [ExternalReference], 
    --ISNULL(T1.CampaignDataId, '') AS [CampaignDataId], 
    --ISNULL(T1.AdditionalRef, '') AS [AdditionalRef],
    --ISNULL(T1._ParentId, '') AS [_ParentId], 
    --ISNULL(T1._ParentTable, '') AS [CRMContact!1!_ParentTable], 
    --ISNULL(T1._ParentDb, '') AS [CRMContact!1!_ParentDb], 
    --ISNULL(T1._OwnerId, '') AS [CRMContact!1!_OwnerId], 
    --T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId], 
    --CASE T1._OwnerId 
    --  WHEN ABS(@_UserId) THEN 15 
    --  ELSE ISNULL(TCKey.RightMask, @RightMask)|ISNULL(TEKey.RightMask, @RightMask) 
    --END AS [_RightMask], 
    --CASE T1._OwnerId 
    --  WHEN ABS(@_UserId) THEN 240 
    --  ELSE ISNULL(TCKey.AdvancedMask, @AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask) 
    --END AS [_AdvancedMask], 

    --ISNULL(TNote.Note, '') AS [CRMContact!1!_note], 

    --T2.RefCRMContactStatusId, 
    --ISNULL(T2.StatusName, '') AS [ContactStatusName], 
    --ISNULL(T2.OrderNo, ''), 
    --ISNULL(T2.InternalFG, ''), 
    --T2.ConcurrencyId, 

    --T3.CorporateId, 
    --ISNULL(T3.IndClientId, ''), 
    --ISNULL(T3.CorporateName, ''), 
    --ISNULL(T3.ArchiveFg, ''), 
    --ISNULL(T3.BusinessType, ''), 
    --ISNULL(T3.RefCorporateTypeId, ''), 
    ---ISNULL(T3.CompanyRegNo, ''), 
    --ISNULL(CONVERT(varchar(24), T3.EstIncorpDate, 120),''), 
    --ISNULL(CONVERT(varchar(24), T3.YearEnd, 120),''), 
    --ISNULL(T3.VatRegFg, ''), 
    --ISNULL(T3.VatRegNo, ''), 
    --T3.ConcurrencyId, 

    --T4.TrustId AS [TrustId], 
    --T4.RefTrustTypeId AS [RefTrustTypeId], 
    --T4.IndClientId AS [IndClientId], 
    T4.TrustName AS [TrustName]
    --ISNULL(CONVERT(varchar(24), T4.EstDate, 120),'') AS [EstDate], 
    --T4.ArchiveFG, 
    --T4.ConcurrencyId AS [ConcurrencyId], 

    --T5.RefCorporateTypeId, 
    --ISNULL(T5.TypeName, '')AS [CorporateTypeName], 
    --ISNULL(T5.HasCompanyRegFg, ''), 
    --ISNULL(T5.ArchiveFg, ''), 
    --T5.ConcurrencyId, 

    --T6.RefTrustTypeId, 
    --T6.TrustTypeName 
    --T6.ArchiveFG, 
    --T6.ConcurrencyId

FROM TCRMContact T1
      -- Secure clause
  LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId
  LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId  -- Note clause
  
  LEFT JOIN TCRMContactNote TNote ON TNote.CRMContactId = T1.CRMContactId AND TNote.IsLatest=1
  LEFT JOIN TRefCRMContactStatus T2 ON T2.RefCRMContactStatusId = T1.RefCRMContactStatusId
  LEFT JOIN TCorporate T3 ON T3.CorporateId = T1.CorporateId	
  LEFT JOIN TTrust T4 ON T4.TrustId = T1.TrustId
  LEFT JOIN TRefCorporateType T5 ON T5.RefCorporateTypeId = T3.RefCorporateTypeId
  LEFT JOIN TRefTrustType T6 ON T6.RefTrustTypeId = T4.RefTrustTypeId

WHERE (T1.IndClientId = @TenantId) AND 
		(T1.ArchiveFg = @ArchiveFg) AND 
        (T1.RefCRMContactStatusId IS NOT NULL) AND 

		(@CorporateName='' OR (ISNULL(T1.CorporateName,'') LIKE @CorporateName + '%' AND @CorporateName<>'')) AND
		(@LastName='' OR (ISNULL(T1.LastName,'') LIKE @LastName + '%' AND @LastName<>'' )) AND
		(@FirstName='' OR (ISNULL(T1.FirstName,'') LIKE @FirstName + '%' AND @FirstName<>'' )) AND
		(@CRMContactType=0 OR (T1.CRMContactType = @CRMContactType AND @CRMContactType > 0))

        --(
		--	(T1.CRMContactType = @CRMContactType AND @CRMContactType > 0) AND
		--	(T1.LastName LIKE '%' + @LastName + '%' AND @LastName <> '') AND
		--	(T1.FirstName LIKE '%' + @FirstName + '%' AND @FirstName <> '') AND
		--	(T1.CorporateName LIKE '%' + @CorporateName + '%' AND @CorporateName <> '')		
		--)	

        AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))

  ORDER BY T1.CRMContactId, T4.TrustId, T6.RefTrustTypeId, T3.CorporateId, T5.RefCorporateTypeId, T2.RefCRMContactStatusId

IF (@_TopN > 0) SET ROWCOUNT 0    

end
GO
