SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date            Modifier               Issue Description
----            ---------              --------------------
20240722        Vijith M               SE-6797: Client Service Status to be added to Electronic Valuations Success report
20230807        Saumya Mercy Rajan     IOSE22-2431 Agency Status on Valuation Success Report
*/
CREATE PROCEDURE [dbo].[SpCustomRetrieveElectronicValuationsSecureForDataSet]
	@IndigoClientId int,
	@_UserId int,
	@GroupId int = NULL,
	@AdviserId int = NULL,
	@ClientId int = NULL,
	@RefProdProviderId int = NULL,
	@ValuationStatus varchar(16) = 'All'
AS
BEGIN

-- IP-48298 COmment to trigger SqlCompare

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
-- Declarations
DECLARE
	@SelectedGroup varchar(255),
	@TenantId bigint,
	@NotUnderAgency varchar(15) = 'NotUnderAgency',
	@UnderAgency_InformationOnly varchar(30) = 'UnderAgency_InformationOnly',
	@UnderAgency_ServicingAgent varchar(30) = 'UnderAgency_ServicingAgent',
	@NotSelected varchar(15) = 'NotSelected'
	
SET @TenantId = @IndigoClientId	

-- Get Group if specified
IF @GroupId IS NOT NULL
	SELECT @SelectedGroup = Identifier FROM Administration..TGroup WHERE GroupId = @GroupId

-- Default
SET @SelectedGroup = ISNULL(@SelectedGroup, 'Not Specified');

DECLARE @bulkValuationType INT = 2;

-- Find Advisers
IF OBJECT_ID('TEMPDB..#Advisers') IS NOT NULL DROP TABLE #Advisers
SELECT
	A.PractitionerId AS Id,
	A.PrimaryGroup AS Team,
	A.PractitionerName AS [Name]
INTO
	#Advisers	
FROM
	CRM..VwPractitionerWithGroups A
	-- Secure clause 
	LEFT JOIN CRM..VwPractitionerKeyByCreatorId TCKey WITH(NOLOCK) ON TCKey.UserId = @_UserId AND TCKey.CreatorId = A._OwnerId
	LEFT JOIN CRM..VwPractitionerKeyByEntityId TEKey WITH(NOLOCK) ON TEKey.UserId = @_UserId AND TEKey.EntityId = A.PractitionerId
WHERE
	A.IndigoClientId = @IndigoClientId
	AND (@_UserId < 0 OR (A._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))
	AND (@GroupId IS NULL OR (A.Group1 = @GroupId OR A.Group2 = @GroupId OR A.Group3 = @GroupId OR A.Group4 = @GroupId OR A.Group5 = @GroupId))
	AND (@AdviserId IS NULL OR A.PractitionerId = @AdviserId)
CREATE CLUSTERED INDEX IDX_MI_Advisers ON #Advisers(Id)

-- Find Last Valuation for each plan
IF OBJECT_ID('TEMPDB..#LastVal') IS NOT NULL DROP TABLE #LastVal	
SELECT 
   C.PolicyBusinessId, 
   MAX(C.ValRequestId) ValRequestId
INTO 
	#LastVal
FROM	
  (SELECT * FROM
    (SELECT 
	   PB.PolicyBusinessId,
	   MAX(vr.ValRequestId) ValRequestId	
	 FROM 	PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) 
	 JOIN #Advisers A ON A.Id = PB.PractitionerId
	 JOIN PolicyManagement..TValRequest VR WITH(NOLOCK) ON PB.PolicyBusinessId = VR.PolicyBusinessId
     WHERE
	    PB.IndigoClientId = @IndigoClientId 
     GROUP BY
	    PB.PolicyBusinessId
    ) A
  UNION ALL
  SELECT * FROM
   (SELECT 
	   PB.PolicyBusinessId,	
	   MAX(sv.ValRequestId) ValRequestId
    FROM  PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) 
	JOIN #Advisers A ON A.Id = PB.PractitionerId
	JOIN PolicyManagement..TValRequestSubPlan sv on sv.PolicyBusinessId = PB.PolicyBusinessId
    WHERE
	   PB.IndigoClientId = @IndigoClientId 
    GROUP BY
	   PB.PolicyBusinessId
   ) B
 ) C
