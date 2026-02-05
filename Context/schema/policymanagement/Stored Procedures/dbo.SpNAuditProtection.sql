SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProtection]
	@StampUser varchar (255),
	@ProtectionId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TProtectionAudit]
(
				IndigoClientId
				,PolicyBusinessId
				,RefPlanSubCategoryId
				,PremiumLoading
				,Exclusions
				,RenewalDate
				,AssuredLife1Id
				,AssuredLife2Id				
				,InTrust
				,ToWhom
				,TermValue
				,InitialEarningsPeriodId
				,WaitingPeriod
				,PercentOfPremiumToInvest
				,TermTypeId
				,IndexTypeId
				,PaymentBasisId
				,LifeCoverSumAssured
				,CriticalIllnessSumAssured
				,CriticalIllnessTermValue
				,ReviewDate
				,ConcurrencyId
				,ProtectionId
				,StampAction
				,StampDateTime
				,StampUser
				,IsForProtectionShortfallCalculation
				,PropertyInsuranceType
				,PlanMigrationRef
				,BenefitSummary
				,ExpensePremiumStructure
				,IncomePremiumStructure
				,ProtectionPayoutType
				,LifeCoverPremiumStructure
				,LifeCoverUntilAge
				,CriticalIllnessPremiumStructure
				,CriticalIllnessUntilAge
				,SeverityCoverAmount
				,SeverityCoverPremiumStructure
				,SeverityCoverTerm
				,SeverityCoverUntilAge
				,PtdCoverAmount
				,PtdCoverPremiumStructure
				,PtdCoverTerm
				,PtdCoverUntilAge
				,IncomeCoverTerm
				,IncomeCoverUntilAge
				,ExpenseCoverTerm
				,ExpenseCoverUntilAge
)
Select 
				IndigoClientId
				,PolicyBusinessId
				,RefPlanSubCategoryId
				,PremiumLoading
				,Exclusions
				,RenewalDate
				,AssuredLife1Id
				,AssuredLife2Id				
				,InTrust
				,ToWhom
				,TermValue
				,InitialEarningsPeriodId
				,WaitingPeriod
				,PercentOfPremiumToInvest
				,TermTypeId
				,IndexTypeId
				,PaymentBasisId
				,LifeCoverSumAssured
				,CriticalIllnessSumAssured
				,CriticalIllnessTermValue
				,ReviewDate
				,ConcurrencyId
				,ProtectionId
				,@StampAction
				,GetDate()
				,@StampUser
				,IsForProtectionShortfallCalculation
				,PropertyInsuranceType
				,PlanMigrationRef
				,BenefitSummary
				,ExpensePremiumStructure
				,IncomePremiumStructure
				,ProtectionPayoutType
				,LifeCoverPremiumStructure
				,LifeCoverUntilAge
				,CriticalIllnessPremiumStructure
				,CriticalIllnessUntilAge
				,SeverityCoverAmount
				,SeverityCoverPremiumStructure
				,SeverityCoverTerm
				,SeverityCoverUntilAge
				,PtdCoverAmount
				,PtdCoverPremiumStructure
				,PtdCoverTerm
				,PtdCoverUntilAge
				,IncomeCoverTerm
				,IncomeCoverUntilAge
				,ExpenseCoverTerm
				,ExpenseCoverUntilAge
FROM [PolicyManagement].[dbo].[TProtection]
WHERE ProtectionId = @ProtectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
