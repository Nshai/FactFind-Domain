SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomGetPartyFPSessions]	
	@PartyId bigint,
	@RelatedPartyId bigint,
	@TenantId bigint
AS

--declare 	@PartyId bigint = 4670733,
--	@RelatedPartyId bigint = null,
--	@TenantId bigint = 10155

SELECT DISTINCT
	   fpsession.financialplanningsessionid		AS FinancialPlanningSessionId,
       fpsession.financialplanningid			AS FinancialPlanningId,
       CAST(servicecas.advicecaseid AS BIGINT)	AS ServiceCaseId,
       fpsession.[description]					AS Name,
       fpsession.[date]							AS [Date],
	   party1.FirstName							AS PrimaryFirstName,
	   party1.LastName							AS PrimaryLastName,
	   party2.FirstName							AS SecondaryFirstName,
	   party2.LastName							AS SecondaryLastName
FROM   factfind.dbo.[tfinancialplanningsession] fpsession
       INNER JOIN crm.dbo.tcrmcontact party1
               ON fpsession.crmcontactid = party1.crmcontactid
       LEFT JOIN crm.dbo.tcrmcontact party2
               ON fpsession.CRMContactId2 = party2.crmcontactid
       LEFT OUTER JOIN crm.dbo.vadvicecase servicecas
                    ON fpsession.servicecaseid = servicecas.advicecaseid
WHERE  party1.crmcontactid IN (@PartyId, @RelatedPartyId)
	    AND ISNULL(fpsession.crmcontactid2, 0) IN (0, @PartyId, @RelatedPartyId )  
		AND party1.IndClientId = @TenantId  
GO
