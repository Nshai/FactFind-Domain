SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spNIOCustomRetrieveEmailDTO]
	@TenantId BIGINT,
	@PartyId BIGINT = 0,
	@Range TINYINT = 2, -- Historic = 0, Active = 1, All=2
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@UserId BIGINT = 0
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @CompleteFG BIT
DECLARE @DateCompletedStart DATETIME;
DECLARE @DateCompletedEnd DATETIME;

--Adjust end date to the end of the day
SET @EndDate = IIF(@EndDate IS NULL, NULL, DATEADD(ms, -3, DATEADD(dd, DATEDIFF(dd, 0, ISNULL(@EndDate, GETDATE())) + 1, 0)));
IF (@Range = 0)
BEGIN
	SET @CompleteFG = 1
	SET @DateCompletedStart = @StartDate;
	SET @DateCompletedEnd = @EndDate;
END
ELSE
BEGIN
	SET @CompleteFG = 0
END

IF OBJECT_ID('tempdb..#TempEmails') IS NOT NULL
DROP TABLE #TempEmails

CREATE TABLE #TempEmails
(
	[OrganiserActivityId] INT,
	[EmailId] INT,
	[SentDate] DATETIME,
	[Subject] VARCHAR(255),
	[OwnerName] VARCHAR(255),
	[HasAttachments] BIT,
	[CarbonCopy] BIT
)

IF (@PartyId > 0)
BEGIN
	INSERT INTO #TempEmails
	(
		[OrganiserActivityId],
		[EmailId],
		[SentDate],
		[Subject],
		[OwnerName],
		[HasAttachments],
		[CarbonCopy]
	)
	SELECT DISTINCT
		A.[OrganiserActivityId],
		K.EmailId  AS EmailId,
		K.[SentDate],
		CASE
			WHEN LEN(ISNULL(K.[Subject], '')) > 255 THEN LEFT(K.[Subject], 252) + '...'
			ELSE K.[Subject]
		END AS [Subject],
		(L.[FirstName] + ' ' + L.[LastName]) AS [OwnerName],
		CASE
			WHEN (TA.[AttachmentId] > 0) THEN 1
			ELSE 0
		END  AS [HasAttachments],
		0 AS [CarbonCopy]
	FROM TOrganiserActivity A
		JOIN CRM..TEmail K on K.[OrganiserActivityId] = A.[OrganiserActivityId]
		LEFT JOIN CRM..TEntityOrganiserActivity EO on A.[OrganiserActivityId] = EO.[OrganiserActivityId]
		LEFT JOIN CRM..TCRMContact L on L.[CRMContactId] = K.[OwnerPartyId]
		LEFT JOIN ADMINISTRATION..TUser M on M.[CRMContactId] = L.[CRMContactId]
		LEFT JOIN CRM..TAttachment TA ON TA.[EmailId] = K.[EmailId]

	--Check for Tenant
	WHERE M.[IndigoClientId] = @TenantId
	--Records for Party.
	AND EO.EntityId = @PartyId
	AND (@DateCompletedEnd IS NULL OR K.SentDate <= @DateCompletedEnd OR (@DateCompletedStart IS NULL AND K.SentDate IS NULL))
	AND (@DateCompletedStart IS NULL OR K.SentDate >= @DateCompletedStart)
END
ELSE
BEGIN
	INSERT INTO #TempEmails
	(
		[OrganiserActivityId],
		[EmailId],
		[SentDate],
		[Subject],
		[OwnerName],
		[HasAttachments],
		[CarbonCopy]
	)
	SELECT DISTINCT
		A.[OrganiserActivityId],
		K.EmailId  AS EmailId,
		K.[SentDate],
		CASE
			WHEN LEN(ISNULL(K.[Subject], '')) > 255 THEN LEFT(K.[Subject], 252) + '...'
			ELSE K.[Subject]
		END AS [Subject],
		(L.[FirstName] + ' ' + L.[LastName]) AS [OwnerName],
		CASE
			WHEN (TA.[AttachmentId] > 0) THEN 1
			ELSE 0
		END  AS [HasAttachments],
		0 AS [CarbonCopy]
	FROM TOrganiserActivity A
		JOIN CRM..TEmail K on K.[OrganiserActivityId] = A.[OrganiserActivityId]
		LEFT JOIN CRM..TEntityOrganiserActivity EO on A.[OrganiserActivityId] = EO.[OrganiserActivityId]
		LEFT JOIN CRM..TCRMContact L on L.[CRMContactId] = K.[OwnerPartyId]
		LEFT JOIN ADMINISTRATION..TUser M on M.[CRMContactId] = L.[CRMContactId]
		LEFT JOIN CRM..TAttachment TA ON TA.[EmailId] = K.[EmailId]

	--Check for Tenant
	WHERE M.[IndigoClientId] = @TenantId
	--Records for User.
	AND (M.UserId = @UserId AND EO.EntityId IS NULL)
	AND (@DateCompletedEnd IS NULL OR K.SentDate <= @DateCompletedEnd OR (@DateCompletedStart IS NULL AND K.SentDate IS NULL))
	AND (@DateCompletedStart IS NULL OR K.SentDate >= @DateCompletedStart)
END

 UPDATE #TempEmails SET CarbonCopy = 1
 FROM TEmailAddress EA
 WHERE  EA.EmailId = #TempEmails.EmailId AND EA.IsCCAddress = 1 AND EA.Address != ''

 SELECT
    [OrganiserActivityId],
	[SentDate],
	[Subject],
	[OwnerName],
	CAST([HasAttachments] AS BIT) AS [HasAttachments],
	CAST([CarbonCopy] AS BIT) AS [CarbonCopy]
FROM #TempEmails
ORDER BY [SentDate] DESC

GO