SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[nio_CustomSearchOpportunityGetColumnList]
AS
BEGIN
SELECT
    0  AS OpportunityCustomerId,
    0  AS PartyId,
	0  AS OpportunityId,
	0  AS CRMContactId,
	'' AS CorporateName,
	'' AS FirstName,
	'' AS LastName,
	0  AS CRMContactType,
	'' AS ExternalReference,
	'' AS AdvisorRef,	
	'' AS OpportunityType,
	'' AS ClientName,
	0  AS Probability,
	0  AS [Value],
	0  AS AdjustedValue,
	'' AS ClosedDate,	
	'' AS [Status],	
	'' AS CreatedDate,
	'' AS ClientType,
	'' AS [StatusDate],
	'' AS ClientAssetValue,
	0  AS PropositionTypeId,
	'' As PropositionTypeName,
	'' As SequentialRef,
	'' As TargetClosedDate
END

GO
