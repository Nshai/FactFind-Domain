SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetrieveMultiTiePlanTypesByLicenseType]  
	@IndigoClientId bigint,      
	@PractitionerId bigint,      
	@ProviderId bigint,     
	@WrapperPolicyBusinessId bigint = 0, -- Only passed in if we're adding a sub plan to an existing wrapper.
	@RegionCode varchar(2) = 'GB'
AS     
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-- internal use  
DECLARE @IsForWrapper bit = 0, 
	@WrapperProviderConfigId bigint, @WrapperPlanType bigint, @wrapperProvider bigint

IF @WrapperPolicyBusinessId > 0 BEGIN
	SET @IsForWrapper = 1

	SELECT
		@WrapperPlanType = P2P.RefPlanTypeId,
		@wrapperProvider = PDESC.RefProdProviderId
	FROM
		TPolicyBusiness PB
		JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
		JOIN TPlanDescription PDESC ON PDESC.PlanDescriptionId = PD.PlanDescriptionId
		JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PDESC.RefPlanType2ProdSubTypeId
	WHERE
		PB.IndigoClientId = @IndigoClientId
		AND PB.PolicyBusinessId = @WrapperPolicyBusinessId
		AND P2P.[RegionCode] = @RegionCode		
		  
	-- Get the setting for the main plan provider if is's a wrap provider  
	SELECT 
		@WrapperProviderConfigId = WrapperProviderId
	FROM   
		TWrapperProvider  
	WHERE  
		RefPlanTypeId = @WrapperPlanType
		AND RefProdProviderId = @wrapperProvider
END
  
SELECT DISTINCT  
	T4.RefPlanType2ProdSubTypeId,    
	T3.RefPlanTypeId,  
	T3.IsWrapperFg,        
	T3.PlanTypeName,    
	T5.ProdSubTypeName,    
	T3.PlanTypeName + ISNULL(' (' + T5.ProdSubTypeName + ')', '') AS DisplayName  
FROM 
	TRefPlanType T3  WITH(NOLOCK)  
    JOIN TRefPlanType2ProdSubType T4 WITH(NOLOCK) on T4.RefPlanTypeId = T3.RefPlanTypeId AND T4.IsArchived = 0    
         
	--Ptactitioners Licence Type  
	JOIN TRefLicenseTypeToRefPlanType2ProdSubType RPTLT WITH(NOLOCK) ON T4.RefPlanType2ProdSubtypeId=RPTLT.RefPlanType2ProdSubtypeId  
	JOIN Administration..TRefLicenseType RLT WITH(NOLOCK) on RLT.RefLicenseTypeId = RPTLT.RefLicenseTypeId       
	JOIN Administration..TROLE RL WITH(NOLOCK) ON RL.RefLicenseTypeId = RLT.RefLicenseTypeId    
	JOIN Administration..TUSER USR WITH(NOLOCK) ON USR.ActiveRole = RL.RoleId  
	JOIN CRM..TPractitioner PRAC WITH(NOLOCK) ON PRAC.CRMContactId= USR.CRMContactId AND PRAC.PractitionerId=@PractitionerId  
	          
	LEFT JOIN TProdSubType T5 WITH(NOLOCK) on T5.ProdSubTypeId = T4.ProdSubTypeId    
	JOIN Compliance..TGating T6 WITH(NOLOCK) on T6.RefPlanType2ProdSubTypeId = T4.RefPlanType2ProdSubTypeId  AND T6.PractitionerId = @PractitionerId   
	--make a join to adviser and multi tie mapping table to get correct provider details
	LEFT JOIN TMultiTieConfigToAdviser mta WITH(NOLOCK) ON mta.AdviserId = PRAC.PractitionerId        
	JOIN TMultiTie T7 WITH(NOLOCK) ON T7.RefPlanType2ProdSubTypeId = T4.RefPlanType2ProdSubTypeId 
		AND T7.RefProdProviderId = @ProviderId 
		AND T7.MultiTieConfigId = mta.MultiTieConfigId
WHERE 
	T3.RetireFg = 0
	AND (T3.SchemeType=0 OR T3.SchemeType=1)
	AND T4.[RegionCode] = @RegionCode
	AND T7.IndigoClientId = @IndigoClientId
	--then check TWrapperProvider table to see what we should return
	AND
	(
		@IsForWrapper = 0
		OR 
		(
			--main plan provider is a wrapper provider
			@IsForWrapper = 1 And
			T7.RefPlanType2ProdSubTypeId In
			(  
					Select
						b.RefPlanType2ProdSubTypeId
					From
						TWrapperProvider a WITH(NOLOCK)
						JOIN TWrapperPlanType b WITH(NOLOCK) on a.WrapperProviderId = b.WrapperProviderId
						JOIN TRefPlanType2ProdSubType c WITH(NOLOCK) on b.RefPlanType2ProdSubTypeId = c.RefPlanType2ProdSubTypeId
					Where
						a.WrapperProviderId = @WrapperProviderConfigId
						And c.IsArchived = 0
					Group By 
						b.RefPlanType2ProdSubTypeId
			)
		)
	)
ORDER BY DisplayName  
GO
