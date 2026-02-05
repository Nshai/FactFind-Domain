SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpNioCustomPolicyBusinessForExternalSystemByPolicyNumber 	
	@PolicyNumber VARCHAR(255), 
	@IndigoClientId BIGINT 
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT	p.policybusinessid				AS PolicyBusinessId,
			p.SequentialRef					AS SequentialRef,
			p.policynumber					AS PolicyNumber,
			PExt.ApplicationReference		AS PolicyArnNumber,
			pld.refplantype2prodsubtypeid   AS ProductTypeId,
			po.CRMContactId					AS PrimaryOwnerPartyId,
			O1CE.ExternalId					AS PrimaryOwnerExternalId,
			O1C.FirstName					AS PrimaryOwnerFirstName,
			O1C.LastName					AS PrimaryOwnerLastName,
			O1C.DOB							AS PrimaryOwnerDoB,
			ISNULL(PA1.AgencyNumber,'')		AS PrimaryOwnerAgencyNumber,
			po2.CRMContactId				AS SecondaryOwnerPartyId,
			O2CE.ExternalId					AS SecondaryOwnerExternalId,
			O2C.FirstName					AS SecondaryOwnerFirstName,
			O2C.LastName					AS SecondaryOwnerLastName,
			O2C.DOB							AS SecondaryOwnerDoB,
			ISNULL(PA2.AgencyNumber,'')		AS SecondaryOwnerAgencyNumber,
			p.indigoclientid				AS IndigoClientId,
			p.PolicyDetailId				AS PolicyDetailId,
			ISNULL(S.IntelligentOfficeStatusType,'')		AS CurrentStatus   
    FROM
			policymanagement..tpolicybusiness p
    LEFT JOIN PolicyManagement..TPolicyBusinessExt PExt WITH(NOLOCK) ON PExt.PolicyBusinessId = p.PolicyBusinessId   
    JOIN policymanagement..tpolicydetail pd WITH(NOLOCK) ON pd.policydetailid = p.policydetailid
    JOIN
    (
		SELECT
				MIN(PolicyOwnerId) AS PolicyOwnerId1,
				MAX(PolicyOwnerId) AS PolicyOwnerId2,
				PolicyDetailId
		FROM
				policymanagement..tpolicyowner
		GROUP BY
				PolicyDetailId
    ) Owners ON Owners.PolicyDetailId = pd.PolicyDetailId
    
    JOIN policymanagement..tpolicyowner po WITH(NOLOCK) ON po.PolicyOwnerId = Owners.PolicyOwnerId1
    JOIN CRM..TCRMContact O1C WITH(NOLOCK) ON O1C.CRMContactId = po.CRMContactId
    LEFT JOIN CRM..TCRMContactExt O1CE WITH(NOLOCK) ON O1CE.CRMContactId = O1C.CRMContactId

	JOIN CRM..TPractitioner P1 WITH(NOLOCK) ON P1.CRMContactId = O1C.CurrentAdviserCRMId
	LEFT JOIN CRM..TAgencyNumber PA1 WITH(NOLOCK) ON PA1.PractitionerId = P1.PractitionerId
	AND PA1.RefProdProviderId = 199  	
	
    LEFT JOIN policymanagement..tpolicyowner po2 WITH(NOLOCK) ON po2.PolicyOwnerId = Owners.PolicyOwnerId2
    AND (Owners.PolicyOwnerId2 != Owners.PolicyOwnerId1)
    LEFT JOIN CRM..TCRMContact O2C WITH(NOLOCK) ON O2C.CRMContactId = po2.CRMContactId
    LEFT JOIN CRM..TCRMContactExt O2CE WITH(NOLOCK) ON O2CE.CRMContactId = O2C.CRMContactId

	LEFT JOIN CRM..TPractitioner P2 WITH(NOLOCK) ON P2.CRMContactId = O2C.CurrentAdviserCRMId
	LEFT JOIN CRM..TAgencyNumber PA2 WITH(NOLOCK) ON PA2.PractitionerId = P2.PractitionerId
	AND PA2.RefProdProviderId = 199  	
	
    JOIN policymanagement..tplandescription pld WITH(NOLOCK) ON pld.plandescriptionid = pd.plandescriptionid 
    
    JOIN PolicyManagement..TStatusHistory SH ON SH.PolicyBusinessId = P.PolicyBusinessId
			AND SH.CurrentStatusFG = 1
    JOIN PolicyManagement..TStatus S ON S.StatusId = SH.StatusId
    
    WHERE  p.PolicyNumber = @PolicyNumber AND p.indigoclientid = @IndigoClientId
END
GO