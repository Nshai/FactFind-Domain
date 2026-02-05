SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditQuoteResult]
	@StampUser varchar (255),
	@QuoteResultId  bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteResultAudit
( 
	RefProductTypeId,QuoteId,QuoteItemId,QuoteReference,QuoteDate,ProductReferenceNumber,PSLProductRefNo,TenantId,PolicyFeeExcIPT,
	InsurancePremiumTax,AnnualIPT,AnnualPremium,AnnualPremiumExcIPT,TotalMonthlyCost,TotalMonthlyCostExcIPT,MonthlyPremium,MonthlyPremiumExcIpt,
	TotalPremium,TotalPremiumExcIPT,InsurerName,InsurerCode,PolicyFee,InitialExclusionPeriod,IEPWaivedBenefit,IEPAppliedBenefit,IsReferred,
	FiveYearPremium,CreditorInsurerName,Customer1Premium,Customer2Premium,BuildingsContentsPremium,BuildingsContentsPremiumExcIPT,
	BuildingsPremium,BuildingsPremiumExcIPT,ContentsPremium,ContentsPremiumExcIPT,HomeEmergencyPremium,HomeEmergencyPremiumExcIPT,
	LegalCoverInsurerName,LegalCoverInsurerCode,LegalCoverPremium,LegalCoverPremiumExcIPT,HouseholdInsurerName,HouseholdInsurerCode,
	HomeEmergencyInsurerName,HomeEmergencyInsurerCode,ConcurrencyId, QuoteResultId, StampAction, StampDateTime, StampUser, QuoteSystemProductType, QuoteResultInternal,
	IsMarked, ProductDescription, ExpiryDate, ProviderName
) 
SELECT  
	RefProductTypeId,QuoteId,QuoteItemId,QuoteReference,QuoteDate,ProductReferenceNumber,PSLProductRefNo,TenantId,PolicyFeeExcIPT,
	InsurancePremiumTax,AnnualIPT,AnnualPremium,AnnualPremiumExcIPT,TotalMonthlyCost,TotalMonthlyCostExcIPT,MonthlyPremium,MonthlyPremiumExcIpt,
	TotalPremium,TotalPremiumExcIPT,InsurerName,InsurerCode,PolicyFee,InitialExclusionPeriod,IEPWaivedBenefit,IEPAppliedBenefit,IsReferred,
	FiveYearPremium,CreditorInsurerName,Customer1Premium,Customer2Premium,BuildingsContentsPremium,BuildingsContentsPremiumExcIPT,
	BuildingsPremium,BuildingsPremiumExcIPT,ContentsPremium,ContentsPremiumExcIPT,HomeEmergencyPremium,HomeEmergencyPremiumExcIPT,
	LegalCoverInsurerName,LegalCoverInsurerCode,LegalCoverPremium,LegalCoverPremiumExcIPT,HouseholdInsurerName,HouseholdInsurerCode,
	HomeEmergencyInsurerName,HomeEmergencyInsurerCode, ConcurrencyId, QuoteResultId, @StampAction, GetDate(), @StampUser, QuoteSystemProductType, QuoteResultInternal,
	IsMarked, ProductDescription, ExpiryDate, ProviderName

FROM TQuoteResult
WHERE QuoteResultId = @QuoteResultId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
