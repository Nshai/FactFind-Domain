SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[SpNAuditLiabilities]  
 @StampUser varchar (255),  
 @LiabilitiesId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TLiabilitiesAudit   
(CRMContactId, CRMContactId2, Owner, CommitedOutgoings, description, repayorinterest,   
 LoanCategory, Amount, LenderName, OriginalTerm, LoanAmount, LoanType,   
 StartDate, EndDate, Repayments, RepaymentFrequency, Protected, InterestRate,   
 RateType, ProtectedYesNo, PolicyBusinessId, IsSecure, IsMortgage, ConcurrencyId,   
 EarlyRedemptionCharge, IsConsolidated, IsToBeRepaid, HowWillItBeRepaid, PaymentAmountPerMonth, CreditLimit,  
 LiabilitiesId, StampAction, StampDateTime, StampUser, TotalLoanAmount, LiabilityAccountNumber,IsGuarantorMortgage, [LiabilityMigrationRef],
 [InterestRateType])  
SELECT  CRMContactId, CRMContactId2, Owner, CommitedOutgoings, description, repayorinterest,   
 LoanCategory, Amount, LenderName, OriginalTerm, LoanAmount, LoanType,   
 StartDate, EndDate, Repayments, RepaymentFrequency, Protected, InterestRate,   
 RateType, ProtectedYesNo, PolicyBusinessId, IsSecure, IsMortgage, ConcurrencyId,   
 EarlyRedemptionCharge, IsConsolidated, IsToBeRepaid, HowWillItBeRepaid, PaymentAmountPerMonth, CreditLimit,  
 LiabilitiesId, @StampAction, GetDate(), @StampUser, TotalLoanAmount, LiabilityAccountNumber, IsGuarantorMortgage, [LiabilityMigrationRef],
 [InterestRateType]
FROM TLiabilities  
WHERE LiabilitiesId = @LiabilitiesId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
