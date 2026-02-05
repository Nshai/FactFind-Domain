GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessByIds]
    @TenantId INT,
    @Top INT = 10000,
    @Skip INT = 0,
    @PolicyNumberLIKE VARCHAR(50) = NULL,
    @PolicyNumberEquals VARCHAR(50) = NULL,
    @WhoUpdatedDateTimeFrom DATETIME2 = NULL,
    @WhoUpdatedDateTimeTo DATETIME2 = NULL,
    @RefPlanValueTypeId INT = NULL,
    @RefProdProviderIds dbo.tvp_int READONLY,
    @SortColumn1 TINYINT = 3,
    @SortAscending1 BIT = 1,
    @SortColumn2 TINYINT = NULL,
    @SortAscending2 BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PagedSql NVARCHAR(MAX)
    DECLARE @TotalCount INT

    CREATE TABLE #TempResults (
        PolicyBusinessId INT,
        SequentialRef VARCHAR(50),
        PolicyNumber VARCHAR(50)
    );

    CREATE TABLE #PBCols (
        PolicyBusinessId INT,
        SequentialRef VARCHAR(50),
        PolicyNumber VARCHAR(50)
    );
	
    WITH PBCols AS (
        SELECT DISTINCT 
                pb.PolicyBusinessId,
                pb.SequentialRef,
                pb.PolicyNumber
            FROM dbo.TRefProdProvider rp
                LEFT JOIN @RefProdProviderIds rpids ON rpids.value = rp.RefProdProviderId
                INNER JOIN dbo.TPlanDescription pd ON pd.RefProdProviderId = rp.RefProdProviderId
                INNER JOIN dbo.TPolicyDetail pold ON pold.PlanDescriptionId = pd.PlanDescriptionId AND pold.IndigoClientId = @TenantId
                INNER JOIN dbo.TPolicyBusiness pb ON pb.PolicyDetailId = pold.PolicyDetailId
				WHERE
				(
					NOT EXISTS (SELECT 1 FROM @RefProdProviderIds)
					OR
					rp.RefProdProviderId IN (SELECT VALUE FROM @RefProdProviderIds)
				)
    )
    INSERT #PBCols
    SELECT * FROM PBCols
    WHERE
        (@PolicyNumberEquals IS NULL OR PolicyNumber = @PolicyNumberEquals)
    AND
        (@PolicyNumberLIKE IS NULL OR PolicyNumber LIKE @PolicyNumberLIKE)
    INSERT INTO #TempResults (PolicyBusinessId, SequentialRef, PolicyNumber)
    SELECT DISTINCT 
        pb.PolicyBusinessId,
        pb.SequentialRef,
        pb.PolicyNumber
    FROM #PBCols pb
    LEFT JOIN dbo.TPlanValuation pv ON pb.PolicyBusinessId = pv.PolicyBusinessId
    WHERE
        (@RefPlanValueTypeId IS NULL OR pv.RefPlanValueTypeId = @RefPlanValueTypeId)
        AND
        (@WhoUpdatedDateTimeFrom IS NULL OR pv.WhoUpdatedDateTime >= @WhoUpdatedDateTimeFrom)
        AND
        (@WhoUpdatedDateTimeTo IS NULL OR pv.WhoUpdatedDateTime <= @WhoUpdatedDateTimeTo)
    SET @TotalCount = @@rowcount;

    SELECT
        PolicyBusinessId AS planId,
        PolicyNumber AS PolicyNumber
    FROM #TempResults
    ORDER BY
        -- SortColumn1
        CASE WHEN @SortColumn1 = 1 AND @SortAscending1 = 1 THEN SequentialRef END ASC,
        CASE WHEN @SortColumn1 = 1 AND @SortAscending1 = 0 THEN SequentialRef END DESC,
        CASE WHEN @SortColumn1 = 2 AND @SortAscending1 = 1 THEN PolicyNumber END ASC,
        CASE WHEN @SortColumn1 = 2 AND @SortAscending1 = 0 THEN PolicyNumber END DESC,
        CASE WHEN @SortColumn1 = 3 AND @SortAscending1 = 1 THEN PolicyBusinessId END ASC,
        CASE WHEN @SortColumn1 = 3 AND @SortAscending1 = 0 THEN PolicyBusinessId END DESC,
        -- SortColumn2
        CASE WHEN @SortColumn2 = 1 AND @SortAscending2 = 1 THEN SequentialRef END ASC,
        CASE WHEN @SortColumn2 = 1 AND @SortAscending2 = 0 THEN SequentialRef END DESC,
        CASE WHEN @SortColumn2 = 2 AND @SortAscending2 = 1 THEN PolicyNumber END ASC,
        CASE WHEN @SortColumn2 = 2 AND @SortAscending2 = 0 THEN PolicyNumber END DESC,
        CASE WHEN @SortColumn2 = 3 AND @SortAscending2 = 1 THEN PolicyBusinessId END ASC,
        CASE WHEN @SortColumn2 = 3 AND @SortAscending2 = 0 THEN PolicyBusinessId END DESC
    OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY;

    SELECT @TotalCount AS TotalCount;

    DROP TABLE #TempResults;
END;
GO