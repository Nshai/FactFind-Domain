SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchClientFullSecureByRetainer]
	(
		@IndigoClientId bigint,   
		@SequentialRef varchar(50)=NULL,  
		@_UserId bigint,  
		@_TopN int = 0  
	)

as      
      
-- User rights  
DECLARE @RightMask int, @AdvancedMask int  
DECLARE @LighthousePreExistingAdviceType bigint  
  
SELECT @RightMask = 1, @AdvancedMask = 0  
SELECT @LighthousePreExistingAdviceType=3151  
  
  
IF ISNULL(@SequentialRef,'')<>''  
BEGIN  
 SET @SequentialRef='IOR' + RIGHT(REPLICATE('0',8) + @SequentialRef,8)  
END  

---------------------------------------------------------------------------------------  
-- SuperViewers won't have an entry in the key table so we need to get their rights now  
IF @_UserId < 0  
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT  
  
-- Limit rows returned?  
IF (@_TopN > 0) SET ROWCOUNT @_TopN  
  
SELECT  
	T1.CRMContactId AS [PartyId],     
	T1.CRMContactType AS [CRMContactType],     
	ISNULL(T1.AdvisorRef, '') AS [AdvisorRef],     
	ISNULL(T1.CurrentAdviserName, '') AS [CurrentAdviserName],    
	ISNULL(T1.LastName, '') AS [LastName],     
	ISNULL(T1.FirstName, '') AS [FirstName],     
	ISNULL(T1.CorporateName, '') AS [CorporateName],     
	ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [ClientFullName],    
	CASE 
		WHEN ISNULL(t1.CorporateName,'') = '' THEN
			CASE 
				WHEN ISNULL(t1.LastName,'') = '' THEN ISNULL(t1.FirstName,'')
				ELSE 
					CASE 
						WHEN ISNULL(t1.FirstName,'') = '' THEN t1.LastName
						ELSE t1.LastName+', '+t1.FirstName
					END
			END
		ELSE t1.CorporateName
	END AS [ClientSortName],
	ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContactLastNameCorporateName],    
	0 AS [PolicyBusinessId],    
	NULL AS [ChangedToDate],    
	NULL AS [PolicyNumber],    
	NULL AS [ProductName],    
	NULL AS [PolicyStatus],    
	NULL AS [PolicyType],    
	ISNULL(T1.ExternalReference, '') AS [ExternalReference],  
	ISNULL(TAS.AddressLine1,'') as [AddressLine1],
	TR.SequentialRef AS [SequentialRef],  
	CASE T1._OwnerId      
	WHEN ABS(@_UserId) THEN 15      
	ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)      
	END AS [_RightMask],      
	CASE T1._OwnerId      
	WHEN ABS(@_UserId) THEN 240      
	ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)       
	END AS [_AdvancedMask]      
  
   From PolicyManagement..TRetainer TR WITH(NOLOCK)  
   JOIN PolicyManagement..TFeeRetainerOwner TFRO WITH(NOLOCK) ON TR.RetainerId=TFRO.RetainerId  
   --JOIN PolicyManagement..TRefFeeType TFT WITH(NOLOCK) ON TF.RefFeeTypeId=TFT.RefFeeTypeId  
   JOIN CRM..TCRMContact T1 WITH(NOLOCK) ON TFRO.CRMContactId=T1.CRMContactId  
   -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)  
   LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId  
   LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId  
  
       LEFT JOIN  CRM..TAddress TA WITH(NOLOCK) ON TFRO.CRMContactId=TA.CRMContactId AND DefaultFg=1  
   LEFT JOIN CRM..TAddressStore TAS WITH(NOLOCK) ON TA.AddressStoreId=TAS.AddressStoreId  
   
   WHERE TR.IndigoClientId=@IndigoClientId  
   AND TFRO.IndigoClientId=@IndigoClientId  
   AND TR.SequentialRef=@SequentialRef  
   AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))  
  
   
   ORDER BY [CRMContactLastNameCorporateName] ASC, [FirstName] ASC  
   
   IF (@_TopN > 0) SET ROWCOUNT 0
GO
