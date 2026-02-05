SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create VIEW [dbo].[VPlanDescription]

AS

SELECT
	PDesc.*,
	p.CRMContactId As SchemeSellingAdvisorCRMContactId
FROM PolicyManagement..TPlanDescription PDesc
LEFT JOIN CRM..TPractitioner P ON P.PractitionerId = PDesc.SchemeSellingAdvisorPractitionerId
GO
