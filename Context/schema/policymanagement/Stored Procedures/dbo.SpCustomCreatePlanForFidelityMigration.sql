SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomCreatePlanForFidelityMigration]       
 @CRMContactId bigint,      
 @RefPlanType2ProdSubTypeId bigint,      
 @RefProdProviderId bigint,      
 @AdviceTypeId bigint,      
 @PractitionerId bigint,      
 @InforceDate datetime = '01 Jan 1799' ,      
 @PolicyNumber varchar(255),      
 @PremiumFrequency bigint,      
 @RegularPremium money,      
 @LumpSumPremium money,      
 @ContributionEffectiveDate datetime,      
 @PolicyStartDate datetime='01 Jan 1799',      
 @IndigoClientId bigint,      
 @BandingTemplateId bigint,      
 @PreExistingFg bit,      
 @OffPanelFg bit,      
 @ProductName varchar(255),      
 @StampUser varchar(50)  ,    
 @OpportunityId bigint = NULL,    
 @WrapperParentPolicyBusinessId bigint = NULL,
 @PortalReference varchar(25) = '/bundled'
 ,@PolicyBusinessId BIGINT OUTPUT
AS      
      
begin      
      
 Declare @PolicyDetailId bigint, @TnCCoachId bigint      
 Declare @CurrentDate datetime, @PolicyMoneyInId bigint      
 declare @PolicyBusinessExtId bigint , @RefPlanTypeId bigint   
DECLARE @ContributionType int,@SinglePremiumFrequency bigint
      
