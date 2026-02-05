 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPartyAdviceCases]	
	@PartyId bigint,
	@RelatedPartyId bigint,
	@TenantId bigint
AS

--DECLARE	@PartyId bigint = 4670733,
--	@RelatedPartyId bigint = 4670731,
--	@TenantId bigint = 10155

if OBJECT_ID('tempdb..#adviceCases') is not null 
DROP TABLE #adviceCases



 SELECT 
	   advicecase.advicecaseid  AS ServiceCaseId,
       advicecase.caseref       AS CaseReference,
       advicecase.sequentialref AS SequentialRef,
       advicecase.casename      AS Name,
       CASE
           WHEN party1.CorporateName IS NULL 
		   THEN party1.firstname + ' '+ party1.lastname                                                         
           ELSE party1.corporatename
       END           AS Owner1,
       CASE
           WHEN party2.CorporateName IS NULL 
		   THEN party2.firstname + ' '+ party2.lastname                                                         
           ELSE party2.corporatename
       END       AS Owner2,
       [status].descriptor AS [Status],
	   cat.Name	AS ServiceCaseCategory,
	   advicecase.Owner1Vulnerability,
	   advicecase.Owner1VulnerabilityNotes,
	   advicecase.Owner2Vulnerability,
	   advicecase.Owner2VulnerabilityNotes
INTO #adviceCases
FROM   crm.dbo.vadvicecase advicecase
       INNER JOIN crm.dbo.tcrmcontact party1
               ON advicecase.crmcontactid = party1.crmcontactid     
       LEFT OUTER JOIN crm.dbo.tcrmcontact party2
               ON advicecase.owner2partyid = party2.crmcontactid     
       INNER JOIN crm.dbo.tadvicecasestatus [status]
               ON advicecase.statusid = [status].advicecasestatusid
	   LEFT JOIN PolicyManagement.dbo.TAdviseCategory cat 
			   ON cat.AdviseCategoryId = advicecase.AdviseCategoryId
WHERE  party1.crmcontactid IN (@PartyId, @RelatedPartyId) AND ISNULL(advicecase.Owner2PartyId, 0) = 0  AND party1.IndClientId = @TenantId 

UNION 

 SELECT 
	   advicecase.advicecaseid  AS ServiceCaseId,
       advicecase.caseref       AS CaseReference,
       advicecase.sequentialref AS SequentialRef,
       advicecase.casename      AS Name,
       CASE
           WHEN party1.CorporateName IS NULL 
		   THEN party1.firstname + ' '+ party1.lastname                                                         
           ELSE party1.corporatename
       END      AS Owner1,
       CASE
           WHEN party2.CorporateName IS NULL 
		   THEN party2.firstname + ' '+ party2.lastname                                                         
           ELSE party2.corporatename
       END      AS Owner2,
       [status].descriptor AS [Status],
	   cat.Name	AS ServiceCaseCategory,
	   advicecase.Owner1Vulnerability,
	   advicecase.Owner1VulnerabilityNotes,
	   advicecase.Owner2Vulnerability,
	   advicecase.Owner2VulnerabilityNotes
FROM   crm.dbo.vadvicecase advicecase
       INNER JOIN crm.dbo.tcrmcontact party1
               ON advicecase.crmcontactid = party1.crmcontactid     
       INNER JOIN crm.dbo.tcrmcontact party2
               ON advicecase.owner2partyid = party2.crmcontactid     
       INNER JOIN crm.dbo.tadvicecasestatus [status]
               ON advicecase.statusid = [status].advicecasestatusid
	   LEFT JOIN PolicyManagement.dbo.TAdviseCategory cat 
			   ON cat.AdviseCategoryId = advicecase.AdviseCategoryId
WHERE  party1.crmcontactid = @PartyId AND party2.crmcontactid = @RelatedPartyId   AND party1.IndClientId = @TenantId 
UNION 
 SELECT 
	   advicecase.advicecaseid  AS ServiceCaseId,
       advicecase.caseref       AS CaseReference,
       advicecase.sequentialref AS SequentialRef,
       advicecase.casename      AS Name,
       CASE
           WHEN party1.CorporateName IS NULL 
		   THEN party1.firstname + ' '+ party1.lastname                                                         
           ELSE party1.corporatename
       END      AS Owner1,
       CASE
           WHEN party2.CorporateName IS NULL 
		   THEN party2.firstname + ' '+ party2.lastname                                                         
           ELSE party2.corporatename
       END      AS Owner2,
       [status].descriptor AS [Status],
	   cat.Name	AS ServiceCaseCategory,
	   advicecase.Owner1Vulnerability,
	   advicecase.Owner1VulnerabilityNotes,
	   advicecase.Owner2Vulnerability,
	   advicecase.Owner2VulnerabilityNotes
FROM   crm.dbo.vadvicecase advicecase
       INNER JOIN crm.dbo.tcrmcontact party1
               ON advicecase.crmcontactid = party1.crmcontactid     
       INNER JOIN crm.dbo.tcrmcontact party2
               ON advicecase.owner2partyid = party2.crmcontactid     
       INNER JOIN crm.dbo.tadvicecasestatus [status]
               ON advicecase.statusid = [status].advicecasestatusid
	   LEFT JOIN PolicyManagement.dbo.TAdviseCategory cat 
			   ON cat.AdviseCategoryId = advicecase.AdviseCategoryId
WHERE  party1.crmcontactid = @RelatedPartyId AND party2.crmcontactid = @PartyId   AND party1.IndClientId = @TenantId 


IF NOT EXISTS(SELECT 1 FROM #adviceCases)

	SELECT 
			CAST(0 AS BIGINT) ServiceCaseId,
			null CaseReference,
			null SequentialRef,
			'No Service Case' Name,
			null Owner1,
			null Owner2,
			null [Status],
			@PartyId AS PartyId,
			@RelatedPartyId AS RelatedPartyId,
			null AS ServiceCaseCategory,
		    null AS Owner1Vulnerability,
		    null AS Owner1VulnerabilityNotes,
		    null AS Owner2Vulnerability,
		    null AS Owner2VulnerabilityNotes
ELSE

	SELECT 
		   advicecase.ServiceCaseId,
		   advicecase.CaseReference,
		   advicecase.SequentialRef,
		   advicecase.Name,
		   advicecase.Owner1,
		   advicecase.Owner2,
		   advicecase.[Status],
		   @PartyId AS PartyId,
		   @RelatedPartyId AS RelatedPartyId,
		   advicecase.ServiceCaseCategory AS ServiceCaseCategory,
		   advicecase.Owner1Vulnerability,
		   advicecase.Owner1VulnerabilityNotes,
		   advicecase.Owner2Vulnerability,
		   advicecase.Owner2VulnerabilityNotes
	FROM #adviceCases advicecase

