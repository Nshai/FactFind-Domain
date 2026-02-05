SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDashboardRetrieveClientPortfolio]
	@TenantId bigint,
	@cid bigint,
	@PortfolioByProtection int = 0
AS
BEGIN
	set transaction isolation level read uncommitted
	DECLARE @IndigoClientId bigint
	SET @IndigoCLientId = (SELECT IndClientId FROM CRM..TCRMContact where CRMContactId = @cid)

	DECLARE @PortfolioSummaryPlanTypes TABLE (PlanTypeName varchar(max), Category varchar(100), Value varchar(50))

	-- Get list of policy business ids (so we can use these in the derived tables)
	DECLARE @Plans TABLE (Id bigint PRIMARY KEY)
	INSERT INTO @Plans
	SELECT DISTINCT PolicyBusinessId
	FROM
		TPolicyOwner PO
		JOIN TPolicyBusiness Pb ON Pb.PolicyDetailId = PO.PolicyDetailId AND Pb.IndigoClientId = @IndigoClientId				
	WHERE
		PO.CRMContactId = @cid				

	SELECT A.PolicyBusinessId, Max(PlanValuationId) AS PlanValuationId
	into #work0
	FROM TPlanValuation A
	join @Plans B on A.PolicyBusinessId = B.id
	GROUP BY A.PolicyBusinessId

	SELECT A.PolicyBusinessId, SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue
	into #work1
	FROM PolicyManagement..TPolicyBusinessFund A
	join @Plans B on A.PolicyBusinessId = B.id
	GROUP BY A.PolicyBusinessId

	SELECT	PolicyBusinessId,	SUM(Amount) AS [Amount]
	into #work2
	FROM	FactFind..TAssets
	WHERE	CRMContactId = @cid
	GROUP BY	PolicyBusinessId

	SELECT CASE 
            WHEN ISNUMERIC(AttributeValue) = 1 THEN AttributeValue
            ELSE '0'
          END AS AmountReleased, pba.PolicyBusinessId
	into #work3
	FROM PolicyManagement..TPolicyBusinessAttribute pba
	JOIN PolicyManagement..TAttributeList2Attribute ala ON ala.AttributeList2AttributeId = pba.AttributeList2AttributeId
	JOIN PolicyManagement..TAttributelist al ON al.AttributeListId = ala.AttributeListId
	JOIN @Plans pb on pba.PolicyBusinessId = pb.id
	WHERE al.name = 'Amount Released'
	


	INSERT INTO @PortfolioSummaryPlanTypes
	SELECT 
			Rpt.PlanTypeName as PlanTypeName, Ffc.Identifier as Category,
			isnull(sum(CASE 
				-- Special case for Pension Term Assurance
				WHEN Rpt.PlanTypeName = 'Pension Term Assurance' THEN CASE WHEN Fund.FundValue IS NOT NULL OR Assets.Amount IS NOT NULL THEN ISNULL(Fund.FundValue, 0) + ISNULL(Assets.Amount, 0) ELSE COALESCE(Pv.PlanValue, PT.LifeCoverSumAssured, 0) END
				-- Special case for PHI
				WHEN Rpt.PlanTypeName LIKE 'Permanent Health%' THEN COALESCE(B.BenefitAmount, PT.LifeCoverSumAssured, 0)
				-- Other plans by category.
				WHEN Ffc.Identifier = 'Investments' OR Ffc.Identifier = 'Pensions' OR Ffc.Identifier = 'Other Assets' THEN CASE WHEN Fund.FundValue IS NOT NULL OR Assets.Amount IS NOT NULL THEN ISNULL(Fund.FundValue, 0) + ISNULL(Assets.Amount, 0) ELSE ISNULL(Pv.PlanValue, 0) END
				WHEN Ffc.Identifier = 'Protection' THEN COALESCE(PT.LifeCoverSumAssured, GI.SumAssured, 0)
				WHEN Ffc.Identifier = 'Mortgages' AND Rpt.PlanTypeName <> 'Equity Release' THEN -1 * isnull(M.LoanAmount,0)
				-- Special case for Equity Release   
				WHEN Ffc.Identifier = 'Mortgages' AND Rpt.PlanTypeName = 'Equity Release' THEN ISNULL(PAttr.AmountReleased, 0) 
			END),0) as Value
		FROM 
			TPolicyBusiness Pb
			JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
			JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1
			JOIN TStatus S ON S.StatusId = Sh.StatusId AND S.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')
			JOIN TPlanDescription PDesc ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
			JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId 
			JOIN TRefPlanType Rpt ON Rpt.RefPlanTypeId = P2P.RefPlanTypeId	 	
	 		JOIN Reporter..TPlanSetting Tps On Tps.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId
			JOIN Reporter..TRefPlanCategory Ffc ON Ffc.RefPlanCategoryId = Tps.RefPlanCategoryId
			LEFT JOIN #work0  AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId
			LEFT JOIN TPlanValuation Pv ON Pv.PlanValuationId = LastVal.PlanValuationId	
			LEFT JOIN TMortgage M ON M.PolicyBusinessId = Pb.PolicyBusinessId
			-- Fund Valuation
			LEFT JOIN #work1 AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId
			-- Assets
			LEFT JOIN #work2 AS Assets ON Assets.PolicyBusinessId = Pb.PolicyBusinessId		
			-- Benefits
			LEFT JOIN TProtection PT ON PT.PolicyBusinessId = PB.PolicyBusinessId
			LEFT JOIN TGeneralInsuranceDetail GI ON GI.ProtectionId = PT.ProtectionId
			LEFT JOIN TAssuredLife AL ON AL.ProtectionId = PT.ProtectionId AND AL.OrderKey = 1
			LEFT JOIN TBenefit B ON B.BenefitId = AL.BenefitId
		
			--Equity Release Plan Types
			LEFT JOIN #work3 PAttr ON PAttr.PolicyBusinessId = PB.PolicyBusinessId
		
		WHERE
			PB.PolicyBusinessId IN (SELECT Id FROM @Plans)
			AND Tps.TenantId = @TenantId
		GROUP BY 
			RPT.PlanTypeName, Ffc.Identifier
		

	IF @PortfolioByProtection = 1 BEGIN			
		SELECT PlanTypeName, Value
		FROM @PortfolioSummaryPlanTypes
		WHERE Category = 'Protection'	
		ORDER BY PlanTypeName
	END	

	ELSE
		--Section if for PortfolioSummay By Protection	
		SELECT PlanTypeName, Value
		FROM @PortfolioSummaryPlanTypes
		WHERE Category != 'Protection'
		ORDER BY PlanTypeName
	
end	
	