GROUP BY
	C.PolicyBusinessId
	
CREATE INDEX IDX_MI_LastVal ON #LastVal(PolicyBusinessId) INCLUDE (ValRequestId)

IF OBJECT_ID('TEMPDB..#Plans') IS NOT NULL DROP TABLE #Plans	
SELECT 
	PB.PolicyBusinessId
	,MAX(PV.PlanValuationId) PlanValuationId
INTO 
	#Plans
FROM 
	(SELECT 
		DISTINCT PB.PolicyBusinessId
		FROM 
			PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) 
			JOIN PolicyManagement..TPlanValuation PV WITH(NOLOCK) ON PV.PolicyBusinessId = PB.PolicyBusinessId AND PV.RefPlanValueTypeId = @bulkValuationType
		WHERE
		PB.IndigoClientId = @IndigoClientId 
	) as PB
JOIN PolicyManagement..TPlanValuation PV WITH(NOLOCK) 
ON PV.PolicyBusinessId = PB.PolicyBusinessId

GROUP BY
	PB.PolicyBusinessId
OPTION ( OPTIMIZE FOR (@IndigoClientId = 13590)) --Optimize for NBS tenantId

-- Get Providers (building a list of lookups and mapped providers
IF OBJECT_ID('tempdb..#Providers') IS NOT NULL DROP TABLE #Providers
SELECT ProviderId
INTO #Providers
FROM 
(
	SELECT 
		 RefProdProviderId			ProviderId
		,MappedRefProdProviderId	MappedProviderId
	FROM 
		PolicyManagement..TValLookUp
	-- map the standard providers to themselves
	UNION ALL 
	SELECT 
		 RefProdProviderId			ProviderId
		,RefProdProviderId			MappedProviderId
	FROM PolicyManagement..TValProviderConfig
) AS A
WHERE
	@RefProdProviderId IS NULL 
OR	A.MappedProviderId = @RefProdProviderId


SELECT  
	@SelectedGroup AS [OrganisationalUnit],
	A.Team AS [Team],
	A.[Name] AS [SellingAdviser],
	C.FirstName AS [ClientFirstName],
	ISNULL(C.LastName, C.CorporateName) AS [ClientLastName],
	CONVERT(varchar(12), C.DOB, 103) AS [ClientDOB],
	CRMP.NINumber AS [ClientNINumber],
	Ad.PostCode AS [ClientPostCode],
	RppC.CorporateName AS [Provider],
	PB.SequentialRef AS [IOBReference],
	PB.PolicyNumber AS [PlanNumber],
	PTy.PlanTypeName AS [PlanType],
	CONVERT(varchar(12), VR.RequestedDate, 103) AS [ValuationDate],
	CONVERT(varchar(12), VExc.ExcludedDate, 103) AS [ExcludedDate],	
	CASE WHEN ValExcludedPlanId IS NOT NULL THEN ISNULL(c2.Firstname + ' ' + c2.Lastname, 'System') END AS [ExcludedBy],  
	VR.ValuationType AS [ValuationType],	
	CASE 
		WHEN VExc.ValExcludedPlanId IS NOT NULL THEN 'Excluded' 
		WHEN VR.PlanValuationId IS NOT NULL THEN 'Success' 
		ELSE 'Failure' 
	END AS [Status],
	--VRes.ErrorDescription AS [StatusReason] --change2
	CASE		
		WHEN VRes.ProviderErrorCode IS NOT NULL AND VRes.ProviderErrorDescription IS NOT NULL THEN VRes.ProviderErrorCode + ': ' + VRes.ProviderErrorDescription
		WHEN VRes.ProviderErrorCode IS NULL AND VRes.ProviderErrorDescription IS NOT NULL THEN VRes.ProviderErrorDescription
		WHEN VRes.ProviderErrorDescription IS NULL AND ISNULL(VRes.ErrorDescription, '') <> '' THEN VRes.ErrorDescription
		ELSE ''
		END AS [StatusReason],
	CASE
		WHEN PBE.AgencyStatus = @NotUnderAgency THEN 'Not Under Agency'
		WHEN PBE.AgencyStatus = @UnderAgency_InformationOnly THEN 'Under Agency - Information Only'
		WHEN PBE.AgencyStatus = @UnderAgency_ServicingAgent THEN 'Under Agency - Servicing Agent'
		WHEN PBE.AgencyStatus = @NotSelected THEN 'Not Selected'
		ELSE ''
		END AS [AgencyStatus],CRMSS.ServiceStatusName AS [ClientServiceStatus],
	CStatus.StatusName As PlanStatus
FROM 
	PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)
	JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON Pb.PolicyBusinessId=PBE.PolicyBusinessId
	JOIN #Advisers A ON A.Id = PB.PractitionerId
	JOIN PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = Pb.PolicyDetailId
	JOIN PolicyManagement..TPolicyOwner PO ON (PB.PolicyDetailId = PO.PolicyDetailId AND PO.PolicyOwnerId = (SELECT TOP 1 PolicyOwnerId FROM PolicyManagement..TPolicyOwner WHERE  PolicyDetailId =  PB.PolicyDetailId order by PolicyOwnerId asc) )
	JOIN PolicyManagement..TPlanDescription PlanD WITH(NOLOCK) ON PlanD.PlanDescriptionId = Pd.PlanDescriptionId
	JOIN PolicyManagement..TRefPlanType2ProdSubType Plan2Prod WITH(NOLOCK) ON Plan2Prod.RefPlanType2ProdSubTypeId = PlanD.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType PTy WITH(NOLOCK) ON PTy.RefPlanTypeId = Plan2Prod.RefPlanTypeId	
	JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PlanD.RefProdProviderId
	JOIN CRM..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId
	JOIN PolicyManagement..VwCurrentStatus CStatus WITH(NOLOCK) ON CStatus.PolicyBusinessId = PB.PolicyBusinessId
	JOIN #Providers VP ON VP.ProviderId = Rpp.RefProdProviderId
	-- Get the latest valuation request
	JOIN #LastVal AS VRLast ON VRLast.PolicyBusinessId = PB.PolicyBusinessId
	-- Get val request details
	LEFT JOIN PolicyManagement..TValRequest VR WITH(NOLOCK) ON VR.ValRequestId = VRLast.ValRequestId
	LEFT JOIN PolicyManagement..TValResponse VRes ON VRes.ValRequestId = VR.ValRequestId
	LEFT JOIN PolicyManagement..TValExcludedPlan VExc ON VExc.PolicyBusinessId = PB.PolicyBusinessId
    LEFT JOIN PolicyManagement..TPlanValuation PV WITH(NOLOCK) ON PV.PlanValuationId = ISNULL(VR.PlanValuationId,'')
	-- Client information
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON C.CRMContactId = PO.CRMContactId
	LEFT JOIN Reports..[VwAddress] Ad on ad.CRMContactId = c.CRMContactId
	LEFT JOIN CRM..TRefServiceStatus CRMSS on C.RefServiceStatusId = CRMSS.RefServiceStatusId
	LEFT JOIN CRM..TPerson CRMP WITH(NOLOCK) ON C.PersonId = CRMP.PersonId
	LEFT JOIN Administration..TUser U on U.UserId = VExc.ExcludedByUserId	
	LEFT JOIN CRM..TCRMContact c2 on c2.CRMContactId = u.CRMContactId
