SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier             Issue       Description
----        ---------            -------     -------------
20230131    Aswani kumar P      IOSE22-1140	 Update the Stored procedure for Target Closed Date field search 
20230130    Ajib C K            IOSE22-1203  Update the Stored procedure for IOO Sequential Reference field search 
*/
Create PROCEDURE [dbo].[nio_SpCustomSearchOpportunitySecure]
	@IndigoClientId bigint,
	@_UserId bigint,
	@_TopN bigint = 300,	
	@OpportunityStatusId bigint = NULL,
	@OpportunityTypeId bigint = NULL,
	@CampaignTypeId bigint = NULL,
	@CampaignId bigint = NULL,
	@CampaignChannelId bigint = NULL,
	@MinimumCommission money = NULL,
	@MinimumProbability money = NULL,
	@AdviserPartyId bigint = NULL,
	@IntroducerPartyId bigint = NULL,
	@Interval varchar(64) = NULL,
	@StatusType varchar(32) = NULL,
	@ClientTypeId bigint =0,
	@CustomerAdviserPartyId bigint = NULL,
	@PostCode varchar(32) = NULL,
	@PostcodePatchAdviserPartyId bigint = NULL,
	@ClientAssetValue decimal(18,2) = NULL,
	@PropositionTypeId bigint = NULL,
	@SequentialRef varchar(50) = NULL,
	@TargetClosedDateFrom varchar(10) = '%', /*Date  will be either yyyy-MM-dd or % */
	@TargetClosedDateTo varchar(10) = '%' /*Date  will be either yyyy-MM-dd or % */
	
AS
BEGIN

--Replace '+' with a space as the the parameter values get escaped when paging 

if (@Interval is not null)
	Set @Interval = REPLACE(@Interval, '+', ' ')

if (@StatusType is not null)
	Set @StatusType = REPLACE(@StatusType, '+', ' ')

if (@PostCode is not null)
	Set @PostCode = REPLACE(@PostCode, '+', ' ')



DECLARE @Declare varchar(max), @Body varchar(max), @Where varchar(max),
	@StartDate datetime, @EndDate datetime

-- We need to negate the UserId for SuperUsers and SuperViewers to bypass the entity security.
IF EXISTS(SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))
	SELECT @_UserId = @_UserId * -1

-- Adviser (Converting the Party id to adviser Id)
DECLARE @AdviserId bigint
SELECT @AdviserId = null;
 
IF @AdviserPartyId is not null
SELECT @AdviserId = (SELECT PractitionerId from CRM..TPractitioner P 
where P.CRMContactId = @AdviserPartyId)

