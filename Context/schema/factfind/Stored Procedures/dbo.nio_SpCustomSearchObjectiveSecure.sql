SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchObjectiveSecure]
	@IndigoClientId bigint,
	@_UserId bigint,
	@_TopN int,
	@RiskProfileGuid varchar(38) = null,
	@MinimumTargetAmount money = null,
	@OpportunityLinked varchar(32) = 'Not Linked',
	@Interval varchar(64) = null,
	@OnFactFind varchar(4) = 'Both',
	@AdviserPartyId bigint = NULL,
	@ObjectiveTypeId bigint = NULL
AS
DECLARE @StartDate datetime, @EndDate datetime
-- Get start and end dates if a financial quarter interval has been specified
IF @Interval IS NOT NULL
	EXEC Administration..SpCustomGetFinancialYearIntervalDates @IndigoClientId, @Interval, @StartDate output, @EndDate output

SET ROWCOUNT @_TopN

-- We need to negate the UserId for SuperUsers and SuperViewers to bypass the entity security.
IF EXISTS(SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))
	SELECT @_UserId = @_UserId * -1

-- Adviser (Converting the Party id to adviser Id)
DECLARE @AdviserId bigint
SELECT @AdviserId = null;
 
IF @AdviserPartyId is not null
SELECT @AdviserId = (SELECT PractitionerId from CRM..TPractitioner P 
where P.CRMContactId = @AdviserPartyId)

SELECT
	-- Client details for clickthru
	C.CRMContactId, C.CorporateName, C.FirstName, C.LastName, C.CRMContactType, 
	C.ExternalReference, C.AdvisorRef, 
	ISNULL(C.CorporateName, C.FirstName + ' ' + C.LastName) AS ClientName,
	-- Opp details for clickthru
	Opp.OpportunityId,
	OppT.OpportunityTypeName AS OpportunityType,
	CONVERT(varchar(10), Opp.CreatedDate, 103) AS CreatedDate,
	Opp.SequentialRef + ' ' + CASE IsClosed WHEN 1 THEN '(Closed)' ELSE '(In Progress)' END AS Opportunity,
	-- Objective details
	ObjT.Identifier AS ObjectiveType,
	O.StartDate,
	O.TargetDate AS [Value],	
	O.TargetAmount,
    O.ObjectiveId
FROM
	TObjective O WITH(NOLOCK)	
	JOIN TObjectiveType ObjT WITH(NOLOCK) ON ObjT.ObjectiveTypeId = O.ObjectiveTypeId	
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON C.CRMContactId = O.CRMContactId
	JOIN CRM..TPractitioner A WITH(NOLOCK) ON A.CRMContactId = C.CurrentAdviserCRMId
	LEFT JOIN CRM..TOpportunityObjective OppObj WITH(NOLOCK) ON OppObj.ObjectiveId = O.ObjectiveId
	LEFT JOIN CRM..TOpportunity Opp WITH(NOLOCK) ON Opp.OpportunityId = OppObj.OpportunityId
	LEFT JOIN CRM..TOpportunityType OppT WITH(NOLOCK) ON OppT.OpportunityTypeId = Opp.OpportunityTypeId
	LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId    
	LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId
WHERE
	C.IndClientId = @IndigoClientId
    AND (@_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))
	AND (@RiskProfileGuid IS NULL OR O.RiskProfileGuid = @RiskProfileGuid)
	AND (@MinimumTargetAmount IS NULL OR TargetAmount >= @MinimumTargetAmount)
	AND ((@OpportunityLinked = 'All') OR
		 (@OpportunityLinked = 'Not Linked' AND OppObj.OpportunityId IS NULL) OR
		 (@OpportunityLinked = 'Linked to Open Opportunity' AND Opp.IsClosed = 0) OR
		 (@OpportunityLinked = 'Linked to Closed Opportunity' AND Opp.IsClosed = 1))
	AND (@Interval IS NULL OR StartDate BETWEEN @StartDate AND @EndDate)
	AND ((@OnFactFind = 'Both') OR
		 (@OnFactFind = 'Yes' AND IsFactFind = 1) OR
		 (@OnFactFind = 'No' AND IsFactFind = 0))
	AND (@AdviserId IS NULL OR A.PractitionerId = @AdviserId)
	AND (@ObjectiveTypeId IS NULL OR O.ObjectiveTypeId = @ObjectiveTypeId)

SET ROWCOUNT 0
GO