WHERE
    --VR.ValuationType = 'synchronous'
	CStatus.IntelligentOfficeStatusType NOT IN ('Off Risk', 'Deleted')
	AND (@ClientId IS NULL OR VR.CRMContactId = @ClientId)
	AND (@ValuationStatus = 'All' 
		OR (
			(@ValuationStatus = 'Success' AND VR.PlanValuationId IS NOT NULL) 
			OR (@ValuationStatus = 'Failure' AND VR.PlanValuationId IS NULL) 
			OR (@ValuationStatus = 'Excluded' AND VExc.ValExcludedPlanId IS Not NULL)
		)
	)
		
UNION ALL

--Now filter on @_UserId (Mandatory), @AdviserId, @ClientId, @ValuationStatus
		
SELECT  
	@SelectedGroup AS [OrganisationalUnit],
	A.Team AS [Team],
	A.[Name] AS [SellingAdviser],
	C.FirstName AS [ClientFirstName],
	ISNULL(C.LastName, C.CorporateName) AS [ClientLastName],
	CONVERT(varchar(12), C.DOB, 103) AS [ClientDOB],
	CRMP.NINumber AS [ClientNINumber],
	Ad.PostCode AS [ClientPostCode],
	RppC.CorporateName AS [Provider],
	PB.SequentialRef AS [IOBReference],
	PB.PolicyNumber AS [PlanNumber],
	PTy.PlanTypeName AS [PlanType],
	CONVERT(varchar(12), PV.WhoUpdatedDateTime, 103) AS [ValuationDate],
	NULL AS [ExcludedDate],	
	NULL AS [ExcludedBy],
    'Bulk' AS [ValuationType],
    'Success' AS [Status],
	NULL AS [ProviderStatusReason],
	CASE
	 WHEN PBE.AgencyStatus = @NotUnderAgency THEN 'Not Under Agency'
	 WHEN PBE.AgencyStatus = @UnderAgency_InformationOnly THEN 'Under Agency - Information Only'
	 WHEN PBE.AgencyStatus = @UnderAgency_ServicingAgent THEN 'Under Agency - Servicing Agent'
	 WHEN PBE.AgencyStatus = @NotSelected THEN 'Not Selected'
	 ELSE ''
	 END AS [AgencyStatus],CRMSS.ServiceStatusName AS [ClientServiceStatus],
	S.[Name] As PlanStatus