set @PolicyBusinessId=NULL      
set @SinglePremiumFrequency=(SELECT RefFrequencyId FROM TRefFrequency WHERE FrequencyName='Single' AND RetireFg=0)

    
SELECT @RefPlanTypeId=RefPlanTypeId FROM TRefPlanType2ProdSubType WHERE RefPlanType2ProdSubTypeId=@RefPlanType2ProdSubTypeId     
       
      
 -- get the status      
 declare @StatusId bigint,  @IOStatus varchar(255), @StatusHistoryId bigint      
      
 if @PreExistingFg = 0      
 begin      
  select       
  @StatusId = StatusId,       
  @IOStatus = IntelligentOfficeStatusType       
  from policymanagement..tstatus       
  where name='Draft' and indigoclientid=@indigoclientid      
      
  set @CurrentDate = getdate()      
 end      
 else      
 begin      
  select       
  @StatusId = StatusId,       
  @IOStatus = IntelligentOfficeStatusType       
  from policymanagement..tstatus       
  where name='In Force' and indigoclientid=@indigoclientid      
      
  set @CurrentDate = @InforceDate      
 end      
      
 if @CurrentDate is null      
  set @CurrentDate = getdate()      
      
 -- get the tnccoach      
       
      
 select @TnCCoachId=A.TnCCoachId       
 from CRM..TPractitioner A      
 where a.PractitionerId = @PractitionerId      
      
      
      
 -- lets do the work      
       
      
 DECLARE @PlanDescriptionId bigint        
      
 INSERT INTO TPlanDescription ( RefPlanType2ProdSubTypeId,   RefProdProviderId,   ConcurrencyId )         
 VALUES (  @RefPlanType2ProdSubTypeId,   @RefProdProviderId,   1)         
      
 SELECT @PlanDescriptionId = SCOPE_IDENTITY()        
      
 INSERT INTO TPlanDescriptionAudit (  RefPlanType2ProdSubTypeId,   RefProdProviderId,   ConcurrencyId,  PlanDescriptionId,  StampAction,  StampDateTime,  StampUser)        
 VALUES (  @RefPlanType2ProdSubTypeId,   @RefProdProviderId,   1,  @PlanDescriptionId,  'C',  GetDate(),  @StampUser)        
      
      
      
 /** lets create the policy detail First  **/        
 INSERT INTO TPolicyDetail (  PlanDescriptionId,   IndigoClientId,   ConcurrencyId )         
 VALUES (  @PlanDescriptionId,   @IndigoClientId,   1)           
      
 SELECT @PolicyDetailId = SCOPE_IDENTITY()        
        
 INSERT INTO TPolicyDetailAudit (PlanDescriptionId,   IndigoClientId,   ConcurrencyId,  PolicyDetailId,  StampAction,  StampDateTime,  StampUser)        
 VALUES (  @PlanDescriptionId,   @IndigoClientId,   1,  @PolicyDetailId,  'C',  GetDate(),  @StampUser )        
        
        
 /** lets create policy owner */        
        
        
 DECLARE @PolicyOwnerId bigint        
      
 INSERT INTO TPolicyOwner (CRMContactId,   PolicyDetailId,   ConcurrencyId )         
 VALUES (  @CRMContactId,   @PolicyDetailId,   1)         
        
 SELECT @PolicyOwnerId = SCOPE_IDENTITY()        
        
 INSERT INTO TPolicyOwnerAudit (  CRMContactId,   PolicyDetailId,   ConcurrencyId,  PolicyOwnerId,  StampAction,  StampDateTime,  StampUser)        
 VALUES (  @CRMContactId,   @PolicyDetailId,   1,  @PolicyOwnerId,  'C',  GetDate(),  @StampUser  )        
      
       
 -- lets do policy business      
      
        
      
         
      
 INSERT INTO TPolicyBusiness (  PolicyDetailId,   PolicyNumber,   PractitionerId,   ReplaceNotes,   TnCCoachId,   AdviceTypeId,   BestAdvicePanelUsedFG,       
    WaiverDefermentPeriod,   IndigoClientId,   SwitchFG,   TotalRegularPremium,   TotalLumpSum,   MaturityDate,   LifeCycleId,    
    PolicyStartDate,   PremiumType,   AgencyNumber,   ProviderAddress,   OffPanelFg,   BaseCurrency,   ExpectedPaymentDate,    
    ProductName,   InvestmentTypeId,   RiskRating,   ConcurrencyId )         
 VALUES (  @PolicyDetailId,   @PolicyNumber,   @PractitionerId,   null,   @TnCCoachId,   @AdviceTypeId,   0,   0,   @IndigoClientId,   0,   @RegularPremium,  @LumpSumPremium,   null,   @AdviceTypeId,   @PolicyStartDate,   @PremiumFrequency,   null,    
    null,   @OffPanelFg,   'GBP',   null,   @ProductName,   null,   null,   1)         
       
 SELECT @PolicyBusinessId = SCOPE_IDENTITY()        
      
 INSERT INTO TPolicyBusinessAudit (  PolicyDetailId,   PolicyNumber,   PractitionerId,   ReplaceNotes,   TnCCoachId,   AdviceTypeId,   BestAdvicePanelUsedFG,   WaiverDefermentPeriod,   IndigoClientId,   SwitchFG,    
     TotalRegularPremium,   TotalLumpSum,   MaturityDate,   LifeCycleId,   PolicyStartDate,   PremiumType,   AgencyNumber,   SequentialRef,   ProviderAddress,   OffPanelFg,   BaseCurrency,   ExpectedPaymentDate,    
     ProductName,   InvestmentTypeId,   RiskRating,   ConcurrencyId,  PolicyBusinessId,  StampAction,  StampDateTime,  StampUser)        
    
 SELECT  T1.PolicyDetailId,   T1.PolicyNumber,   T1.PractitionerId,   T1.ReplaceNotes,   T1.TnCCoachId,   T1.AdviceTypeId,   T1.BestAdvicePanelUsedFG,   T1.WaiverDefermentPeriod,   T1.IndigoClientId,   T1.SwitchFG,    
  T1.TotalRegularPremium,   T1.TotalLumpSum,   T1.MaturityDate,   T1.LifeCycleId,   T1.PolicyStartDate,   T1.PremiumType,   T1.AgencyNumber,   T1.SequentialRef,   T1.ProviderAddress,   T1.OffPanelFg,   T1.BaseCurrency,    
  T1.ExpectedPaymentDate,   T1.ProductName,   T1.InvestmentTypeId,   T1.RiskRating,   T1.ConcurrencyId,  T1.PolicyBusinessId,  'C',  GetDate(),  @StampUser        
 FROM TPolicyBusiness T1        
 WHERE T1.PolicyBusinessId=@PolicyBusinessId        
    
    
       
      
        
 INSERT INTO TStatusHistory (PolicyBusinessId,   StatusId,   StatusReasonId,   ChangedToDate,   ChangedByUserId,   DateOfChange,   LifeCycleStepFG,   CurrentStatusFG,   ConcurrencyId )         
 VALUES (  @PolicyBusinessId,   @StatusId,   null,   @CurrentDate,   @StampUser,   @CurrentDate,   1,   1,   1)         
        
   SELECT @StatusHistoryId = SCOPE_IDENTITY()        
      
 INSERT INTO TStatusHistoryAudit (PolicyBusinessId,   StatusId,   StatusReasonId,   ChangedToDate,   ChangedByUserId,   DateOfChange,   LifeCycleStepFG,   CurrentStatusFG,   ConcurrencyId,  StatusHistoryId,  StampAction,  StampDateTime,  StampUser)      
  
 SELECT  T1.PolicyBusinessId,   T1.StatusId,   T1.StatusReasonId,   T1.ChangedToDate,   T1.ChangedByUserId,   T1.DateOfChange,   T1.LifeCycleStepFG,   T1.CurrentStatusFG,   T1.ConcurrencyId,  T1.StatusHistoryId,  'C',  GetDate(),  @StampUser        
 FROM TStatusHistory T1        
 WHERE T1.StatusHistoryId=@StatusHistoryId        
      
