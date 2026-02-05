SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------
-- Lots of parameters so this SP dynamically build the SQL statement
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SpCustomSearchOpportunitySecure]
	@IndigoClientId bigint,
	@_UserId bigint,
	@_TopN bigint,	
	@OpportunityStatusId bigint = NULL,
	@OpportunityTypeId bigint = NULL,
	@CampaignTypeId bigint = NULL,
	@CampaignId bigint = NULL,
	@MinimumCommission money = NULL,
	@MinimumProbability money = NULL,
	@AdviserId bigint = NULL,
	@IntroducerId bigint = NULL,
	@Interval varchar(64) = NULL,
	@StatusType varchar(32) = NULL
AS
DECLARE @Declare varchar(max), @Body varchar(max), @Where varchar(max),
	@StartDate datetime, @EndDate datetime

SET @Declare = '
DECLARE
	@IndigoClientId bigint, @_UserId bigint, @_TopN bigint,
	@OpportunityStatusId bigint, @OpportunityTypeId bigint, @CampaignTypeId bigint, @CampaignId bigint,
	@MinimumCommission money, @MinimumProbability money, @AdviserId bigint, @IntroducerId bigint,
	@Interval varchar(32), @StatusType varchar(32)

SELECT
	@IndigoClientId = ' + CAST(@IndigoClientId AS varchar(20)) + ',
	@_UserId = ' + CAST(@_UserId AS varchar(20)) + ', 
    @_TopN = ' + CAST(@_TopN AS varchar(20)) + ',
	@OpportunityStatusId = ' + ISNULL(CAST(@OpportunityStatusId AS varchar(20)), 'NULL') + ',
    @OpportunityTypeId = ' + ISNULL(CAST(@OpportunityTypeId AS varchar(20)), 'NULL') + ',
	@CampaignTypeId = ' + ISNULL(CAST(@CampaignTypeId AS varchar(20)), 'NULL') + ',
    @CampaignId = ' + ISNULL(CAST(@CampaignId AS varchar(20)), 'NULL') + ',
	@MinimumCommission = ' + ISNULL(CAST(@MinimumCommission AS varchar(20)), 'NULL') + ',
	@MinimumProbability = ' + ISNULL(CAST(@MinimumProbability AS varchar(20)), 'NULL') + ',
	@AdviserId = ' + ISNULL(CAST(@AdviserId AS varchar(20)), 'NULL') + ',
	@IntroducerId = ' + ISNULL(CAST(@IntroducerId AS varchar(20)), 'NULL') + ',
	@Interval = ''' + ISNULL(@Interval, 'NULL') + ''',
	@StatusType = ''' + ISNULL(@StatusType, 'NULL') + ''''

SET @Body = '
SET ROWCOUNT @_TopN
SELECT
	 C.CRMContactId, isnull(C.CorporateName,'''') as CorporateName, isnull(C.FirstName,'''') as FirstName, isnull(C.LastName,'''') as LastName, C.CRMContactType,   
	 C.ExternalReference, isnull(C.AdvisorRef,'''') as AdvisorRef,   
	O.OpportunityId,
	OT.OpportunityTypeName AS OpportunityType,
	ISNULL(C.CorporateName, C.FirstName + '' '' + C.LastName) AS ClientName,
	O.Probability,
	O.Amount AS [Value],
	(O.Probability / 100.00) * O.Amount AS AdjustedValue,
	 isnull(convert(varchar(10),O.ClosedDate,103),'''') as ClosedDate,  
	S.OpportunityStatusName AS [Status],
	CONVERT(varchar(10), O.CreatedDate, 103) AS CreatedDate

FROM
	TOpportunity O WITH(NOLOCK)	
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON C.CRMContactId = O.CRMContactId
	JOIN TOpportunityType OT ON OT.OpportunityTypeId = O.OpportunityTypeId
	JOIN TOpportunityStatusHistory OSH ON OSH.OpportunityId = O.OpportunityId AND OSH.CurrentStatusFg = 1
	JOIN TOpportunityStatus S ON S.OpportunityStatusId = OSH.OpportunityStatusId
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId    
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId'

-- Add any additional joins
IF @CampaignTypeId IS NOT NULL OR @CampaignId IS NOT NULL
	SET @Body = @Body + '
    JOIN TCampaignData CD ON CD.CampaignDataId = C.CampaignDataId
	JOIN TCampaign CN ON CN.CampaignId = CD.CampaignId'

IF @AdviserId IS NOT NULL
	SET @Body = @Body + '    
	JOIN CRM..TPractitioner A ON A.CRMContactId = C.CurrentAdviserCRMId'

IF @IntroducerId IS NOT NULL
	SET @Body = @Body + '    
	JOIN Commissions..TSplitTemplate SB ON SB.ClientCRMContactId = C.CRMContactId	
	JOIN CRM..TIntroducer I ON I.CRMContactId = PE.PaymentEntityCRMId'

-- define where clause
SET @Where = '
WHERE
	O.IndigoClientId = @IndigoClientId
	AND C.IndClientId = @IndigoClientId
    AND (@_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))'

-- add additional criteria
IF @OpportunityStatusId IS NOT NULL
	SET @Where = @Where + '
    AND S.OpportunityStatusId = @OpportunityStatusId'

IF @OpportunityTypeId IS NOT NULL
	SET @Where = @Where + '
    AND O.OpportunityTypeId = @OpportunityTypeId'

IF @CampaignTypeId IS NOT NULL 
	SET @Where = @Where + '
    AND CN.CampaignTypeId = @CampaignTypeId'

IF @CampaignId IS NOT NULL
	SET @Where = @Where + '
    AND CN.CampaignId = @CampaignId'

IF @MinimumCommission IS NOT NULL
	SET @Where = @Where + '
    AND O.Amount >= @MinimumCommission'

IF @MinimumProbability IS NOT NULL
	SET @Where = @Where + '
    AND O.Probability >= @MinimumProbability'

IF @AdviserId IS NOT NULL
	SET @Where = @Where + '
    AND A.PractitionerId = @AdviserId'
	
IF @IntroducerId IS NOT NULL
	SET @Where = @Where + '
    AND I.IntroducerId = @IntroducerId'
	
IF @Interval IS NOT NULL
BEGIN
	EXEC Administration..SpCustomGetFinancialYearIntervalDates @IndigoClientId, @Interval, @StartDate output, @EndDate output
	SET @Where = @Where + '    AND O.ClosedDate BETWEEN ''' + CONVERT(varchar(32), @StartDate) + ''' AND ''' + CONVERT(varchar(32), @EndDate) + ''''
END

IF @StatusType IS NOT NULL AND @StatusType != 'All Opportunities'
	SET @Where = @Where + 
		CASE @StatusType
			WHEN 'Open Opportunities' THEN '    AND S.OpportunityStatusTypeId = 1'
			WHEN 'Closed Opportunities' THEN '    AND S.OpportunityStatusTypeId IN (2,3)'
			WHEN 'Closed Won Opportunities' THEN '    AND S.OpportunityStatusTypeId = 2'
			WHEN 'Closed Lost Opportunities' THEN '    AND S.OpportunityStatusTypeId = 3'
		END

EXEC (@Declare + @Body + @Where + '
ORDER BY AdjustedValue DESC
FOR XML RAW

SET ROWCOUNT 0')
GO
