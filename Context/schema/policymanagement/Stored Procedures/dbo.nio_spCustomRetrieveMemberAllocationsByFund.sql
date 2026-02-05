SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_spCustomRetrieveMemberAllocationsByFund]
	@PolicyBusinessFundId bigint	
AS  
SELECT	
	m.crmcontactid AS [PartyId],
	pbfo.PolicyBusinessFundOwnerId AS [PolicyBusinessFundOwnerId],
	pbf.PolicyBusinessFundId AS [PolicyBusinessFundId],
	pbf.PolicyBusinessId AS [PolicyBusinessId],
	CASE  
		WHEN pbf.FundTypeId < 10 THEN 'Fund'  
		WHEN pbf.FundTypeId > 9 THEN 'Equity'  
	END AS [Type],  
	
	CASE
		WHEN c.PersonId IS NOT NULL THEN FirstName + ' ' +  Lastname  
		ELSE c.CorporateName
	END	AS [FullName],
	ISNULL(PercentageHeld,0) AS [PercentageHeld],
	CAST(ISNULL(((currentUnitQuantity*CurrentPrice)/100) * ISNULL(PercentageHeld,0),0) AS MONEY) AS [AmountHeld],
	CAST((currentUnitQuantity*CurrentPrice) AS MONEY) AS [TotalValue]
FROM TMember m
	INNER JOIN CRM..TCRMContact c ON c.crmcontactid = m.crmcontactid
	INNER JOIN TPolicyBusinessFund pbf ON pbf.PolicyBusinessId = m.PolicyBusinessId
	LEFT JOIN TPolicyBusinessFundOwner pbfo ON pbfo.PolicyBusinessFundId = pbf.PolicyBusinessFundId AND pbfo.crmcontactid = m.crmcontactid
WHERE pbf.PolicyBusinessFundId = @PolicyBusinessFundId
GO