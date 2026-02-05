SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_CustomSearchObjectiveGetColumnList
AS
BEGIN
SELECT
	0  AS CRMContactId,
	'' AS CorporateName,
	'' AS FirstName,
	'' AS LastName,
	0  AS CRMContactType,
	'' AS ExternalReference,
	'' AS AdvisorRef,
	'' AS ClientName,
	0  AS OpportunityId,
	'' AS OpportunityType,
	'' AS CreatedDate,		
	'' AS Opportunity,
	'' AS ObjectiveType,
	'' AS StartDate,	
	'' AS [Value],	
	0  AS TargetAmount,
    0  AS ObjectiveId		
END
GO
