SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spCustomRetrieveMemberAllocationsByAsset]
	@PolicyBusinessFundId bigint	
AS  
SELECT
	m.crmcontactid as [PartyId],
	pbfo.PolicyBusinessFundOwnerId as [PolicyBusinessFundOwnerId],
	ta.AssetsId as [PolicyBusinessFundId],
	ta.PolicyBusinessId	as [PolicyBusinessId],
	'Asset' as [Type], 
	FirstName + ' ' +  Lastname  as [FullName],
	isnull(PercentageHeld,0) as [PercentageHeld],

	-- The asset amount must be converted to the plan currency.
	cast(isnull( policymanagement.dbo.FnGetCurrencyRate(ta.CurrencyCode, pb.BaseCurrency) * ta.Amount * isnull(PercentageHeld,0)/100, 0) as money) as [AmountHeld],
	cast((policymanagement.dbo.FnGetCurrencyRate(ta.CurrencyCode, pb.BaseCurrency) * ta.Amount) as money) as [TotalValue]
FROM
	FactFind.dbo.TAssets ta 
	JOIN policymanagement..TPolicyBusiness pb ON pb.PolicyBusinessId = ta.PolicyBusinessId
	JOIN TMember m on m.PolicyBusinessId = ta.PolicyBusinessId
	JOIN CRM..TCRMContact c on c.CRMContactId = m.CRMContactId
	LEFT JOIN TPolicyBusinessFundOwner pbfo ON 
		pbfo.PolicyBusinessFundId = ta.AssetsId
		AND pbfo.PolicyBusinessId = ta.PolicyBusinessId
		AND pbfo.CRMContactId = m.CRMContactId 
		AND FundType = 'Asset'
WHERE
	ta.AssetsId = @PolicyBusinessFundId
GO
