SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.[SpCustomRemovePropertyDetail] @StampUser VARCHAR (255), 
                                             @IndigoClientId BIGINT,
											 @PreviousAddressStoreId BIGINT
AS 

SET NOCOUNT ON
DECLARE @PropertyDetails TABLE 
(
PropertyDetailId int
)
BEGIN 

	INSERT INTO @PropertyDetails
	SELECT PropertyDetailId		
	FROM factfind..TPropertyDetail
	WHERE RelatedAddressStoreId = @PreviousAddressStoreId

	DELETE PD
	OUTPUT deleted.ConcurrencyId
      ,deleted.CRMContactId
      ,deleted.CRMContactId2
      ,deleted.[Owner]
      ,deleted.RelatedAddressStoreId
      ,deleted.AddressLine1
      ,deleted.AddressLine2
      ,deleted.AddressLine3
      ,deleted.AddressLine4
      ,deleted.CityTown
      ,deleted.RefCountyId
      ,deleted.RefCountryId
      ,deleted.Postcode
      ,deleted.IsCurrentResidentialAddress
      ,deleted.HouseType
      ,deleted.PropertyType
      ,deleted.TenureType
	  ,deleted.LeaseholdEndsOn
      ,deleted.PropertyStatus
      ,deleted.Construction
      ,deleted.NumberOfBedrooms
      ,deleted.YearBuilt
      ,deleted.IsProspective
      ,deleted.PropertyDetailId
      ,'D'
      ,GETDATE()
      ,@StampUser
      ,deleted.ConstructionNotes
      ,deleted.RoofConstructionType
      ,deleted.RoofConstructionNotes
      ,deleted.IsNewBuild
      ,deleted.NHBCCertificateCovered
      ,deleted.OtherCertificateCovered
      ,deleted.CertificateNotes
      ,deleted.BuilderName
      ,deleted.RefAdditionalPropertyDetailId
      ,deleted.IsExLocalAuthority
      ,deleted.NumberOfOutbuildings
      ,deleted.IsOutbuildings
	INTO TPropertyDetailAudit
	(
		[ConcurrencyId]
		,[CRMContactId]
		,[CRMContactId2]
		,[Owner]
		,[RelatedAddressStoreId]
		,[AddressLine1]
		,[AddressLine2]
		,[AddressLine3]
		,[AddressLine4]
		,[CityTown]
		,[RefCountyId]
		,[RefCountryId]
		,[Postcode]
		,[IsCurrentResidentialAddress]
		,[HouseType]
		,[PropertyType]
		,[TenureType]
		,[LeaseholdEndsOn]
		,[PropertyStatus]
		,[Construction]
		,[NumberOfBedrooms]
		,[YearBuilt]
		,[IsProspective]
		,[PropertyDetailId]
		,[StampAction]
		,[StampDateTime]
		,[StampUser]
		,[ConstructionNotes]
		,[RoofConstructionType]
		,[RoofConstructionNotes]
		,[IsNewBuild]
		,[NHBCCertificateCovered]
		,[OtherCertificateCovered]
		,[CertificateNotes]
		,[BuilderName]
		,[RefAdditionalPropertyDetailId]
		,[IsExLocalAuthority]
		,[NumberOfOutbuildings]
		,[IsOutbuildings]
	)
	FROM factfind..TPropertyDetail PD
	JOIN @PropertyDetails T ON PD.PropertyDetailId = T.PropertyDetailId

    UPDATE O
    SET RelatedAddressStoreId = NULL
    OUTPUT deleted.[OpportunityId]
    ,deleted.[LoanPurpose]
    ,deleted.[LoanAmount]
    ,deleted.[LTV]
    ,deleted.[RefMortgageBorrowerTypeId]
    ,deleted.[Term]
    ,deleted.[RefMortgageRepaymentMethodId]
    ,deleted.[InterestOnly]
    ,deleted.[Repayment]
    ,deleted.[Price]
    ,deleted.[Deposit]
    ,deleted.[PlanPurpose]
    ,deleted.[CurrentLender]
    ,deleted.[CurrentLoanAmount]
    ,deleted.[MonthlyRentalIncome]
    ,deleted.[Owner]
    ,deleted.[RelationshipCRMContactId]
    ,deleted.[EmploymentType]
    ,deleted.[IncomeAmount]
    ,deleted.[RepaymentAmountMonthly]
    ,deleted.[StatusFg]
    ,deleted.[SelfCertFg]
    ,deleted.[NonStatusFg]
    ,deleted.[ExPatFg]
    ,deleted.[ForeignCitizenFg]
    ,deleted.[TrueCostOverTerm]
    ,deleted.[ConcurrencyId]
    ,deleted.[MortgageOpportunityId]
    ,'U'
    ,GETDATE()
    ,@StampUser
    ,deleted.[SourceOfDeposit]
    ,deleted.[InterestOnlyRepaymentVehicle]
    ,deleted.[RelatedAddressStoreId]
    ,deleted.[RepaymentOfExistingMortgage]
    ,deleted.[HomeImprovements]
    ,deleted.[MortgageFees]
    ,deleted.[Other]
    ,deleted.[GuarantorMortgageFg]
    ,deleted.[GuarantorText]
    ,deleted.[DebtConsolidatedFg]
    ,deleted.[DebtConsolidationText]
    ,deleted.[RepaymentTerm]
    ,deleted.[InterestOnlyTerm]
    ,deleted.[DebtConsolidation]
    ,deleted.[Details]
    ,deleted.[InterestDetails]
    ,deleted.[RefMortgageSaleTypeId]
    ,deleted.[IsHighNetWorthClient]
    ,deleted.[IsMortgageForBusiness]
    ,deleted.[IsProfessionalClient]
    ,deleted.[IsRejectedAdvice]
    ,deleted.[ExecutionOnlyDetails]
    ,deleted.[RefOpportunityType2ProdSubTypeId]
    ,deleted.[IsFirstTimeBuyer]
    ,deleted.[RefEquityReleaseTypeId]
    ,deleted.[PercentageOwnershipSold]
    ,deleted.[LumpsumAmount]
    ,deleted.[MonthlyIncomeAmount]
    ,deleted.[RefAdverseCreditId]
    ,deleted.[RefOpportunityEmploymentTypeId]
    ,deleted.[CurrentLenderId]
    ,deleted.[EquityLoanPercentage]
    ,deleted.[EquityLoanAmount]
    INTO CRM..TMortgageOpportunityAudit
	(
		[OpportunityId]
		,[LoanPurpose]
		,[LoanAmount]
		,[LTV]
		,[RefMortgageBorrowerTypeId]
		,[Term]
		,[RefMortgageRepaymentMethodId]
		,[InterestOnly]
		,[Repayment]
		,[Price]
		,[Deposit]
		,[PlanPurpose]
		,[CurrentLender]
		,[CurrentLoanAmount]
		,[MonthlyRentalIncome]
		,[Owner]
		,[RelationshipCRMContactId]
		,[EmploymentType]
		,[IncomeAmount]
		,[RepaymentAmountMonthly]
		,[StatusFg]
		,[SelfCertFg]
		,[NonStatusFg]
		,[ExPatFg]
		,[ForeignCitizenFg]
		,[TrueCostOverTerm]
		,[ConcurrencyId]
		,[MortgageOpportunityId]
		,[StampAction]
		,[StampDateTime]
		,[StampUser]
		,[SourceOfDeposit]
		,[InterestOnlyRepaymentVehicle]
		,[RelatedAddressStoreId]
		,[RepaymentOfExistingMortgage]
		,[HomeImprovements]
		,[MortgageFees]
		,[Other]
		,[GuarantorMortgageFg]
		,[GuarantorText]
		,[DebtConsolidatedFg]
		,[DebtConsolidationText]
		,[RepaymentTerm]
		,[InterestOnlyTerm]
		,[DebtConsolidation]
		,[Details]
		,[InterestDetails]
		,[RefMortgageSaleTypeId]
		,[IsHighNetWorthClient]
		,[IsMortgageForBusiness]
		,[IsProfessionalClient]
		,[IsRejectedAdvice]
		,[ExecutionOnlyDetails]
		,[RefOpportunityType2ProdSubTypeId]
		,[IsFirstTimeBuyer]
		,[RefEquityReleaseTypeId]
		,[PercentageOwnershipSold]
		,[LumpsumAmount]
		,[MonthlyIncomeAmount]
		,[RefAdverseCreditId]
		,[RefOpportunityEmploymentTypeId]
		,[CurrentLenderId]
		,[EquityLoanPercentage]
		,[EquityLoanAmount]
	)
	FROM CRM..TMortgageOpportunity O
	JOIN @PropertyDetails t on t.PropertyDetailId = o.RelatedAddressStoreId
END