SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------
-- Retrieve an existing mortgages for Openwork
---------------------------------------------------------
CREATE PROCEDURE dbo.SpRetrieveExistingMortgages
	@PrimaryClientId bigint,                            
	@RelatedClientId bigint,
	@TenantId bigint
AS

select MortgageId, 
	InterestOnlyAmount, 
	PortableFg as IsPortable, 
	CRM.CorporateName as Lender, 
	MonthlyRepaymentAmount,
	PB.PolicyStartDate,
	PB.MaturityDate,
	M.MortgageTerm,
	MortgageRepaymentMethod,
	M.PolicyBusinessId,
	AddressStoreId,
	M.AssetsId  AssetId,
	GETUTCDATE() as LastUpdate,
	CurrentBalance,
	PO.CRMContactId as OwnerId
from PolicyManagement..TPolicyOwner PO  
	join PolicyManagement..TPolicyBusiness PB on PB.PolicyDetailId = PO.PolicyDetailId
	JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId
	join PolicyManagement..TMortgage M on M.PolicyBusinessId = PB.PolicyBusinessId
	join PolicyManagement..TStatusHistory SH on SH.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1
	join PolicyManagement..TStatus S on S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType = 'In Force'
	left join PolicyManagement..TRefMortgageRepaymentMethod MRM on MRM.RefMortgageRepaymentMethodId = M.RefMortgageRepaymentMethodId
	join PolicyManagement..TPlanDescription PlanD on PlanD.PlanDescriptionId = PD.PlanDescriptionId
	join PolicyManagement..TRefProdProvider PP on PP.RefProdProviderId = PlanD.RefProdProviderId
	join Crm..TCRMContact CRM on CRM.CRMContactId = PP.CRMContactId
where PB.IndigoClientId = @TenantId and PO.CRMContactId in (@PrimaryClientId, @RelatedClientId)

GO