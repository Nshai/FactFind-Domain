SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis
-- Create date: 13 June 2012
-- Description:	Retrieve all manual funds or Equities, using a custom pagination, sorting and filtering.
-- =============================================
CREATE PROCEDURE [dbo].[nio_RetrieveManualFundsWithSuperSectorPaged]
	-- Add the parameters for the stored procedure here
	@TenantId	bigint,
	@PageSize	int,
	@PageNumber	int,
	@FundNameFilter varchar(1000) = '',
	@ProviderNameFilter	varchar(255) = '',
	@SectorNameFilter varchar(255) = '',
	@SuperSectorNameFilter varchar(255) = '',
	@SortBy	varchar(50) = '-Id',
	@FetchEquitiesOnly bit = 0,
	@PlanProviderNameFilter	varchar(255) = '',
	@FetchArchivedOrActive bit = null
AS
BEGIN
	-- Change number to 1 based
	SET @PageNumber = @PageNumber + 1

	DECLARE @FirstRow INT, @LastRow INT, @EquityFundType INT
	SELECT	@FirstRow = (@PageNumber - 1) * @PageSize + 1,
			@LastRow = (@PageNumber - 1) * @PageSize + @PageSize;

	
	SET @EquityFundType = (SELECT RefFundTypeId FROM FUND2..TRefFundType
								   WHERE FundTypeName = 'Equities');		

	WITH 
		PagedManualFunds AS
		(		
			SELECT
				manFund.NonFeedFundId as Id, 
				manFund.FundName as Name,
				manFund.CompanyId as ProviderId,
				manFund.CompanyName as ProviderName,				
				manFund.CategoryId as SectorId,
				manFund.CategoryName as SectorName,
				manFund.IsArchived,
				superSector.FundSuperSectorId as SuperSectorId,
				superSector.Name as SuperSectorName,
				providers.RefProdProviderId as PlanProviderId,
				providers.Name as PlanProviderName,
				ROW_NUMBER()
					OVER (ORDER BY
							CASE WHEN @SortBy = 'Name' THEN manFund.FundName END ASC,
							CASE WHEN @SortBy = '-Name' THEN manFund.FundName END DESC,
							CASE WHEN @SortBy = 'ProviderName' THEN manFund.CompanyName END ASC,
							CASE WHEN @SortBy = '-ProviderName' THEN manFund.CompanyName END DESC,
							CASE WHEN @SortBy = 'SectorName' THEN manFund.CategoryName END ASC,
							CASE WHEN @SortBy = '-SectorName' THEN manFund.CategoryName END DESC,
							CASE WHEN @SortBy = 'SuperSectorId' THEN superSector.Name END ASC,
							CASE WHEN @SortBy = '-SuperSectorId' THEN superSector.Name END DESC,
							CASE WHEN @SortBy = 'IsArchived' THEN manFund.IsArchived END ASC,
							CASE WHEN @SortBy = '-IsArchived' THEN manFund.IsArchived END DESC,
							CASE WHEN @SortBy = '-Id' THEN manFund.NonFeedFundId END ASC,
							CASE WHEN @SortBy = 'PlanProviderName' THEN providers.Name END ASC,
							CASE WHEN @SortBy = '-PlanProviderName' THEN providers.Name END DESC
							) as RowNumber,
				COUNT(*) OVER() as TotalRowCount
			FROM 
				policymanagement..TNonFeedFund manFund 
			LEFT JOIN 
				policymanagement..TFundToFundSuperSector fundToSuperSector on fundToSuperSector.FundId = manFund.NonFeedFundId
				-- condition to select only the manual funds, because a manual fund can be used as manual equity too
														AND fundToSuperSector.IsFromFeed = 0 and fundToSuperSector.IsEquity = 0 
			LEFT JOIN 
				policymanagement..TFundSuperSector superSector on superSector.FundSuperSectorId = fundToSuperSector.FundSuperSectorId
			LEFT JOIN
				policymanagement..VProvider providers on providers.RefProdProviderId = manFund.RefProdProviderId
			WHERE 
				manFund.IndigoClientId = @TenantId
				AND (@FetchArchivedOrActive IS NULL OR manFund.IsArchived =  @FetchArchivedOrActive)
				AND	((@FetchEquitiesOnly = 1 AND manFund.FundTypeId = @EquityFundType) 
				OR (@FetchEquitiesOnly = 0 AND manFund.FundTypeId != @EquityFundType)) -- where is not Equity Type
				AND (@FundNameFilter = '' OR manFund.FundName LIKE '%' + @FundNameFilter + '%')
				AND (@ProviderNameFilter = '' OR manFund.CompanyName LIKE '%' + @ProviderNameFilter + '%')
				AND (@SectorNameFilter = '' OR manFund.CategoryName LIKE '%' + @SectorNameFilter + '%')
				AND (@SuperSectorNameFilter = '' OR superSector.Name LIKE @SuperSectorNameFilter + '%')
				AND (@PlanProviderNameFilter = '' OR providers.Name LIKE '%' + @PlanProviderNameFilter + '%')
		)
    -- Insert statements for procedure here
	SELECT 
		Id,
		Name,
		ProviderId,
		ProviderName,
		SectorId,
		SectorName,
		SuperSectorId,
		SuperSectorName,
		IsArchived,
		PlanProviderId,
		PlanProviderName,
		RowNumber,
		TotalRowCount
	FROM	
		PagedManualFunds
	WHERE 
		RowNumber BETWEEN @FirstRow AND @LastRow
	ORDER BY
		RowNumber ASC
END
GO
