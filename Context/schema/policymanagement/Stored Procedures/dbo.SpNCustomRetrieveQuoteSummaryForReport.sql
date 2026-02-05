SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteSummaryForReport] @QuoteId Bigint  
AS    
  
/*  
NB: Temp measure to allow Quotation Analysis Report to work  
New SP for APe2  
*/  
  
Begin  
  
 --For Term Get - Product, IllustrationDate, ValidUntil, LivesAssured, SumAssured, Term -   
 --For PHI Get  - Product, IllustrationDate, ValidUntil, Salary, Premium Level, Cover Period - until age:65 or 20 years  
  
 --Identify quote product group  
 declare @RefProductGroupId bigint,
	@RefApplicationId bigint,
	@RefProductGroupIdPensions bigint, 
	@RefProductGroupIdBonds bigint,
	@RefProductGroupIdAnnuities bigint,
	@RefApplicationIdAssureweb bigint
 
 SELECT @RefApplicationIdAssureweb = 1
 SELECT @RefProductGroupIdPensions = 4
 SELECT @RefProductGroupIdBonds = 5
 SELECT @RefProductGroupIdAnnuities = 6
  
 SELECT 
	@RefProductGroupId = pg.RefProductGroupId,
	@RefApplicationId = q.RefApplicationId
 FROM 
	 TQuote q  
	 INNER JOIN trefproducttype pt on pt.refproducttypeid = q.refproducttypeid  
	 INNER JOIN trefproductgroup pg on pg.refproductgroupid = pt.refproductgroupid  
 WHERE 
	q.QuoteId = @QuoteId  
  
 --Term Selection  
 if @RefProductGroupId = 1  
 Begin  
  
  SELECT         
  1 AS tag,        
  NULL AS parent,  
  'Term' AS [QuoteSummary!1!productGroup!element],  
  rpt.ProductTypeName AS [QuoteSummary!1!productType!element],  
  Convert(datetime, q.MessageDateTime, 103) AS [QuoteSummary!1!illustrationDate!element],  
  Convert(datetime, DateAdd(m, 1, q.MessageDateTime), 103) AS [QuoteSummary!1!expiryDate!element], --we don't have Validuntil for a quote; so assume valid for a month  
  Case When IsNull(tq.LivesAssuredBasis,'') = '' Then 'First Life' Else tq.LivesAssuredBasis End AS [QuoteSummary!1!livesAssured!element],    
  --ORG Case When IsNull(q.QuoteClientId2,0) <> 0 Then 'Joint Lives' Else 'First Life' End AS [QuoteSummary!1!livesAssured!element],    
  
  Case When qb.QuotationBasisType = 'Benefit' Then qb.MinValue End AS [QuoteSummary!1!sumAssuredMin!element],  
  Case When qb.QuotationBasisType = 'Benefit' Then qb.MaxValue End AS [QuoteSummary!1!sumAssuredMax!element],  
  Case When qb.QuotationBasisType = 'Premium' Then qb.MinValue End AS [QuoteSummary!1!premiumAmountMin!element],  
  Case When qb.QuotationBasisType = 'Premium' Then qb.MaxValue End AS [QuoteSummary!1!premiunAmountMax!element], 

  CAse ISNULL(qb.QuotationBasisType,'')
	WHEN '' THEN QT.sumAssuredMin END AS [QuoteSummary!1!sumAssuredMin!element] ,
  CAse ISNULL(qb.QuotationBasisType,'')
	WHEN '' THEN QT.sumAssuredMax End AS [QuoteSummary!1!sumAssuredMax!element],  
  Convert(varchar(10), pt.Value) + ' ' + pt.TermType AS [QuoteSummary!1!term!element],
  CID.CriticalIllnessTPDAmount [QuoteSummary!1!CriticalIllnessTPDAmount!element]  
  
  From TQuote q  
  Inner Join TRefProductType rpt on rpt.refProductTypeid = q.refProductTypeid  
  Left Join TTermQuote tq on tq.quoteid = q.quoteid  
  Left Join TProductTerm pt on pt.productTermid = tq.productTermid  
  Left Join TQuotationBasis qb on qb.quotationBasisid = tq.quotationBasisid 
 LEFT JOIN(
	SELECT MIN(B.CoverAmount)'sumAssuredMin',MAX(B.CoverAmount)'sumAssuredMax',a.QuoteId
	FROM TQuoteItem A
	JOIN TQuoteTerm B ON A.QuoteItemId=B.QuoteItemId
	WHERE A.QuoteId=@QuoteId
	Group By A.QuoteId)QT ON q.QuoteId=QT.QuoteId 
  LEFT JOIN TCoverBasis CB ON CB.QuoteId = Q.QuoteId
  LEFT JOIN TCriticalIllnessDetail CID ON CID.CriticalIllnessDetailId = CB.CriticalIllnessDetailId
  
  Where q.QuoteId = @QuoteId  
 
  
  for xml explicit   
  
 End  
  
  
 --PHI Selection
  if @RefProductGroupId = 2  

 Begin  

    SELECT         

  1 AS tag,        

  NULL AS parent,  

  'PHI' AS [QuoteSummary!1!productGroup!element],  

  rpt.ProductTypeName AS [QuoteSummary!1!productType!element],  

  Convert(datetime, q.MessageDateTime, 103) AS [QuoteSummary!1!illustrationDate!element],  

  Convert(datetime, DateAdd(m, 1, q.MessageDateTime), 103) AS [QuoteSummary!1!expiryDate!element], --we don't have Validuntil for a quote; so assume valid for a month  
  
  Convert(datetime, crm.dob, 103) AS [QuoteSummary!1!dateOfBirth!element],  
  
  Case 
	When ipq.employmentStatus = 'SelfEmployed' Then 'Self Employed'
	When ipq.employmentStatus = 'HousePerson' Then 'House Person'
	Else ipq.employmentStatus 
  End AS [QuoteSummary!1!employmentStatus!element],  

  Case 
	When ipq.EmploymentStatus = 'Employed' Or ipq.EmploymentStatus = 'SelfEmployed' Then oc.Description 
	Else '' 
  End AS [QuoteSummary!1!occupation!element],  

  ipq.AnnualEarnedIncome AS [QuoteSummary!1!salary!element],  

  p.IsSmoker AS [QuoteSummary!1!smoker!element],  

  qb.QuotationBasisType AS [QuoteSummary!1!quotationBasisType!element],  

  Case 
  	When qb.QuotationBasisType = 'Benefit' And qb.MinValue = 0 Then 'Maximum'
	When qb.QuotationBasisType = 'Benefit' And qb.MinValue > 0 Then 'Monthly Benefit'
	When qb.QuotationBasisType = 'Premium' Then 'Premium Amount'
  End AS [QuoteSummary!1!benefit!element],  
  
  Case 
  	When qb.QuotationBasisType = 'Benefit' And qb.MinValue > 0 Then mb.Amount
	When qb.QuotationBasisType = 'Premium' Then qb.MinValue
  End AS [QuoteSummary!1!benefitAmount!element],  

  Case
	When qp.Frequency = 0 Then 'Monthly'
	When qp.Frequency = 1 Then 'Annual'
	Else ''
  End AS [QuoteSummary!1!premiumFrequency!element],  

  Case 
	When qp.Type = 1 Then 'Guaranteed Only'
	When qp.Type = 2 Then 'Reviewable Only'
	Else 'All Premium Types'
  End AS [QuoteSummary!1!premiumType!element],  

  Case
	When qb.RateOfIncrease = 'OnePercent' Then '1%'
	When qb.RateOfIncrease = 'TwoPercent' Then '2%'
	When qb.RateOfIncrease = 'ThreePercent' Then '3%'
	When qb.RateOfIncrease = 'FourPercent' Then '4%'
	When qb.RateOfIncrease = 'FivePercent' Then '5%'
	When qb.RateOfIncrease = 'SixPercent' Then '6%'
	When qb.RateOfIncrease = 'SevenPercent' Then '7%'
	When qb.RateOfIncrease = 'EightPercent' Then '8%'
	When qb.RateOfIncrease = 'NinePercent' Then '9%'
	When qb.RateOfIncrease = 'TenPercent' Then '10%'
	Else qb.RateOfIncrease 
  End AS [QuoteSummary!1!premiumLevel!element],  

  Case 
	When mb.DeferredPeriod = 'ZeroWeeksZeroMonths' Then '0 weeks / 0 months'
	When mb.DeferredPeriod = 'OneWeekQuarterMonth' Then '1 week / 1/4 month'
	When mb.DeferredPeriod = 'TwoWeeksHalfMonth' Then '2 weeks / 1/2 month'
	When mb.DeferredPeriod = 'FourWeeksOneMonth' Then '4 weeks / 1 month'
	When mb.DeferredPeriod = 'EightWeeksTwoMonths' Then '8 weeks / 2 months'
	When mb.DeferredPeriod = 'ThirteenWeeksThreeMonths' Then '13 weeks / 3 months'
	When mb.DeferredPeriod = 'TwentySixWeeksSixMonths' Then '26 weeks / 6 months'
	When mb.DeferredPeriod = 'FiftyTwoWeeksTwelveMonths' Then '52 weeks / 12 months'
	When mb.DeferredPeriod = 'HundredAndFourWeeksTwentyFourMonths' Then '104 weeks / 24 months'
	Else ''
  End AS [QuoteSummary!1!deferredPeriod!element], 

  pt.TermType AS [QuoteSummary!1!termType!element],

  Case 
	When pt.TermType = 'Age' Then 'Until Age ' + Convert(varchar(10), pt.Value) 
	Else Convert(varchar(10), pt.Value) + ' Year(s)' 
  End AS [QuoteSummary!1!coverPeriod!element]  

  From TQuote q  

  Inner Join TRefProductType rpt on rpt.refProductTypeid = q.refProductTypeid  

  Left Join TIncomeProtectionQuote ipq on ipq.quoteid = q.quoteid  

  Left Join TProductTerm pt on pt.productTermid = ipq.productTermid  

  Left Join TQuotationBasis qb on qb.quotationBasisid = ipq.quotationBasisid  

  Inner Join CRM..TCRMContact crm on crm.CRMContactId = q.CRMContactId1
  
  Inner Join CRM..TPerson p on p.PersonId = crm.PersonId

  Inner Join TQuoteClient qc on qc.QuoteClientId = q.QuoteClientId1

  Left Join CRM..TRefOccupation oc on oc.RefOccupationId = qc.RefOccupationId

  Left Join TMonthlyBenefit mb on mb.MonthlyBenefitId = ipq.InitialMonthlyBenefitId

  Left Join TQuotePremium qp on qp.QuotePremiumId = ipq.QuotePremiumId

  Where q.QuoteId = @QuoteId  
  
  for xml explicit   

 End  


 IF @RefProductGroupId = @RefProductGroupIdPensions AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN
		
	SELECT
		1 AS TAG,
		NULL AS Parent,
		'Pension' AS [QuoteSummary!1!productGroup!element],
		RPT.ProductTypeName AS [QuoteSummary!1!productType!element],
		CONVERT(DATETIME, Q.MessageDateTime, 103) AS [QuoteSummary!1!illustrationDate!element],
		QuoteInternal.value('(//ExpirationDate/text())[1]','DateTime') AS [QuoteSummary!1!expiryDate!element],
		QuoteInternal.value('(//RetirementAge/text())[1]','VARCHAR(50)') AS [QuoteSummary!1!retirementAge!element],
		QuoteInternal.value('(//PremiumFrequency/text())[1]','VARCHAR(50)')  AS [QuoteSummary!1!premiumFrequency!element]
	FROM
		TQuote Q
		JOIN TRefProductType RPT ON RPT.RefProductTypeId = Q.RefProductTypeId
	WHERE
		QuoteId = @QuoteId 
	FOR 
		XML EXPLICIT
 
 END
 
 IF @RefProductGroupId = @RefProductGroupIdBonds AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN
 
	SELECT
		1 AS TAG,
		NULL AS Parent,
		'Bond' AS [QuoteSummary!1!productGroup!element],
		RPT.ProductTypeName AS [QuoteSummary!1!productType!element],
		CONVERT(DATETIME, Q.MessageDateTime, 103) AS [QuoteSummary!1!illustrationDate!element],
		QuoteInternal.value('(//ExpirationDate/text())[1]','DateTime') AS [QuoteSummary!1!expiryDate!element],
		QuoteInternal.value('(//AssurewebQuoteLifeBasis/text())[1]','VARCHAR(50)') AS [QuoteSummary!1!livesAssured!element],
		CONVERT(decimal(19,2),QuoteRequestedAmount) AS [QuoteSummary!1!investmentAmount!element],
		Term AS [QuoteSummary!1!term!element]
	FROM
		TQuote Q
		JOIN TRefProductType RPT ON RPT.RefProductTypeId = Q.RefProductTypeId
	WHERE
		QuoteId = @QuoteId 
	FOR 
		XML EXPLICIT		
 
 END

 IF @RefProductGroupId = @RefProductGroupIdAnnuities AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

	SELECT
		1 AS TAG,
		NULL AS Parent,
		'Annuities' AS [QuoteSummary!1!productGroup!element],
		RPT.ProductTypeName AS [QuoteSummary!1!productType!element],
		CONVERT(DATETIME, Q.MessageDateTime, 103) AS [QuoteSummary!1!illustrationDate!element],
		QuoteInternal.value('(//ExpirationDate/text())[1]','DateTime') AS [QuoteSummary!1!expiryDate!element],
		COALESCE(C.CorporateName, ISNULL(C.FirstName,'') + ' ' + ISNULL(C.LastName,'')) AS [QuoteSummary!1!annuitant!element],
		CONVERT(decimal(19,2),QuoteRequestedAmount) AS [QuoteSummary!1!purchaseAmount!element]
	FROM
		TQuote Q
		JOIN TRefProductType RPT ON RPT.RefProductTypeId = Q.RefProductTypeId
		JOIN TQuoteClient QC ON QC.QuoteClientId = Q.QuoteClientId1
		JOIN CRM..TCRMContact C ON C.CRMContactId = QC.ClientPartyId
	WHERE
		QuoteId = @QuoteId 
	FOR 
		XML EXPLICIT
   
 END
   
  
End
GO
