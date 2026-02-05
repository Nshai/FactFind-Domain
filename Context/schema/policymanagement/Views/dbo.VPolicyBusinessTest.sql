SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPolicyBusinessTest]

AS

SELECT
	PB.*,
	PO.CRMContactId As PolicyOwnerCRMContactId
FROM
	PolicyManagement..TPolicyBusiness PB
	Join PolicyManagement..TPolicyOwner PO On PO.PolicyDetailId = PB.PolicyDetailId
/*	JOIN 
		(
			SELECT
				PolicyDetailId,
				Min(CRMContactId) AS PolicyOwnerCRMContactId
			FROM
				PolicyManagement..TPolicyOwner
			GROUP BY
				PolicyDetailId
		) PO ON PO.PolicyDetailId = PB.PolicyDetailId
*/
GO
