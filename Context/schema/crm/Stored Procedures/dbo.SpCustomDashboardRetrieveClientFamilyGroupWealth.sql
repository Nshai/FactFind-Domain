SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveClientFamilyGroupWealth]
(
   @CrmContactId INT
)
AS
BEGIN

    DECLARE @TenantId INT, @HeadOfFamilyGroup VARCHAR(250) = '', @FamilyGroupAssets decimal(21,6), @FamilyGroupLiabilities decimal(21,6), @HeadOfFamilyGroupCRMContactId INT
	DECLARE @RegionalCurrency NCHAR(3)
	DECLARE @HasPlanInAlternativeCurrency bit = 0

	SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

    SELECT @TenantId = IndClientId FROM crm.dbo.TCRMContact WHERE CRMContactId = @CrmContactId

	DECLARE @Rates TABLE (CurrencyCode nchar(3), Rate decimal(21,6))
    DECLARE @FamilyGroupTempTable TABLE (CRMContactId INT, ClientName VARCHAR(255), IsHeadOfFamilyGroup BIT)
    DECLARE @ClientAssets TABLE(
        Id INT,
        Owner1Id INT,
        Owner1FirstName varchar(100),
        Owner1FullName varchar(200),
        Owner2Id INT,
        Owner2FirstName varchar(100),
        Owner2FullName varchar(200),
        OwnerType varchar(100),
        OwnerFilter VARCHAR(20),
        Category varchar(100),
        IMASector varchar(100),
        [Description] varchar(MAX),
        PurchaseDate  datetime,
        OriginalValue decimal(21,6),
        Value decimal(21,6),
        ValueDate datetime,
        ProfitLoss decimal(21,6),
        ProfitLossPercent decimal(21,6),
        RelatedPlanId INT NULL,
        WhoCreatedUserId INT NULL,
        IsVisibleToClient bit
    )

    --GET Group Of Family--
    ------------------------------------------------------
    INSERT INTO @FamilyGroupTempTable
    EXEC crm.[dbo].[SpRetrieveFamilyGroupByCRMContactId] @CrmContactId=@CrmContactId, @TenantId = @TenantId
    ------------------------------------------------------

    --If Group Of Family does not exist, return Empty values--
    ------------------------------------------------------
    IF NOT EXISTS (SELECT TOP 1 * FROM @FamilyGroupTempTable)
    BEGIN
    SELECT @HeadOfFamilyGroup AS HeadOfFamilyGroup,
    @FamilyGroupAssets AS  FamilyGroupAssets,
    @FamilyGroupLiabilities AS FamilyGroupLiabilities,
    @HeadOfFamilyGroupCRMContactId AS HeadOfFamilyGroupCRMContactId,
	@HasPlanInAlternativeCurrency AS HasPlanInAlternativeCurrency
    END
    ------------------------------------------------------
    ELSE

    BEGIN

        DECLARE @PlansTempTable TABLE (PolicyBusinessId INT, RefPlanTypeId INT, IsWrapperFg BIT, RefTotalPlanValuationTypeId INT, PlanValue decimal(21,6), ParentPolicyBusinessId INT, CurrencyCode nchar(3))


        ---------------------------------------------------------------------------------------
        -- Get plan list for Group Of Family or additional owner with current status = 'In force' OR = 'Paid Up'--
        ---------------------------------------------------------------------------------------
        ;WITH FilteredPolicBusinesses
        AS
        (
            SELECT PB.PolicyDetailId, PB.PolicyBusinessId, PB.BaseCurrency AS CurrencyCode
                FROM policymanagement.dbo.TPolicyOwner AS PO
                INNER JOIN @FamilyGroupTempTable ON [@FamilyGroupTempTable].CRMContactId = PO.CRMContactId
                INNER JOIN policymanagement.dbo.TPolicyBusiness AS PB ON PB.PolicyDetailId = PO.PolicyDetailId
            UNION
            SELECT PB.PolicyDetailId, PB.PolicyBusinessId, PB.BaseCurrency
                FROM  policymanagement.dbo.TAdditionalOwner AS AO
                INNER JOIN @FamilyGroupTempTable ON [@FamilyGroupTempTable].CRMContactId = AO.CRMContactId
                INNER JOIN policymanagement.dbo.TPolicyBusiness AS PB ON PB.PolicyBusinessId = AO.PolicyBusinessId
        )
        INSERT INTO @PlansTempTable
        SELECT PB.PolicyBusinessId, refPlanType.RefPlanTypeId, refPlanType.IsWrapperFg, pbpvt.RefTotalPlanValuationTypeId, NULL AS PlanValue, wpb.ParentPolicyBusinessId, PB.CurrencyCode
        FROM FilteredPolicBusinesses AS PB
        INNER JOIN policymanagement.dbo.TPolicyDetail AS PD ON PD.PolicyDetailId = PB.PolicyDetailId
        INNER JOIN policymanagement.dbo.TPlanDescription PDD ON PDD.PlanDescriptionId = PD.PlanDescriptionId
        INNER JOIN policymanagement.dbo.TRefPlanType2ProdSubType AS PT2 ON PT2.RefPlanType2ProdSubTypeId = PDD.RefPlanType2ProdSubTypeId
        INNER JOIN policymanagement.dbo.TRefPlanType AS refPlanType ON refPlanType.RefPlanTypeId = PT2.RefPlanTypeId
        INNER JOIN policymanagement.dbo.TStatusHistory AS statusH ON statusH.PolicyBusinessId = PB.PolicyBusinessId AND statusH.CurrentStatusFG = 1
        INNER JOIN policymanagement.dbo.TStatus AS status ON status.StatusId = statusH.StatusId AND (status.Name = 'In force' OR status.Name = 'Paid Up')
        LEFT JOIN policymanagement.dbo.TWrapperPolicyBusiness wpb ON wpb.PolicyBusinessId = pb.PolicyBusinessId
        LEFT JOIN policymanagement.dbo.[TPolicyBusinessTotalPlanValuationType] pbpvt ON pbpvt.PolicyBusinessId = pb.PolicyBusinessId
		---------------------------------------------------------------------------------------
        -- Get client assets
        ---------------------------------------------------------------------------------------
		INSERT  @ClientAssets
		EXEC [policymanagement].[dbo].[nio_PS_GetAllAssetsForClient] @CrmContactId, @TenantId,1,1

        ---------------------------------------------------------------------------------------
        -- Calculate Plan Values
        ---------------------------------------------------------------------------------------
		DECLARE @AssetsTempTable TABLE (PolicyBusinessId INT, AssetsId INT, CurrencyCode nchar(3), Amount decimal(21,6), AlternativeCurrencyFg int)

		;WITH AssetsTable (CurrencyCode, Value, AlternativeCurrencyFg)
		AS (
			SELECT CurrencyCode, SUM(Value), IIF(A.CurrencyCode != @RegionalCurrency, 1, 0)
			FROM @ClientAssets CA
			JOIN factfind..TAssets A ON A.AssetsId = CA.Id
			WHERE CA.RelatedPlanId IS NULL AND Value != 0 AND Value IS NOT NULL 
			GROUP BY A.CurrencyCode
		)
		INSERT INTO @AssetsTempTable
		SELECT ta.PolicyBusinessId, ta.AssetsId, ta.CurrencyCode, ta.Amount, NULL
		FROM FactFind.dbo.tAssets ta
		JOIN @PlansTempTable cp ON ta.PolicyBusinessId = cp.PolicyBusinessId
		UNION
		SELECT NULL, NULL, a.CurrencyCode, a.Value, a.AlternativeCurrencyFg
		FROM AssetsTable a

		INSERT INTO @Rates
		SELECT CR.CurrencyCode, policymanagement.dbo.FnGetCurrencyRate(CR.CurrencyCode, @RegionalCurrency) AS Rate
		FROM administration.dbo.TCurrencyRate CR
		JOIN (
			SELECT DISTINCT CurrencyCode FROM @PlansTempTable
			UNION 
			SELECT DISTINCT CurrencyCode FROM @AssetsTempTable
		) CC ON CC.CurrencyCode = CR.CurrencyCode AND CR.IndigoClientId = 0

        -- Valuations
        DECLARE @PlanValuations TABLE (PolicyBusinessId INT, PlanValuation decimal(21,6));

        INSERT INTO @PlanValuations (PolicyBusinessId, PlanValuation)
        SELECT p.PolicyBusinessId, PolicyManagement.dbo.[FnCustomGetPlanValuationFromValuationTab](p.PolicyBusinessId) * r.Rate
        FROM @PlansTempTable p
		JOIN @Rates r ON p.CurrencyCode = r.CurrencyCode;

        -- Funds
        DECLARE @PlanFunds TABLE (PolicyBusinessId INT, TotalValue decimal(21,6));

        INSERT INTO @PlanFunds (PolicyBusinessId, TotalValue)
        SELECT funds.PolicyBusinessId, SUM(funds.TotalValue) AS TotalValue --Groupping Funds Total value per PolicyBusiness
        FROM (
            SELECT -- funds price
                tpbf.PolicyBusinessId,
                ISNULL(tpbf.CurrentPrice * tpbf.CurrentUnitQuantity * r.Rate, 0) AS TotalValue
            FROM PolicyManagement.dbo.TPolicyBusinessFund tpbf
            JOIN @PlansTempTable cp ON cp.PolicyBusinessId = tpbf.PolicyBusinessId
            JOIN @Rates r ON cp.CurrencyCode = r.CurrencyCode
            WHERE tpbf.CurrentUnitQuantity <> 0
            UNION ALL
            SELECT -- asset amount
                ta.PolicyBusinessId,
                ISNULL(ta.amount * r.Rate, 0) TotalValue
            FROM @AssetsTempTable ta
            JOIN @Rates r ON ta.CurrencyCode = r.CurrencyCode
			WHERE ta.PolicyBusinessId IS NOT NULL
        ) funds
        GROUP BY funds.PolicyBusinessId;

        -- Calculate plan values
        UPDATE cp
        SET cp.PlanValue = IIF(pv.PolicyBusinessId IS NOT NULL, pv.PlanValuation, pf.TotalValue)
        FROM @PlansTempTable cp
        LEFT JOIN @PlanValuations pv ON pv.PolicyBusinessId = cp.PolicyBusinessId
        LEFT JOIN @PlanFunds pf ON pf.PolicyBusinessId = cp.PolicyBusinessId;
		
        -- Wrappers
        DECLARE @PlansHierarchy TABLE
        (
            ParentPolicyBusinessId INT,
            PolicyBusinessId INT,
            IsWrapperFg BIT,
            RefTotalPlanValuationTypeId INT,
            [Level] INT,
            MasterPlanId INT,
            PlanValue decimal(21,6),
            IsLeaf BIT
        );

        ;WITH PlansHierarchy
        AS
        (
            -- Master Plans
            SELECT
                cp.ParentPolicyBusinessId,
                cp.PolicyBusinessId,
                cp.IsWrapperFg,
                cp.RefTotalPlanValuationTypeId,
                0 AS [Level],
                cp.PolicyBusinessId AS MasterPlanId,
                cp.PlanValue
            FROM @PlansTempTable cp
            WHERE
                cp.IsWrapperFg = 1 AND cp.ParentPolicyBusinessId IS NULL
            -- Sub Pluns hierarchy
            UNION ALL
            SELECT
                 wpb.ParentPolicyBusinessId
                ,cp.PolicyBusinessId
                ,cp.IsWrapperFg
                ,cp.RefTotalPlanValuationTypeId
                ,p.[Level] + 1 AS [Level]
                ,p.MasterPlanId
                ,cp.PlanValue
            FROM policymanagement.dbo.TWrapperPolicyBusiness wpb
                INNER JOIN PlansHierarchy p ON p.PolicyBusinessId = wpb.ParentPolicyBusinessId
                INNER JOIN @PlansTempTable cp ON cp.PolicyBusinessId = wpb.PolicyBusinessId
            WHERE p.IsWrapperFg = 1
        )

        INSERT INTO @PlansHierarchy
        (
            ParentPolicyBusinessId,
            PolicyBusinessId,
            IsWrapperFg,
            RefTotalPlanValuationTypeId,
            [Level],
            MasterPlanId,
            PlanValue
        )
        SELECT ph.ParentPolicyBusinessId
                ,ph.PolicyBusinessId
                ,ph.IsWrapperFg
                ,ph.RefTotalPlanValuationTypeId
                ,ph.[Level]
                ,ph.MasterPlanId
                ,ph.PlanValue
        FROM PlansHierarchy ph;

        UPDATE ph
        SET IsLeaf = LeafInfo.IsLeaf
        FROM @PlansHierarchy ph
            JOIN (SELECT ph.PolicyBusinessId, IIF(COUNT(wrb.PolicyBusinessId) = 0, 1, 0) AS IsLeaf
                    FROM @PlansHierarchy ph
                    LEFT JOIN policymanagement.dbo.TWrapperPolicyBusiness wrb
                        ON ph.PolicyBusinessId = wrb.ParentPolicyBusinessId
                    GROUP By ph.PolicyBusinessId
                ) As LeafInfo
                ON LeafInfo.PolicyBusinessId = ph.PolicyBusinessId

        --Summarize PlanValues
        DECLARE @PolicyValues TABLE (PolicyBusinessId int, ParentPolicyBusinessId int, [Value] decimal(21,6));
        INSERT INTO @PolicyValues
        SELECT ph.PolicyBusinessId, ph.ParentPolicyBusinessId, ph.PlanValue AS [Value]
            FROM @PlansHierarchy ph
            WHERE ph.IsLeaf = 1

        DECLARE @PolicyBusinessId INT;
        DECLARE @ParentPolicyBusinessId INT;
        DECLARE @RefTotalPlanValuationTypeId INT;
        DECLARE @PlanValue decimal(21,6);
        DECLARE @ChildPlansSumValue decimal(21,6);
        DECLARE @CURSOR CURSOR
        SET @CURSOR  = CURSOR SCROLL
        FOR
        SELECT  ph.PolicyBusinessId, ph.ParentPolicyBusinessId, ph.RefTotalPlanValuationTypeId, ph.PlanValue
            FROM  @PlansHierarchy ph
            WHERE ph.IsLeaf = 0
            ORDER BY ph.[Level] DESC
        OPEN @CURSOR
        FETCH NEXT FROM @CURSOR INTO @PolicyBusinessId, @ParentPolicyBusinessId, @RefTotalPlanValuationTypeId, @PlanValue
        WHILE @@FETCH_STATUS = 0
        BEGIN

            SET @ChildPlansSumValue = (
                SELECT IIF(SUM(IIF([Value] is NULL, 0, 1)) > 0, -- If there is any non-null value
                    SUM(ISNULL([Value], 0)), -- Then Summarize
                    NULL) AS [Value] -- Else Null
                    FROM @PolicyValues pv
                    WHERE pv.ParentPolicyBusinessId = @PolicyBusinessId
                )

            SET @PlanValue = CASE @RefTotalPlanValuationTypeId
                -- Child value or value of WRAP if not.
                WHEN 1 THEN ISNULL(@ChildPlansSumValue, @PlanValue) --Total of Sub Plans, if any have a value, otherwise Total of Master Plan
                -- Total value of Wrap and its Sub Plans
                WHEN 2 THEN ISNULL(@ChildPlansSumValue, 0) + ISNULL(@PlanValue, 0) --Total of Master Plan and Sub Plans
                -- Value of master plan only.
                WHEN 3 THEN @PlanValue --Total of Master Plan excluding Sub Plans
            END

            INSERT INTO @PolicyValues VALUES(@PolicyBusinessId, @ParentPolicyBusinessId, @PlanValue);

            FETCH NEXT FROM @CURSOR INTO @PolicyBusinessId, @ParentPolicyBusinessId, @RefTotalPlanValuationTypeId, @PlanValue
        END
        CLOSE @CURSOR
        --end Summarize PlanValues

        UPDATE p
        SET p.PlanValue = cp.[Value]
        FROM @PlansTempTable p
        INNER JOIN @PolicyValues cp ON cp.PolicyBusinessId = p.PolicyBusinessId;

        -- Remove sub plans
        DELETE @PlansTempTable
        WHERE ParentPolicyBusinessId IS NOT NULL;

        ---------------------------------------------------------------------------------------
        -- Calculate Family Group Liabilities for Mortgage Plans--
        ---------------------------------------------------------------------------------------
        ;WITH PlansTempTable
        AS
        (
			SELECT PlanValue, IIF(CurrencyCode = @RegionalCurrency, 0, 1) AS AlternativeCurrencyFg
			FROM @PlansTempTable
			WHERE reporter.[dbo].[FnCustomIsMortgagePlanType](RefPlanTypeId) = 1 AND PlanValue != 0 AND PlanValue IS NOT NULL
		)
		SELECT @FamilyGroupLiabilities = SUM(PlanValue), @HasPlanInAlternativeCurrency = IIF(@HasPlanInAlternativeCurrency = 1 OR MAX(AlternativeCurrencyFg) = 1, 1, 0)
		FROM PlansTempTable

        ---------------------------------------------------------------------------------------
        -- Calculate Family Group Assets for Retirement and Investments Plans--
        ---------------------------------------------------------------------------------------
        ;WITH PlansTempTable
        AS
        (
			SELECT PlanValue, IIF(CurrencyCode = @RegionalCurrency, 0, 1) AS AlternativeCurrencyFg
			FROM @PlansTempTable
			WHERE policymanagement.[dbo].[FnCustomIsRetirementOrInvestmentsPlans](RefPlanTypeId) = 1 AND PlanValue != 0 AND PlanValue IS NOT NULL
		)
		SELECT @FamilyGroupAssets = SUM(PlanValue), @HasPlanInAlternativeCurrency = IIF(@HasPlanInAlternativeCurrency = 1 OR MAX(AlternativeCurrencyFg) = 1, 1, 0)
        FROM PlansTempTable

        ---------------------------------------------------------------------------------------
        -- Calculate Family Group Assets not related to plans--
        ---------------------------------------------------------------------------------------
        DECLARE @NonPlanRelatedClientAssets decimal(21,6)
        
		SELECT @NonPlanRelatedClientAssets = SUM(A.Amount * R.Rate), 
			   @HasPlanInAlternativeCurrency = IIF(@HasPlanInAlternativeCurrency = 1 OR MAX(AlternativeCurrencyFg) = 1, 1, 0)
		FROM @AssetsTempTable A
		JOIN @Rates R ON A.CurrencyCode = R.CurrencyCode
		WHERE A.PolicyBusinessId IS NULL

        SET @FamilyGroupAssets = ISNULL(@FamilyGroupAssets,0) + ISNULL(@NonPlanRelatedClientAssets,0)
        ---------------------------------------------------------------------------------------
        --Set Name and Id For Head Of Family Group
        ---------------------------------------------------------------------------------------
        SELECT @HeadOfFamilyGroup = ClientName, @HeadOfFamilyGroupCRMContactId = CRMContactId
        FROM  @FamilyGroupTempTable
        WHERE IsHeadOfFamilyGroup = 1

        ---------------------------------------------------------------------------------------
        -- Return result --
        ---------------------------------------------------------------------------------------
        SELECT @HeadOfFamilyGroup AS HeadOfFamilyGroup,
        @FamilyGroupAssets AS  FamilyGroupAssets,
        @FamilyGroupLiabilities AS FamilyGroupLiabilities,
        @HeadOfFamilyGroupCRMContactId AS HeadOfFamilyGroupCRMContactId,
		@HasPlanInAlternativeCurrency AS HasPlanInAlternativeCurrency

    END
END

GO