/*
Case 38631 Regular Premiums of Type Single should be added as Lump Sum contributions
*/      
IF (@RegularPremium >= 0 )
BEGIN
	SET  @ContributionType=1
	IF (@PremiumFrequency=@SinglePremiumFrequency)
	BEGIN
		SET @ContributionType=2
	END
  --regular contribution      
  INSERT INTO TPolicyMoneyIn (Amount,   EscalationPercentage,   RefFrequencyId,   StartDate,   PolicyBusinessId,   RefTaxBasisId,   RefTaxYearId,   RefContributionTypeId,    
      RefContributorTypeId,   CurrentFg,   RefEscalationTypeId,   SalaryPercentage,   StopDate,   ConcurrencyId )         
  VALUES (@RegularPremium,   null,   @PremiumFrequency,   @ContributionEffectiveDate,   @PolicyBusinessId,   null,   null,   @ContributionType,   1,   1,   null,   null,   null,   1)         
        
  SELECT @PolicyMoneyInId = SCOPE_IDENTITY()        
       
  INSERT INTO TPolicyMoneyInAudit (Amount,   EscalationPercentage,   RefFrequencyId,   StartDate,   PolicyBusinessId,   RefTaxBasisId,   RefTaxYearId,   RefContributionTypeId,   RefContributorTypeId,     
       CurrentFg,   RefEscalationTypeId,   SalaryPercentage,   StopDate,   ConcurrencyId,  PolicyMoneyInId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.Amount,   T1.EscalationPercentage,   T1.RefFrequencyId,   T1.StartDate,   T1.PolicyBusinessId,   T1.RefTaxBasisId,   T1.RefTaxYearId,   T1.RefContributionTypeId,       
  T1.RefContributorTypeId,   T1.CurrentFg,   T1.RefEscalationTypeId,   T1.SalaryPercentage,   T1.StopDate,   T1.ConcurrencyId,  T1.PolicyMoneyInId,  'C',  GetDate(),  @StampUser        
  FROM TPolicyMoneyIn T1        
  WHERE T1.PolicyMoneyInId=@PolicyMoneyInId        

END


      
  --lump sum        
 IF @LumpSumPremium >= 0        
 BEGIN    
  INSERT INTO TPolicyMoneyIn (Amount,   EscalationPercentage,   RefFrequencyId,   StartDate,   PolicyBusinessId,   RefTaxBasisId,   RefTaxYearId,   RefContributionTypeId,      
     RefContributorTypeId,   CurrentFg,   RefEscalationTypeId,   SalaryPercentage,   StopDate,   ConcurrencyId )         
  VALUES (@LumpSumPremium,   null,   @SinglePremiumFrequency,   @ContributionEffectiveDate,   @PolicyBusinessId,   null,   null,   2,   1,   1,   null,   null,   null,   1)         
        
  SELECT @PolicyMoneyInId = SCOPE_IDENTITY()        
       
  INSERT INTO TPolicyMoneyInAudit (Amount,   EscalationPercentage,   RefFrequencyId,   StartDate,   PolicyBusinessId,   RefTaxBasisId,   RefTaxYearId,   RefContributionTypeId,       
   RefContributorTypeId,   CurrentFg,   RefEscalationTypeId,   SalaryPercentage,   StopDate,   ConcurrencyId,  PolicyMoneyInId,  StampAction,  StampDateTime,  StampUser)        
  SELECT  T1.Amount,   T1.EscalationPercentage,   T1.RefFrequencyId,   T1.StartDate,   T1.PolicyBusinessId,   T1.RefTaxBasisId,   T1.RefTaxYearId,   T1.RefContributionTypeId,    
    T1.RefContributorTypeId,   T1.CurrentFg,   T1.RefEscalationTypeId,   T1.SalaryPercentage,   T1.StopDate,   T1.ConcurrencyId,  T1.PolicyMoneyInId,  'C',  GetDate(),  @StampUser        
  FROM TPolicyMoneyIn T1        
  WHERE T1.PolicyMoneyInId=@PolicyMoneyInId       
 END     
      
 -- banding template      
 INSERT INTO TPolicyBusinessExt (PolicyBusinessId,   BandingTemplateId,   MigrationRef,   PortalReference,   ConcurrencyId)        
 VALUES(  @PolicyBusinessId,   @BandingTemplateId,   null,   @PortalReference,  1)        
        
 SELECT @PolicyBusinessExtId = SCOPE_IDENTITY()        

EXEC dbo.[SpNAuditPolicyBusinessExt] @StampUser, @PolicyBusinessExtId, 'C'    
    
    
    
 --Is it a mortgage?    
If @RefPlanTypeId=63     
BEGIN    
 DECLARE @MortgageId bigint , @ProdSubTypeName varchar(255)  
 SET @ProdSubTypeName=(SELECT ProdSubTypeName FROM TRefPlanType2ProdSubType A JOIN TProdSubType B ON A.ProdSubTypeId=B.ProdSubTypeId WHERE A.RefPlanType2ProdSubTypeId=@RefPlanType2ProdSubTypeId)  
 IF ISNULL(@OpportunityId,0)>0    
 BEGIN    
  INSERT TMortgage(PolicyBusinessId,IndigoClientId,LoanAmount,RefMortgageBorrowerTypeId,RefMortgageRepaymentMethodId,    
    MortgageTerm,PropertyValue,LoanPurpose,PriceValuation,Deposit,InterestOnlyAmount,RepaymentAmount,    
    LTV,PenaltyFg,PortableFg,StatusFg,NonStatusFg,SelfCertFg,ConcurrencyId)    
  SELECT @PolicyBusinessId,@IndigoClientId,LoanAmount,RefMortgageBorrowerTypeId,RefMortgageRepaymentMethodId,    
   Term,Price,LoanPurpose,Price,Deposit,InterestOnly,Repayment,LTV,0,1,  
 CASE ISNULL(@ProdSubTypeName,'') WHEN 'Full Status' THEN 1 ELSE 0 END,CASE ISNULL(@ProdSubTypeName,'') WHEN 'Non Status' THEN 1 ELSE 0 END,  
 CASE ISNULL(@ProdSubTypeName,'') WHEN 'Self Cert' THEN 1 ELSE 0 END,1    
  FROM CRM..TMortgageOpportunity    
  WHERE OpportunityId=@OpportunityId    
    
  SELECT @MortgageId = SCOPE_IDENTITY()    
      
 END    
 ELSE    
 BEGIN    
  INSERT TMortgage(PolicyBusinessId,IndigoClientId,PenaltyFg,PortableFg,StatusFg,NonStatusFg,SelfCertFg,ConcurrencyId)    
  SELECT @PolicyBusinessId,@IndigoClientId,0,1,  
 CASE ISNULL(@ProdSubTypeName,'') WHEN 'Full Status' THEN 1 ELSE 0 END,CASE ISNULL(@ProdSubTypeName,'') WHEN 'Non Status' THEN 1 ELSE 0 END,  
 CASE ISNULL(@ProdSubTypeName,'') WHEN 'Self Cert' THEN 1 ELSE 0 END,1    
       
  SELECT @MortgageId = SCOPE_IDENTITY()    
    
 END    
    
 EXEC SpNAuditMortgage @StampUser,@MortgageId,'C'    
END    
      
--create relationship between Wrapper and Linked Plan      
if @WrapperParentPolicyBusinessId is not null     
begin    
    
 exec SpCreateWrapperPolicyBusiness @StampUser, @WrapperParentPolicyBusinessId, @PolicyBusinessId    
    
end    
  
--Are there any default plan purposes?  
INSERT TPolicyBusinessPurpose(PlanPurposeId,PolicyBusinessId,ConcurrencyId)  
  
SELECT A.PlanPurposeId,@PolicyBusinessId,1  
FROM TPlanTypePurpose A  
JOIN TPlanPurpose B ON A.PlanPurposeId=B.PlanPurposeId  
WHERE B.IndigoClientId=@IndigoClientId  
AND A.RefPlanTypeId=@RefPlanTypeId  
AND A.DefaultFg=1  
  
INSERT TPolicyBusinessPurposeAudit(PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,StampAction,StampDateTime,StampUser)  
SELECT PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,'C',getdate(),@StampUser  
FROM TPolicyBusinessPurpose  
WHERE PolicyBusinessId=@PolicyBusinessId    
      
end

GO
