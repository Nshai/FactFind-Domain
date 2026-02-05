SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_RetreiveClientGroupSchemeMembershipTop10]
	@CorporateClientId INT ,
	@TenantId INT ,
	@TotalEmployees DECIMAL(10,2) ,
	@CurrentUserDate datetime
AS

DECLARE @INTELLIGENTOFFICE_STATUS_INFORCE Varchar(100) = 'In force'

DECLARE @Leavers TABLE (GroupSchemeId INT, LeaversPostRenewal INT)

INSERT INTO @Leavers -- < 1000 on PROD DB
SELECT 
	D.GroupSchemeId, 
	COUNT(GroupSchemeMemberId) as [LeaversPostRenewal]
FROM TGroupScheme A
INNER JOIN TGroupSChemeMember D with (nolock) ON A.GroupSchemeId = D.GroupSchemeId
INNER JOIN CRM..tcrmcontact C with (nolock) ON A.OwnerCRMContactId = C.CRMContactId
WHERE A.TenantId = @TenantId
	AND D.TenantId = @TenantId 
	AND C.IndClientId = @TenantId
	AND C.CorporateId IS NOT NULL 
	AND A.OwnerCRMContactId = @CorporateClientId
	AND D.LeavingDate IS NOT NULL
	AND D.LeavingDate >= ISNULL(A.RenewalDate, DATEADD(yy, -1, @CurrentUserDate))
GROUP BY D.GroupSchemeId

SELECT TOP 10 * FROM
(

		SELECT TOP 10 
			'Group Scheme' AS [Type],
			A.GroupSchemeId,
			A.PolicyBusinessId, 
			A.OwnerCRMContactId,
			A.SchemeName, 
			provcon.CorporateName AS ProviderName,
			COUNT( DISTINCT D.GroupSchemeMemberId) AS [SchemeMembers],
			CONVERT(VARCHAR(50), CAST(ROUND(((COUNT( DISTINCT D.GroupSchemeMemberId) / @TotalEmployees) * 100), 2) AS DECIMAL(15,2))) + '%'  AS [PercentageCovered],
			ISNULL(CONVERT(VARCHAR(50),leavers.LeaversPostRenewal), '') AS LeaversPostRenewal
		
		FROM TGroupScheme A with (nolock)
		INNER JOIN TPolicyBusiness pb with (nolock) ON A.PolicyBusinessId = pb.PolicyBusinessId
		INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
		INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
		INNER JOIN TPolicyDetail pd with (nolock) on pb.PolicyDetailId = pd.PolicyDetailId
		INNER JOIN TPlanDescription pdesc with (nolock) on pd.PlanDescriptionId = pdesc.PlanDescriptionId
		INNER JOIN TRefProdProvider prov with (nolock) on pdesc.RefProdProviderId = prov.RefProdProviderId
		INNER JOIN CRM..TCRMContact provcon with (nolock) ON prov.CRMContactId = provcon.CRMContactId
		INNER JOIN TGroupSchemeMember D with (nolock) ON A.GroupSchemeId = D.GroupSchemeId
		INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId
		LEFT JOIN @Leavers leavers ON A.GroupSchemeId = leavers.GroupSchemeId		

		WHERE  A.TenantId = @TenantId
		AND pb.IndigoClientId = @TenantId
		AND s.IndigoClientId = @TenantId
		AND C.IndClientId = @TenantId
		AND C.CorporateId IS NOT NULL -- must me a corporate client only
		AND A.OwnerCRMContactId = @CorporateClientId 
		AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
		AND D.IsLeaver = 0 
		GROUP BY A.GroupSchemeId, A.PolicyBusinessId,OwnerCRMContactId, A.SchemeName, 
			provcon.CorporateName, leavers.LeaversPostRenewal
		HAVING COUNT(A.OwnerCRMContactId) > 0
		ORDER BY COUNT( DISTINCT D.GroupSchemeMemberId) DESC, A.OwnerCRMContactId
	
	UNION
	
		SELECT TOP 10 
			'Fact Find' AS [Type],
			NULL AS GroupSchemeId,
			NULL AS PolicyBusinessId, 
			A.CRMContactId,
			A.Benefit, 
			A.Insurer,
			CASE ISNUMERIC(NumberOfEmployees) 
				WHEN 1 THEN CONVERT(INT,NumberOfEmployees)
				ELSE NULL
			END AS [SchemeMembers],
			CASE ISNUMERIC(NumberOfEmployees) 
				WHEN 1 THEN CONVERT(varchar(50), CAST(ROUND(((CONVERT(DECIMAL(15,2),NumberOfEmployees) / @TotalEmployees) * 100), 2) AS DECIMAL(15,2))) + '%'
				ELSE ''
			END AS [PercentageCovered],
			'' AS LeaversPostRenewal	
		FROM factfind..TEmployeeBenefit A
		WHERE CRMContactId = @CorporateClientId 
		ORDER BY [SchemeMembers] DESC
) AS A
ORDER by [SchemeMembers] DESC