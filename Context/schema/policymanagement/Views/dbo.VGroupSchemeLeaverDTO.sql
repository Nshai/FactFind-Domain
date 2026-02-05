SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VGroupSchemeLeaverDTO 
AS

SELECT 
	GSM.GroupSchemeMemberId,
	GS.GroupSchemeId,
	GSMC.CRMContactId AS LeaverCRMContactId,
	GSMP.FirstName+' '+GSMP.LastName AS LeaverFullName,
	GSMP.DOB AS LeaverDateOfBirth,
	GSMCat.CategoryName AS GroupSchemeCategoryName,
	PP.FirstName+' '+PP.LastName AS SellingAdviserName,
	AT.Description AS AdviceTypeName,
	SHFiltered.ChangedToDate AS OutOfForceDate,
	SR.Name AS OutOfForceReason,
	I.IndigoClientId AS TenantId,
	GSM.LeavingDate
FROM 
	PolicyManagement.dbo.TGroupScheme GS
	JOIN PolicyManagement.dbo.TGroupSchemeMember GSM
		ON GSM.GroupSchemeId = GS.GroupSchemeId
		AND ISNULL(GSM.IsLeaver, 0) = 1
	JOIN CRM.dbo.TCRMContact GSMC
		ON GSMC.CRMContactId = GSM.CRMContactId
	JOIN CRM.dbo.TPerson GSMP
		ON GSMP.PersonId = GSMC.PersonId
	JOIN PolicyManagement.dbo.TGroupSchemeCategory GSMCat
		ON GSMCat.GroupSchemeCategoryId = GSM.GroupSchemeCategoryId
	LEFT JOIN PolicyManagement.dbo.TPolicyBusiness PB
		ON PB.PolicyBusinessId = GSM.PolicyBusinessId
	LEFT JOIN CRM.dbo.TPractitioner P
		ON P.PractitionerId = PB.PractitionerId
	LEFT JOIN CRM..TCRMContact PC
		ON PC.CRMContactId = P.CRMContactId
	LEFT JOIN CRM.dbo.TPerson PP
		ON PP.PersonId = PC.PersonId
	LEFT JOIN PolicyManagement.dbo.TAdviceType AT
		ON AT.AdviceTypeId = PB.AdviceTypeId
	LEFT JOIN
		(
		SELECT
			Max(StatusHistoryId) AS StatusHistoryId,
			PolicyBusinessId
		FROM
			PolicyManagement.dbo.TStatusHistory SH
		JOIN PolicyManagement.dbo.TStatus S
			ON S.StatusId = SH.StatusId
			AND S.IntelligentOfficeStatusType = 'Off Risk'
		GROUP BY
			PolicyBusinessId
		) OutOfForceFilter
		ON OutOfForceFilter.PolicyBusinessId = PB.PolicyBusinessId
	LEFT JOIN PolicyManagement.dbo.TStatusHistory SHFiltered
		ON SHFiltered.StatusHistoryId = OutOfForceFilter.StatusHistoryId
	LEFT JOIN PolicyManagement.dbo.TStatusReason SR
		ON SR.StatusReasonId = SHFiltered.StatusReasonId
	JOIN Administration.dbo.TIndigoClient I
		ON I.IndigoClientId = GS.TenantId
GO
