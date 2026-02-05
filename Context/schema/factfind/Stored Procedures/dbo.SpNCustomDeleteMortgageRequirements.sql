SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteMortgageRequirements]
	@MortgageRequirementsId bigint,
	@StampUser varchar(50),
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS    
DECLARE @OpportunityId bigint

-------------------------------------------------------
-- Get opportunity Id
-------------------------------------------------------
SELECT @OpportunityId = OpportunityId
FROM CRM..TMortgageOpportunity 
WHERE MortgageOpportunityId=@MortgageRequirementsId

-------------------------------------------------------
-- Audit the Opportunity.
-------------------------------------------------------
EXEC CRM..SpNAuditOpportunity @StampUser, @OpportunityId, 'U'

-------------------------------------------------------
-- Close the Opportunity.
-------------------------------------------------------
UPDATE 
	CRM..TOpportunity
SET 
	ClosedDate = @CurrentUserDate, IsClosed = 1, ConcurrencyId = ConcurrencyId + 1
WHERE 
	OpportunityId = @OpportunityId
				
RETURN (0)
GO
