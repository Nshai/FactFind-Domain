SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrAllocationReportData]
	@FactFindId bigint,
	@ObjectiveId bigint,
	@AtrPortfolioGuid uniqueidentifier
AS
BEGIN
	DECLARE
		@CRMContactId bigint,
		@AdviserCRMId bigint,
		@IndigoClientId bigint

	SELECT 
		@CRMContactId = CRMContactId1,
		@IndigoClientId = IndigoClientId
	FROM
		TFactFind
	WHERE
		FactFindId = @FactFindId

	EXEC SpNCustomRetrieveFactFindClients @FactFindId
	
	-- Client address
	SELECT TOP 1
		*
	FROM
		CRM..VwAddress
	WHERE
		CRMContactId = @CRMContactId
	ORDER BY
		DefaultFg DESC
	
	-- Get current adviser
	SELECT
		@AdviserCRMId = CurrentAdviserCRMId
	FROM
		CRM..TCRMContact	
	WHERE
		CRMContactId = @CRMContactId
		
	-- Adviser Address
	SELECT
		*	
	FROM
		CRM..VwAddress
	WHERE
		CRMContactId = @AdviserCRMId
	
	-- Get Organisation address
	EXEC Administration..[SpNCustomGetOrganisationNameAndAddressForReport] 'Fact Find', @AdviserCRMId, 'UseOrganisationAddress', @IndigoClientId

	-- Get objective
	EXEC SpNRetrieveObjectiveByObjectiveId @ObjectiveId

	-- Get portfolio details
	EXEC SpNCustomRetrieveAtrPortfolioComplete @AtrPortfolioGuid, @IndigoClientId

	--Stochastic results
	select 
	Term,
	InputValue,
	LowerReturn,
	MidReturn,
	UpperReturn
	from [TStochasticIllustrationResult]
	where	ObjectiveId = @ObjectiveId
	order by Term asc
	


END

GO
