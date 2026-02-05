SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveclientPortfolioFunds]
@UserId bigint,
@cid bigint

as
set transaction isolation level read uncommitted
DECLARE @cid2 bigint

DECLARE @IndigoClientId bigint

SET @indigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @cid)


SELECT 
isnull(substring(pbf.CategoryName, 1,15),'Unknown') as CategoryName,
isnull(sum(pbf.CurrentUnitQuantity * pbf.CurrentPrice),0) as FundValue


FROM TPolicyBusinessFund pbf

JOIN TPolicyBusiness Pb ON pb.policyBusinessId = pbf.POlicyBusinessId
JOIN TPOlicyDetail pd ON Pb.PolicyDetailId = Pd.PolicyDetailId AND Pb.IndigoClientId = @IndigoClientId
JOIN ( 	SELECT 
	MIN(CRMContactId) AS CRMContactId,			
	PolicyDetailId
	FROM TPolicyOwner 
	WHERE CRMContactId IN (@cid, @cid2)
	GROUP BY PolicyDetailId	) 
AS Po ON Po.PolicyDetailId = Pd.PolicyDetailId
JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg=1
JOIN TStatus S ON S.StatusId = Sh.StatusId AND S.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')
JOIN TPlanDescription PDesc ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId 
JOIN TRefPlanType Rpt ON Rpt.RefPlanTypeId = P2P.RefPlanTypeId

GROUP BY pbf.CategoryName

FOR XML RAW
GO
