SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditLoanCredit]
	@StampUser varchar (255),
	@LoanCreditId int,
	@StampAction char(1)
AS

	INSERT INTO TLoanCreditAudit 
	( 	
		 LoanCreditId
		,IndigoClientId
		,PolicyBusinessId
		,OriginalLoanAmount
		,RefLoanCreditTypeId
		,RefRateTypeId
		,CreditLimit
		,LoanTermInMonths
		,RefProtectionTypeId
		,RedemptionTerms
		,IsToBeConsolidated
		,IsLiabilityToBeRepaid
		,LiabilityRepaymentDescription
		,StampAction
		,StampDateTime
		,StampUser
	) 
	Select 
		 LoanCreditId
		,IndigoClientId
		,PolicyBusinessId
		,OriginalLoanAmount
		,RefLoanCreditTypeId
		,RefRateTypeId
		,CreditLimit
		,LoanTermInMonths
		,RefProtectionTypeId
		,RedemptionTerms
		,IsToBeConsolidated
		,IsLiabilityToBeRepaid
		,LiabilityRepaymentDescription
		,@StampAction
		,GetDate()
		,@StampUser
	FROM  TLoanCredit
	WHERE LoanCreditId = @LoanCreditId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