--Introducer ((Converting the Party id to Introducer Id)
DECLARE @IntroducerId bigint
SELECT @IntroducerId = null;

IF @IntroducerPartyId is not null
SELECT @IntroducerId = (SELECT IntroducerId from CRM..TIntroducer I 
where I.CRMContactId = @IntroducerPartyId)

SET @Declare = '
DECLARE
	@IndigoClientId bigint, @_UserId bigint, @_TopN bigint,	@OpportunityStatusId bigint, @OpportunityTypeId bigint, 
	@CampaignTypeId bigint, @CampaignId bigint,@CampaignChannelId bigint, @MinimumCommission money, 
	@MinimumProbability money, @AdviserId bigint, @IntroducerId bigint,	@Interval varchar(32), 
	@StatusType varchar(32), @CustomerAdviserCRMId bigint, @PostCode varchar(32),@PostcodePatchAdviserPartyId bigint,
	@ClientAssetValue decimal(18,2), @PropositionTypeId bigint, @SequentialRef varchar(50)

SELECT
	@IndigoClientId = ' + CAST(@IndigoClientId AS varchar(20)) + ',
	@_UserId = ' + CAST(@_UserId AS varchar(20)) + ', 
    @_TopN = ' + CAST(@_TopN AS varchar(20)) + ',
   	@OpportunityStatusId = ' + ISNULL(CAST(@OpportunityStatusId AS varchar(20)), 'NULL') + ',
    @OpportunityTypeId = ' + ISNULL(CAST(@OpportunityTypeId AS varchar(20)), 'NULL') + ',
	@CampaignTypeId = ' + ISNULL(CAST(@CampaignTypeId AS varchar(20)), 'NULL') + ',
    @CampaignId = ' + ISNULL(CAST(@CampaignId AS varchar(20)), 'NULL') + ',
    @CampaignChannelId = ' + ISNULL(CAST(@CampaignChannelId AS varchar(20)), 'NULL') + ',
    @PostCode = ' + ISNULL(''''+ CAST(@PostCode AS varchar(32))+'''', 'NULL')+ ',
	@MinimumCommission = ' + ISNULL(CAST(@MinimumCommission AS varchar(20)), 'NULL') + ',
	@MinimumProbability = ' + ISNULL(CAST(@MinimumProbability AS varchar(20)), 'NULL') + ',
	@CustomerAdviserCRMId = '+ ISNULL(CAST(@CustomerAdviserPartyId AS varchar(20)), 'NULL') + ',
	@AdviserId = ' + ISNULL(CAST(@AdviserId AS varchar(20)), 'NULL') + ',
	@PostcodePatchAdviserPartyId = ' + ISNULL(CAST(@PostcodePatchAdviserPartyId AS varchar(20)), 'NULL') + ',
	@IntroducerId = ' + ISNULL(CAST(@IntroducerId AS varchar(20)), 'NULL') + ',	
	@Interval = ' + ISNULL('''' + @Interval + '''', 'NULL') + ',	
	@StatusType = ' + ISNULL('''' + @StatusType + '''', 'NULL') + ',
	@ClientAssetValue = ' + ISNULL(CAST(@ClientAssetValue AS varchar(20)), 'NULL') + ',
	@PropositionTypeId = ' + ISNULL(CAST(@PropositionTypeId AS varchar(20)), 'NULL') + ',
	@SequentialRef = ' + ISNULL(''''+ CAST(@SequentialRef AS varchar(50))+'''', 'NULL')+ ''
	

SET @Body = '
SET ROWCOUNT @_TopN
SELECT
	OC.OpportunityCustomerId,
	OC.PartyId as PartyId,
	O.OpportunityId,
	C.CRMContactId, isnull(C.CorporateName,'''') as CorporateName, 
    isnull(C.FirstName,'''') as FirstName, 
	isnull(C.LastName,'''') as LastName, 
    C.CRMContactType,   
	C.ExternalReference, 
	ISNULL(CAST(P.CRMContactId AS varchar(20)), '''') as AdvisorRef,
    --isnull(C.AdvisorRef,'''') as AdvisorRef,   	
	OT.OpportunityTypeName AS OpportunityType,
	ISNULL(C.CorporateName, C.FirstName + '' '' + C.LastName) AS ClientName,
	O.Probability,
	O.Amount AS [Value],
	(O.Probability / 100.00) * O.Amount AS AdjustedValue,
	O.ClosedDate as ClosedDate,  
	S.OpportunityStatusName AS [Status],
	 O.CreatedDate AS CreatedDate,
	--CONVERT(varchar(10), O.CreatedDate, 103) AS CreatedDate,
	CASE C.RefCRMContactStatusId 
			WHEN 1 THEN ''Client'' 
			WHEN 2 THEN ''Lead'' 
	END AS ClientType,
	OSH.DateOfChange AS [StatusDate],
	O.ClientAssetValue AS ClientAssetValue,
	O.PropositionTypeId,
	PT.PropositionTypeName,
	O.SequentialRef,
	O.TargetClosedDate
	
FROM
	TOpportunity O WITH(NOLOCK)	
	JOIN CRM..TOpportunityCustomer OC on OC.OpportunityId = O.OpportunityId
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON OC.PartyId = C.CRMContactId
	JOIN TOpportunityType OT ON OT.OpportunityTypeId = O.OpportunityTypeId
	JOIN TOpportunityStatusHistory OSH ON OSH.OpportunityId = O.OpportunityId AND OSH.CurrentStatusFg = 1
	JOIN TOpportunityStatus S ON S.OpportunityStatusId = OSH.OpportunityStatusId
    LEFT JOIN TPractitioner P WITH(NOLOCK) ON P.PractitionerId = O.PractitionerId
	LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId    
	LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId
	Left JOIN TPropositionType PT ON PT.PropositionTypeId = O.PropositionTypeId	'
    
-- Add any additional joins
IF @CampaignTypeId IS NOT NULL OR @CampaignId IS NOT NULL OR @CampaignChannelId IS NOT NULL
	SET @Body = @Body + '
    JOIN TCampaignData CD ON CD.CampaignDataId = O.CampaignDataId
	JOIN TCampaign CN ON CN.CampaignId = CD.CampaignId'

-- Add joins for Address
IF @PostCode IS NOT NULL
	SET @Body = @Body + '
    JOIN TAddress A ON A.CRMContactId = C.CRMContactId
	JOIN TRefAddressStatus RAS ON RAS.RefAddressStatusId = A.RefAddressStatusId
	JOIN TAddressStore ADS ON ADS.AddressStoreId = A.AddressStoreId'

-- Add joins for Adviser Postcode Patch
IF @PostcodePatchAdviserPartyId IS NOT NULL And @PostCode IS NULL
	SET @Body = @Body + '
    JOIN TAddress A ON A.CRMContactId = C.CRMContactId
	JOIN TRefAddressStatus RAS ON RAS.RefAddressStatusId = A.RefAddressStatusId
	JOIN TAddressStore ADS ON ADS.AddressStoreId = A.AddressStoreId'
	
--IF @AdviserId IS NOT NULL
--	SET @Body = @Body + '    
--	JOIN CRM..TPractitioner A ON A.CRMContactId = C.CurrentAdviserCRMId'

--IF @IntroducerId IS NOT NULL
--	SET @Body = @Body + '    
--	JOIN Commissions..TSplitTemplate SB ON SB.ClientCRMContactId = C.CRMContactId	
--	JOIN CRM..TIntroducer I ON I.CRMContactId = PE.PaymentEntityCRMId'



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

IF @CampaignChannelId IS NOT NULL
	SET @Where = @Where + '
    AND CD.CampaignChannelId = @CampaignChannelId'

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

IF @CustomerAdviserPartyId IS NOT NULL
	SET @Where = @Where + '
    AND C.CurrentAdviserCRMId = @CustomerAdviserCRMId'

IF @AdviserId IS NOT NULL
	SET @Where = @Where + '
    AND O.PractitionerId = @AdviserId'
    
IF @ClientAssetValue IS NOT NULL    
	SET @Where = @Where + '
	AND O.ClientAssetValue = @ClientAssetValue'

IF @PropositionTypeId IS NOT NULL
	SET @Where = @Where + '
	AND O.PropositionTypeId = @PropositionTypeId'
	
IF @ClientTypeId IS NOT NULL
	SET @Where = @Where + 
		CASE @ClientTypeId	
			WHEN 2 THEN ' 
			AND C.ArchiveFg = 0 AND C.RefCRMContactStatusId  = 1' -- Only Clients
			WHEN 3 THEN ' 
			AND C.ArchiveFg = 0 AND C.RefCRMContactStatusId  = 2' -- Only Leads/Prospects
			ELSE  ' 
			AND C.ArchiveFg = 0 AND C.RefCRMContactStatusId  IN (1, 2)' -- Both
		END

IF @PostCode IS NOT NULL
SET @Where = @Where + '
    AND RAS.AddressStatus = ''Current Address'' AND LOWER(ADS.Postcode) Like LOWER(@PostCode) '

IF @SequentialRef IS NOT NULL
SET @Where = @Where + '
    AND O.SequentialRef Like @SequentialRef '

IF @PostcodePatchAdviserPartyId IS NOT NULL
SET @Where = @Where + '
    AND RAS.AddressStatus = ''Current Address'' 
    AND (ltrim(rtrim(ADS.PostCode)) is not null 
		and ltrim(rtrim(ADS.PostCode)) != ''''
		and len(ltrim(rtrim(ADS.PostCode))) >= 3
		and ADS.PostCode not like ''--%''
		and ADS.PostCode not like ''-%-''
		and replace(ADS.PostCode,char(32),'''') != ''''
		and replace(ADS.PostCode,char(32),'''') is not null)
    AND LOWER(RTrim(LTrim(SUBSTRING(ADS.Postcode,1,LEN(ADS.Postcode)-3)))) In 
    (select distinct lower(pc.PostCodeShortName)
	from crm..TPostCode as pc 
	Inner Join crm..TPostCodeAllocationGroupPostCodeAssigned as pcagpca
	on (pcagpca.PostCodeId = pc.PostCodeId) 
	Inner Join crm..TPostCodeAllocationGroup as pcag
	on (pcagpca.PostCodeAllocationGroupId = pcag.PostCodeAllocationGroupId)
	Inner Join crm..TPostCodeAllocationGroupAdviserAssigned as pcagaa
	on (pcagaa.PostCodeAllocationGroupId = pcag.PostCodeAllocationGroupId)
	where pcagaa.CRMContactId = @PostcodePatchAdviserPartyId)'      

IF @IntroducerId IS NOT NULL
	SET @Where = @Where + '
    AND O.IntroducerId = @IntroducerId'
	
IF @Interval IS NOT NULL
BEGIN

	EXEC Administration..SpCustomGetFinancialYearIntervalDates @IndigoClientId, @Interval, @StartDate output, @EndDate output
	IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
		SET @Where = @Where + '    AND O.ClosedDate BETWEEN ''' + CONVERT(varchar(32), @StartDate) + ''' AND ''' + CONVERT(varchar(32), @EndDate) + ''''
	ELSE IF @StartDate IS NOT NULL
		SET @Where = @Where + '    AND O.ClosedDate >= ' +''''+ CONVERT(varchar(32), @StartDate) + ''''
	ELSE 
		SET @Where = @Where + '    AND O.ClosedDate <= ' +''''+ CONVERT(varchar(32), @EndDate) + ''''
END

IF @StatusType IS NOT NULL AND @StatusType != 'All Opportunities'
	SET @Where = @Where + 
		CASE @StatusType
			WHEN 'Open Opportunities' THEN '    AND S.OpportunityStatusTypeId = 1'
			WHEN 'Closed Opportunities' THEN '    AND S.OpportunityStatusTypeId IN (2,3)'
			WHEN 'Closed Won Opportunities' THEN '    AND S.OpportunityStatusTypeId = 2'
			WHEN 'Closed Lost Opportunities' THEN '    AND S.OpportunityStatusTypeId = 3'
			ELSE ' '
		END	

If @TargetClosedDateFrom <> '%' and @TargetClosedDateFrom <> '' and (Isdate(@TargetClosedDateFrom) = 1)
	Select @Where = @Where  + ' And O.TargetClosedDate >= ' + '''' + @TargetClosedDateFrom + '''' + '
	'

If @TargetClosedDateTo <> '%' and @TargetClosedDateTo <> '' and (Isdate(@TargetClosedDateTo) = 1)
	Select @Where = @Where  + ' And O.TargetClosedDate <= ' + '''' + @TargetClosedDateTo + '''' + '
'

--select @Declare
--select @Body
--select @Where

If @Where is null
	SET @Where = ' WHERE 1=2 '


EXEC (@Declare + @Body + @Where + '
ORDER BY AdjustedValue DESC

SET ROWCOUNT 0')

END


GO
