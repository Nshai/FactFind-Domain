SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_RetreiveClientGroupSchemeFinancialOverviewTop10]
	@CorporateClientId INT ,
	@TenantId INT 
AS



DECLARE @INTELLIGENTOFFICE_STATUS_INFORCE Varchar(100) = 'In force'

Declare @SchemesForClient Table ([Type] varchar(20), GroupSchemeId int, PolicyBusinessId int, OwnerCRMContactId int, SchemeName varchar(500), 
								ProviderName varchar(500), AnnualisedCurrentPrem varchar(50), EmployerFees varchar(50), MemberFees varchar(50))
INSERT INTO @SchemesForClient
	SELECT 	Distinct 
		'Group Scheme',
		A.GroupSchemeId,
		A.PolicyBusinessId, 
		A.OwnerCRMContactId,
		A.SchemeName, 
		provcon.CorporateName AS ProviderName,
		NULL, 
		NULL ,
		NULL
			
	FROM TGroupScheme A with (nolock)
	INNER JOIN TPolicyBusiness pb with (nolock) ON A.PolicyBusinessId = pb.PolicyBusinessId
	INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
	INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
	INNER JOIN TPolicyDetail pd with (nolock) on pb.PolicyDetailId = pd.PolicyDetailId
	INNER JOIN TPlanDescription pdesc with (nolock) on pd.PlanDescriptionId = pdesc.PlanDescriptionId
	INNER JOIN TRefProdProvider prov with (nolock) on pdesc.RefProdProviderId = prov.RefProdProviderId
	INNER JOIN CRM..TCRMContact provcon with (nolock) ON prov.CRMContactId = provcon.CRMContactId
	INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId
	
	WHERE  A.TenantId = @TenantId
	AND pb.IndigoClientId = @TenantId
	AND s.IndigoClientId = @TenantId
	AND C.IndClientId = @TenantId
	AND C.CorporateId IS NOT NULL -- must me a corporate client only
	AND A.OwnerCRMContactId = @CorporateClientId 
	AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
	GROUP BY A.GroupSchemeId, A.PolicyBusinessId,OwnerCRMContactId, A.SchemeName, 
		provcon.CorporateName
	

	UPDATE A
	SET A.AnnualisedCurrentPrem = B.AnnualisedCurrentPrem
	FROM @SchemesForClient A
	INNER JOIN
	(		
		SELECT GroupSchemeId, SUM(A.AnnualisedCurrentPrem)  as AnnualisedCurrentPrem -- Total for Group SCheme
		FROM
		(
			SELECT A.GroupSchemeId, 
				pmi.PolicyBusinessId,
				SUM(
					CASE
						WHEN RefFrequencyId = 1 THEN 52 * Amount -- Weekly
						WHEN RefFrequencyId = 2 THEN 26 * Amount -- Fortnightly
						WHEN RefFrequencyId = 3 THEN 13 * Amount -- Four weekly
						WHEN RefFrequencyId = 4 THEN 12 * Amount -- Monthly
						WHEN RefFrequencyId = 5 THEN 4 * Amount  -- Quarterly
						WHEN RefFrequencyId = 6 THEN 3 * Amount  -- Termly
						WHEN RefFrequencyId = 7 THEN 2 * Amount  -- BiAnnually
						WHEN RefFrequencyId = 8 THEN Amount      -- Annually
					END
				)	AS AnnualisedCurrentPrem -- Total For Master Plan

			FROM TGroupScheme A with (nolock)
			INNER JOIN TPolicyBusiness pb with (nolock) ON A.PolicyBusinessId = pb.PolicyBusinessId
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId
			INNER JOIN policymanagement..TPolicyMoneyIn pmi with (nolock) ON pb.PolicyBusinessId = pmi.PolicyBusinessId -- master plan Premium / contribution
			WHERE  A.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND C.CorporateId IS NOT NULL -- must me a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, pmi.PolicyBusinessId
				
					
			UNION

			Select A.GroupSchemeId, 
				pmi.PolicyBusinessId,
				SUM(
					CASE
						WHEN RefFrequencyId = 1 THEN 52 * Amount -- Weekly
						WHEN RefFrequencyId = 2 THEN 26 * Amount -- Fortnightly
						WHEN RefFrequencyId = 3 THEN 13 * Amount -- Four weekly
						WHEN RefFrequencyId = 4 THEN 12 * Amount -- Monthly
						WHEN RefFrequencyId = 5 THEN 4 * Amount  -- Quarterly
						WHEN RefFrequencyId = 6 THEN 3 * Amount  -- Termly
						WHEN RefFrequencyId = 7 THEN 2 * Amount  -- BiAnnually
						WHEN RefFrequencyId = 8 THEN Amount      -- Annually
					END
				)	AS AnnualisedCurrentPrem -- Total Per Member Plan

			FROM TGroupScheme A with (nolock)
			INNER JOIN TGroupSchemeMember B ON A.GroupSchemeId = B.GroupSchemeId
			INNER JOIN TPolicyBusiness pb with (nolock) ON B.PolicyBusinessId = pb.PolicyBusinessId -- member policies
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId

			INNER JOIN policymanagement..TPolicyMoneyIn pmi with (nolock)  ON pb.PolicyBusinessId = pmi.PolicyBusinessId -- member plan Premium / contribution

			WHERE  A.TenantId = @TenantId
			AND B.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND C.CorporateId IS NOT NULL -- must me a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, pmi.PolicyBusinessId			
		
		) A GROUP BY A.GroupSchemeId

	) B ON A.GroupSchemeId = B.GroupSchemeId





	UPDATE A -- Employer Fees / Member Fees
	SET A.EmployerFees = B.EmployerFeesTotal, A.MemberFees = B.MemberFeesTotal
	FROM @SchemesForClient A
	INNER JOIN
	(		
		SELECT GroupSchemeId, SUM(A.EmployerFeesTotal)  as EmployerFeesTotal, Sum(MemberFeesTotal) AS MemberFeesTotal -- Total for Group SCheme
		FROM
		(
			SELECT A.GroupSchemeId, ftp.PolicyBusinessId, SUM(GrossAmountReceived) AS EmployerFeesTotal, 0 AS MemberFeesTotal  -- Client Paid Fees for employer plan
			FROM TGroupScheme A with (nolock)
			INNER JOIN TPolicyBusiness pb with (nolock) ON A.PolicyBusinessId = pb.PolicyBusinessId -- Master PLan
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId
			INNER JOIN policymanagement..TFee2Policy ftp with (nolock) ON pb.PolicyBusinessId = ftp.PolicyBusinessId -- master plan Premium / contribution
			INNER JOIN commissions..TPaymentSummary ps with(nolock) ON ftp.FeeId = ps.FeeId -- Client Paid Fees ONLY			
			WHERE  A.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND ps.TenantId = @TenantId
			AND C.CorporateId IS NOT NULL -- must be a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, ftp.PolicyBusinessId

			UNION

			SELECT A.GroupSchemeId, ftp.PolicyBusinessId, SUM(GrossAmountReceived) AS EmployerFeesTotal, 0 AS MemberFeesTotal  -- Provider Paid Fees for Employer PLan
			FROM TGroupScheme A with (nolock)
			INNER JOIN TPolicyBusiness pb with (nolock) ON A.PolicyBusinessId = pb.PolicyBusinessId-- Master PLan
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId

			INNER JOIN policymanagement..TFee2Policy ftp with (nolock) ON pb.PolicyBusinessId = ftp.PolicyBusinessId -- master plan Premium / contribution
			INNER JOIN commissions..TPaymentSummary ps with(nolock) ON ftp.PolicyBusinessId = ps.PolicyId AND ftp.FeeId = ps.LinkedFeeId -- Provider Paid Fees ONLY (policy and fee id important)
			
			WHERE  A.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND ps.TenantId = @TenantId
			AND C.CorporateId IS NOT NULL -- must be a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, ftp.PolicyBusinessId
				
					
			UNION


			SELECT A.GroupSchemeId, ftp.PolicyBusinessId, 0 AS EmployerFeesTotal, SUM(GrossAmountReceived) AS MemberFeesTotal -- Client Paid Fees for member plans
			FROM TGroupScheme A with (nolock)
			INNER JOIN TGroupSchemeMember B ON A.GroupSchemeId = B.GroupSchemeId -- Members
			INNER JOIN TPolicyBusiness pb with (nolock) ON B.PolicyBusinessId = pb.PolicyBusinessId -- Member plans
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId

			INNER JOIN policymanagement..TFee2Policy ftp with (nolock) ON pb.PolicyBusinessId = ftp.PolicyBusinessId -- Member plan Premium / contribution
			INNER JOIN commissions..TPaymentSummary ps with(nolock) ON ftp.FeeId = ps.FeeId -- Client Paid Fees ONLY
			
			WHERE  A.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND ps.TenantId = @TenantId
			AND C.CorporateId IS NOT NULL -- must be a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, ftp.PolicyBusinessId



			UNION


			SELECT A.GroupSchemeId, ftp.PolicyBusinessId, 0 AS EmployerFeesTotal , SUM(GrossAmountReceived)AS MemberFeesTotal  -- Provider Paid Fees for member plans
			FROM TGroupScheme A with (nolock)
			INNER JOIN TGroupSchemeMember B ON A.GroupSchemeId = B.GroupSchemeId -- Members
			INNER JOIN TPolicyBusiness pb with (nolock) ON B.PolicyBusinessId = pb.PolicyBusinessId -- Member plans
			INNER JOIN TStatusHistory sh with(nolock) ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			INNER JOIN TStatus s with(nolock) ON sh.StatusId = s.StatusId
			INNER JOIN CRM..TCRMContact C with (nolock) on A.OwnerCRMContactId = C.CRMContactId

			INNER JOIN policymanagement..TFee2Policy ftp with (nolock) ON pb.PolicyBusinessId = ftp.PolicyBusinessId -- Member plan Premium / contribution
			INNER JOIN commissions..TPaymentSummary ps with(nolock) ON ftp.PolicyBusinessId = ps.PolicyId AND ftp.FeeId = ps.LinkedFeeId -- Provider Paid Fees ONLY (policy and fee id important)
			
			WHERE  A.TenantId = @TenantId
			AND pb.IndigoClientId = @TenantId
			AND s.IndigoClientId = @TenantId
			AND C.IndClientId = @TenantId
			AND ps.TenantId = @TenantId
			AND C.CorporateId IS NOT NULL -- must be a corporate client only
			AND A.OwnerCRMContactId = @CorporateClientId 
			AND s.IntelligentOfficeStatusType = @INTELLIGENTOFFICE_STATUS_INFORCE
			GROUP BY A.GroupSchemeId, ftp.PolicyBusinessId		
		
		) A GROUP BY A.GroupSchemeId

	) B ON A.GroupSchemeId = B.GroupSchemeId
	
	


SELECT TOP 10 
	[Type], GroupSchemeId, PolicyBusinessId, OwnerCRMContactId, SchemeName, ProviderName , 
	CASE WHEN AnnualisedCurrentPrem IS NOT NULL 
		THEN CONVERT(varchar(50), ISNULL(AnnualisedCurrentPrem, '0'))
		ELSE ''
	END AS AnnualisedCurrentPrem,
	CASE WHEN EmployerFees IS NOT NULL 
		THEN CONVERT(varchar(50), ISNULL(EmployerFees, '0'))
		ELSE ''
	END AS EmployerFees,
	CASE WHEN MemberFees IS NOT NULL 
		THEN CONVERT(varchar(50), ISNULL(MemberFees, '0'))
		ELSE ''
	END AS MemberFees
  FROM  @SchemesForClient 
  ORDER BY Convert(decimal(16,2), AnnualisedCurrentPrem) DESC