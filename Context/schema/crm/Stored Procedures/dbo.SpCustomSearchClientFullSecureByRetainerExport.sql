SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureByRetainerExport]    
 @IndigoClientId bigint,     
 @SequentialRef varchar(50)=NULL,    
 @_UserId bigint,    
 @_TopN int = 0    
AS    
    
-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
DECLARE @LighthousePreExistingAdviceType bigint    
DECLARE @IsLimited bit    
    
SELECT @RightMask = 1, @AdvancedMask = 0    
SELECT @IsLimited=0    
SELECT @LighthousePreExistingAdviceType=3151    
    
    
IF ISNULL(@SequentialRef,'')<>''    
BEGIN    
 SET @SequentialRef='IOR' + RIGHT(REPLICATE('0',8) + @SequentialRef,8)    
END    
    
    
    
--For Lighthouse Limited Access to Advisers Who are members of a non-organisation group    
IF @IndigoClientId=213    
BEGIN    
 DECLARE @PositiveUserId bigint    
 SELECT @PositiveUserId=@_UserId    
 IF @_UserId<0     
 BEGIN    
  SELECT @PositiveUserId=@PositiveUserId * -1    
 END    
 DECLARE @OrgGroupId bigint,@UserGroupId bigint    
 SELECT @OrgGroupId=550    
 SELECT @UserGroupId=GroupId FROM Administration..TUser WHERE UserId=@PositiveUserId AND IndigoClientId=@IndigoClientId    
     
 IF @UserGroupId<>@OrgGroupId    
 BEGIN    
  SELECT @IsLimited=1    
 END     
    
END    
---------------------------------------------------------------------------------------    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT    
    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
    
    
     
    
SELECT    
   1 AS Tag,    
   NULL AS Parent,    
   T1.CRMContactId AS [CRMContact!1!CRMContactId],       
   T1.CRMContactType AS [CRMContact!1!CRMContactType],       
   ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],       
   ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],      
   ISNULL(T1.LastName, '') AS [CRMContact!1!LastName],       
   ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],       
   ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],       
   ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [CRMContact!1!ClientName],      
   ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!CRMContactLastNameCorporateName],      
   0 AS [CRMContact!1!PolicyBusinessId],      
   NULL AS [CRMContact!1!ChangedToDate],      
   NULL AS [CRMContact!1!PolicyNumber],      
   NULL AS [CRMContact!1!ProductName],      
   NULL AS [CRMContact!1!PolicyStatus],      
   NULL AS [CRMContact!1!PolicyType],      
   ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],      
   TR.SequentialRef AS [CRMContact!1!SequentialRef],  
    ISNULL(TAS.AddressLine1, '') AS [CRMContact!1!AddressLine1],  
	ISNULL(TAS.AddressLine2, '') AS [CRMContact!1!AddressLine2],  
	ISNULL(TAS.AddressLine3, '') AS [CRMContact!1!AddressLine3],  
	ISNULL(TAS.AddressLine4, '') AS [CRMContact!1!AddressLine4],  
	ISNULL(TAS.CityTown, '') AS [CRMContact!1!CityTown],  
	ISNULL(TAS.PostCode, '') AS [CRMContact!1!PostCode],  
	ISNULL(T15.CountyName, '') AS [CRMContact!1!County],  
	ISNULL(T16.CountryName, '') AS [CRMContact!1!Country],  
	ISNULL(T18.Title, '') AS [CRMContact!1!Title],  
	ISNULL(T19.Value, '') AS [CRMContact!1!Telephone],  
	ISNULL(T20.Value, '') AS [CRMContact!1!Mobile],  
	ISNULL(T21.Value, '') AS [CRMContact!1!Fax],  
	ISNULL(T22.Value, '') AS [CRMContact!1!E-Mail],  
	ISNULL(T23.Value, '') AS [CRMContact!1!Web],   
   CASE T1._OwnerId        
	 WHEN ABS(@_UserId) THEN 15        
	 ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
   END AS [CRMContact!1!_RightMask],        

   CASE T1._OwnerId        
	 WHEN ABS(@_UserId) THEN 240        
	 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
   END AS [CRMContact!1!_AdvancedMask]        
    
   From PolicyManagement..TRetainer TR WITH(NOLOCK)    
   JOIN PolicyManagement..TFeeRetainerOwner TFRO WITH(NOLOCK) ON TR.RetainerId=TFRO.RetainerId       
   JOIN CRM..TCRMContact T1 WITH(NOLOCK) ON TFRO.CRMContactId=T1.CRMContactId    
   -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
   LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId    
   LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId    
    
   LEFT JOIN  CRM..TAddress TA WITH(NOLOCK) ON TFRO.CRMContactId=TA.CRMContactId AND DefaultFg=1    
   LEFT JOIN CRM..TAddressStore TAS WITH(NOLOCK) ON TA.AddressStoreId=TAS.AddressStoreId    
   LEFT JOIN CRM..TRefCounty T15 WITH(NOLOCK) ON TAS.RefCountyId=T15.RefCountyId
   LEFT JOIN CRM..TRefCountry T16 WITH(NOLOCK) ON TAS.RefCountyId=T16.RefCountryId
   LEFT JOIN TPerson T18 WITH(NOLOCK) ON T18.PersonId = T1.PersonId  
   LEFT JOIN TContact T19 WITH(NOLOCK) ON T19.CRMContactId = T1.CRMContactId AND T19.DefaultFG = 1 AND T19.RefContactType = 'Telephone'  
   LEFT JOIN TContact T20 WITH(NOLOCK) ON T20.CRMContactId = T1.CRMContactId AND T20.DefaultFG = 1 AND T20.RefContactType = 'Mobile'  
   LEFT JOIN TContact T21 WITH(NOLOCK) ON T21.CRMContactId = T1.CRMContactId AND T21.DefaultFG = 1 AND T21.RefContactType = 'Fax'  
   LEFT JOIN TContact T22 WITH(NOLOCK) ON T22.CRMContactId = T1.CRMContactId AND T22.DefaultFG = 1 AND T22.RefContactType = 'E-Mail'  
   LEFT JOIN TContact T23 WITH(NOLOCK) ON T23.CRMContactId = T1.CRMContactId AND T23.DefaultFG = 1 AND T23.RefContactType = 'Web Site'
     
   WHERE TR.IndigoClientId=@IndigoClientId    
   AND TFRO.IndigoClientId=@IndigoClientId    
   AND TR.SequentialRef=@SequentialRef    
   AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))    
    
     
   ORDER BY [CRMContact!1!CRMContactLastNameCorporateName] ASC, [CRMContact!1!FirstName] ASC    
     
   FOR XML EXPLICIT    
    
   IF (@_TopN > 0) SET ROWCOUNT 0    
    
RETURN (0)  
GO