FROM 
    #Plans P
	JOIN PolicyManagement..TPolicyBusiness Pb ON P.PolicyBusinessId = Pb.PolicyBusinessId
	JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON Pb.PolicyBusinessId=PBE.PolicyBusinessId
    JOIN #Advisers A ON A.Id = PB.PractitionerId
	JOIN PolicyManagement..TPolicyDetail Pd ON Pd.PolicyDetailId = Pb.PolicyDetailId
    JOIN PolicyManagement..TPolicyOwner PO ON (PB.PolicyDetailId = PO.PolicyDetailId AND PO.PolicyOwnerId = (SELECT TOP 1 PolicyOwnerId FROM PolicyManagement..TPolicyOwner WHERE  PolicyDetailId =  PB.PolicyDetailId order by PolicyOwnerId asc) )
	JOIN PolicyManagement..TPlanDescription PlanD ON PlanD.PlanDescriptionId = Pd.PlanDescriptionId
	JOIN PolicyManagement..TRefPlanType2ProdSubType Plan2Prod ON Plan2Prod.RefPlanType2ProdSubTypeId = PlanD.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType PTy ON PTy.RefPlanTypeId = Plan2Prod.RefPlanTypeId	
	JOIN PolicyManagement..TRefProdProvider Rpp ON Rpp.RefProdProviderId = PlanD.RefProdProviderId
	JOIN CRM..TCRMContact RppC ON RppC.CRMContactId = Rpp.CRMContactId
    JOIN PolicyManagement..TPlanValuation PV WITH(NOLOCK) ON PV.PlanValuationId = P.PlanValuationId
	JOIN #Providers VP ON VP.ProviderId = Rpp.RefProdProviderId
	-- Client information
	JOIN CRM..TCRMContact C ON C.CRMContactId = PO.CRMContactId
	LEFT JOIN Reports..[VwAddress] Ad on Ad.CRMContactId = c.CRMContactId
	LEFT JOIN CRM..TPerson CRMP ON C.PersonId = CRMP.PersonId
	LEFT JOIN CRM..TRefServiceStatus CRMSS on C.RefServiceStatusId = CRMSS.RefServiceStatusId
	JOIN PolicyManagement.dbo.TStatusHistory SH ON Pb.PolicyBusinessId = SH.PolicyBusinessId
	JOIN PolicyManagement.dbo.TStatus S ON S.StatusId = SH.StatusId
WHERE
	 (@ClientId IS NULL OR PO.CRMContactId = @ClientId)
	AND (@ValuationStatus = 'All' OR @ValuationStatus = 'Success')

END
GO
