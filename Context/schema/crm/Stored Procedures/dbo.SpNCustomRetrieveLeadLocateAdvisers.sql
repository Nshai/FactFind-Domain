SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLeadLocateAdvisers]
  @TenantId           INT,
  @PostCodeLatitudeX  DECIMAL(18,8),
  @PostCodeLongitudeY DECIMAL(18,8)
AS
BEGIN
	SET NOCOUNT ON;
	------------------------------------------------------------------------
	-- 1) Stage active practitioners for this tenant
	------------------------------------------------------------------------
	DROP TABLE IF EXISTS #Practitioners, #LeadCounts, #LatestLead, #Stats, #AddressDistances;

	CREATE TABLE #Practitioners (PractitionerId int NOT NULL, CRMContactId int NULL, AuthorisedFG bit NOT NULL)
	CREATE TABLE #LeadCounts (PractitionerId INT, LeadCount INT)
	CREATE TABLE #LatestLead (PractitionerId INT, MostRecentLeadDate datetime)
	CREATE TABLE #Stats (PractitionerId INT, LeadCount INT, MostRecentLeadDate datetime)
	CREATE TABLE #AddressDistances (PractitionerId INT, DistanceToLead Decimal (18,8), DefaultFg bit)
  
	INSERT #Practitioners
	SELECT
		PractitionerId,
		CRMContactId, 
		AuthorisedFG
	FROM crm.dbo.TPractitioner WITH(NOLOCK)
	WHERE
		IndClientId    = @TenantId 

	----------------------------------------------------------------------------
	-- 2a) Build #LeadCounts: exactly one row per adviser with true lead count
	----------------------------------------------------------------------------
	INSERT #LeadCounts
	SELECT
		p.PractitionerId,
		LeadCount = COUNT(1)
	FROM #Practitioners p
	INNER JOIN crm.dbo.TCRMContact crm2 WITH(NOLOCK)
		ON crm2.CurrentAdviserCRMId = p.CRMContactId
	INNER JOIN crm.dbo.TLead lead WITH(NOLOCK)
		ON lead.CRMContactId = crm2.CRMContactId
	GROUP BY
		p.PractitionerId;
	----------------------------------------------------------------------------
	-- 2b) Build #LatestLead: exactly one row per adviser with the most recent date
	----------------------------------------------------------------------------
	INSERT #LatestLead
	SELECT
	  lah.AdviserId         AS PractitionerId,
	  MostRecentLeadDate    = MAX(lah.AssignedDate)
	FROM #Practitioners p
	INNER JOIN crm.dbo.TLeadAdviserHistory lah WITH(NOLOCK)
	  ON lah.AdviserId = p.PractitionerId
	GROUP BY
	lah.AdviserId;

	----------------------------------------------------------------------------
	-- 2c) Merge them into #Stats (one row per adviser, zero-defaults if missing)
	----------------------------------------------------------------------------
	INSERT #Stats
	SELECT
	  p.PractitionerId,
	  LeadCount          = ISNULL(lc.LeadCount, 0),
	  MostRecentLeadDate = ll.MostRecentLeadDate
	FROM #Practitioners p
	LEFT JOIN #LeadCounts lc
	  ON lc.PractitionerId = p.PractitionerId
	LEFT JOIN #LatestLead ll
	  ON ll.PractitionerId = p.PractitionerId;
	
	------------------------------------------------------------------------
	-- 3) Pre-compute each advisers DistanceToLead via scalar UDF
	--    We pick the one address per adviser whose DefaultFg=1 if present,
	--    otherwise any address, then call your UDF once.
	------------------------------------------------------------------------
	INSERT #AddressDistances
	SELECT
		p.PractitionerId,
		DistanceToLead = crm.dbo.FnCustomGetPostCodeDistance(
                        @PostCodeLatitudeX,
                        @PostCodeLongitudeY,
                        a.PostCodeLatitudeX,
                        a.PostCodeLongitudeY
                     ),
					 a.DefaultFg
	FROM #Practitioners p
	OUTER APPLY
	(
		SELECT TOP(1)
		  b.PostCodeLatitudeX,
		  b.PostCodeLongitudeY,
		  a.DefaultFg
		FROM crm.dbo.TAddress a WITH(NOLOCK)
		INNER JOIN crm..TAddressStore b WITH(NOLOCK) on a.AddressStoreId=b.AddressStoreId
		WHERE
			a.CRMContactId = p.CRMContactId
			AND a.IndClientId = @TenantId
		ORDER BY
		-- default addresses first, then tie-break by AddressStoreId
		CASE WHEN a.DefaultFg = 1 THEN 0 ELSE 1 END,
			a.AddressStoreId
	) AS a;

	------------------------------------------------------------------------
	-- 4) Final SELECT: join staging tables + enrich with names & groups
	------------------------------------------------------------------------
	SELECT
		p.CRMContactId               AS CrmContactId,
		p.PractitionerId             AS AdviserId,
		c.FirstName                  AS AdviserFirstName,
		c.LastName                   AS AdviserLastName,
		grping.Identifier            AS GroupingName,
		grp.Identifier               AS GroupName,
		ISNULL(d.DistanceToLead, 0)  AS DistanceToLead,
		ISNULL(s.LeadCount,   0)     AS TotalLeads,
		s.MostRecentLeadDate         AS MostRecentLeadDate
	FROM #Practitioners p
	-- Adviser personal details
	INNER JOIN crm.dbo.TCRMContact c WITH(NOLOCK)
		ON c.CRMContactId = p.CRMContactId
	-- Team / group membership
	INNER JOIN administration..TUser usr WITH(NOLOCK)
		ON usr.CRMContactId = c.CRMContactId
	INNER JOIN administration..TGroup grp WITH(NOLOCK)
		ON grp.GroupId = usr.GroupId
	INNER JOIN administration..TGrouping grping WITH(NOLOCK)
		ON grping.GroupingId = grp.GroupingId
	-- Pre-aggregated lead stats
	LEFT JOIN #Stats s
		ON s.PractitionerId = p.PractitionerId
		-- Pre-computed address distances
	LEFT JOIN #AddressDistances d
		ON d.PractitionerId = p.PractitionerId
	Where AuthorisedFG=1
		AND (d.DefaultFg = 1 OR d.DefaultFg IS NULL)
	ORDER BY
		p.CRMContactId;
	------------------------------------------------------------------------
	-- 5) Clean up (optional temp tables auto-drop at session end)
	------------------------------------------------------------------------
	DROP TABLE #AddressDistances;
	DROP TABLE #Stats;
	DROP TABLE #Practitioners;
END
GO
