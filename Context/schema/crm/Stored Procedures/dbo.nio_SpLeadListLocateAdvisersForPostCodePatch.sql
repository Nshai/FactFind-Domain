SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpLeadListLocateAdvisersForPostCodePatch]  
	@TenantId BIGINT,
	@PostCode varchar (20),
	@PostCodeLatitudeX decimal(18,8),
	@PostCodeLongitudeY decimal(18,8)
AS  

BEGIN

Create table #adviserbypostcodepatch
(CrmContactId bigint)
Insert #adviserbypostcodepatch
Select pagaa.CrmContactId from crm..TPostCodeAllocationGroupAdviserAssigned as pagaa
  Inner Join crm..TPostCodeAllocationGroup as pag
  On (pagaa.PostCodeAllocationGroupId = pag.PostCodeAllocationGroupId)
  Inner Join crm..TPostCodeAllocationGroupPostCodeAssigned as pagpa
  On (pagpa.PostCodeAllocationGroupId = pag.PostCodeAllocationGroupId)
  Inner Join crm..TPostCode as pc
  On (pagpa.PostCodeId = pc.PostCodeId)
  Where ltrim(rtrim(@PostCode)) is not null 
  And ltrim(rtrim(@PostCode)) != ''
  And len(ltrim(rtrim(@PostCode))) >= 3
  And @PostCode not like '--%'
  And @PostCode not like '-%-'
  And replace(@PostCode,char(32),'') != ''
  And replace(@PostCode,char(32),'') is not null
  And pc.PostCodeShortName = RTrim(LTrim(SUBSTRING(@PostCode,1,LEN(@PostCode)-3)))

SELECT  
    Adviser.CRMContactId AS AdviserCRMId,   
	Adviser.PractitionerId AS AdviserId,
    isnull ( AddressDistance.DistanceToLead, 0) AS DistanceToLead,  
	TotalLeads.LeadCount,  
	LatestLead.MaxAssignedDate As MostRecentLead
   
	FROM TPractitioner Adviser  WITH(NOLOCK)
	INNER JOIN TCRMContact CRMContact WITH(NOLOCK) 
					ON CRMContact.CRMContactId = Adviser.CRMContactId  

	LEFT JOIN
		(
			SELECT 
				adv.PractitionerId,  
				ISNULL (COUNT(lead.LeadId), 0) AS LeadCount
			FROM TPractitioner adv  WITH(NOLOCK)
				LEFT JOIN TCRMContact crm WITH(NOLOCK) ON crm.CurrentAdviserCRMId = adv.CRMContactId  
				LEFT JOIN TLead lead WITH(NOLOCK) ON crm.CRMContactId = lead.CRMContactId  
			GROUP BY adv.PractitionerId
		) AS TotalLeads ON 
		Adviser.PractitionerId = TotalLeads.PractitionerId  
	
	LEFT JOIN 
		(
			SELECT
				adv.PractitionerId, 
				ISNULL(MAX(lah.AssignedDate), '')  AS MaxAssignedDate
			FROM TPractitioner adv  WITH(NOLOCK)
				INNER JOIN TLeadAdviserHistory lah WITH(NOLOCK) ON lah.AdviserId = adv.PractitionerId  
			GROUP BY adv.practitionerid
		) AS LatestLead ON 
		LatestLead.PractitionerId = Adviser.PractitionerId  

  LEFT JOIN TAddress Adr WITH(NOLOCK) ON Adr.CRMContactId = CRMContact.CRMContactId  
  LEFT JOIN 
		(
			SELECT 
				AddressStoreId, 
				ISNULL(dbo.FnCustomGetPostCodeDistance(@PostCodeLatitudeX,@PostCodeLongitudeY,PostCodeLatitudeX,PostCodeLongitudeY),  0 ) AS DistanceToLead
			FROM TAddressStore WITH(NOLOCK)
		) AS AddressDistance ON AddressDistance.AddressStoreId = Adr.AddressStoreId  
  
  Inner Join #adviserbypostcodepatch ad
  On (Adviser.CrmContactId = ad.CrmContactId)
  
  WHERE (Adr.DefaultFg = 1 OR Adr.DefaultFg IS NULL)  
  AND Adviser.IndClientId = @TenantId  
  AND Adviser.AuthorisedFg = 1 
  GROUP BY  
		Adviser.PractitionerId,
		Adviser.CRMContactId,
		AddressDistance.DistanceToLead, 
		TotalLeads.LeadCount, 
		LatestLead.MaxAssignedDate

ORDER BY Adviser.CRMContactId
  
END


GO
