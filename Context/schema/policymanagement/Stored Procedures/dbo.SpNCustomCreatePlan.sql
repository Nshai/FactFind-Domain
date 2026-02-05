SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlan]  
@CRMContactId1 bigint,  
@CRMContactId2 bigint = null,  
@RefPlanType2ProdSubTypeId bigint,  
@AdviceTypeId bigint,  
@RefProdProviderId bigint,  
@ContributionAmount money = null,  
@ContributionFrequency varchar(50) = null,  
@MaturityDate datetime = null,  
@IndigoClientId bigint,  
@ProductName varchar(255) = null,  
@StampUser varchar(50),  
@StartDate datetime = null,  
@SellingAdviserId bigint,  
@PolicyNumber varchar(50)=null,  
@InitialCommission money = null,  
@ReturnId bigint OUTPUT  
  
as  
  
begin  
  
-- get the default BandingTemplateId for this selling adviser  
DECLARE @BandingTemplateId bigint  
DECLARE @TnCCoachId bigint  
  
IF @StartDate IS NULL  
BEGIN  
 SELECT @StartDate=GETDATE()  
END  
  
  
SELECT @BandingTemplateId = BandingTemplateId   
FROM Commissions..TBandingTemplate  
WHERE PractitionerId = @SellingAdviserId  
AND DefaultFg = 1  
  
--Get the tnccoachid  
SELECT @TnCCoachId=TnCCoachId FROM CRM..TPractitioner WHERE PractitionerId=@SellingAdviserId  
  
--SELECT @RefCommissionTypeId=RefCommissionTypeId FROM PolicyManagement..TRefCommissionType WHERE CommissionTypeName='indemnity'  
  
  
-- set the MaturityDate to null if we've passed in ''  
 if ISNULL(@MaturityDate,'01 Jan 1900')='01 Jan 1900'  
  set @MaturityDate = null  
  
-- quit here if we haven't got one of these required ids...  
 IF @RefPlanType2ProdSubTypeId IS NULL OR @RefProdProviderId IS NULL  
 BEGIN  
  SELECT -1  
  RETURN  
 END  
  
-- Create a TPlanDescription record  
 DECLARE @PlanDescriptionId bigint  
  
 INSERT INTO PolicyManagement..TPlanDescription (RefPlanType2ProdSubTypeId, RefProdProviderId, ConcurrencyId )   
 VALUES (@RefPlanType2ProdSubTypeId, @RefProdProviderId,  1)   
  
 SET @PlanDescriptionId = SCOPE_IDENTITY()  
  
 INSERT INTO PolicyManagement..TPlanDescriptionAudit (RefPlanType2ProdSubTypeId, RefProdProviderId, ConcurrencyId, PlanDescriptionId, StampAction, StampDateTime, StampUser)  
 VALUES (@RefPlanType2ProdSubTypeId, @RefProdProviderId,  1, @PlanDescriptionId,  'C', GetDate(),  @StampUser)  
  
  
  
-- Create a TPolicyDetail record  
 DECLARE @PolicyDetailId bigint  
  
   INSERT INTO PolicyManagement..TPolicyDetail (PlanDescriptionId, IndigoClientId, ConcurrencyId )   
 VALUES (@PlanDescriptionId, @IndigoClientId, 1)   
  
 SET @PolicyDetailId = SCOPE_IDENTITY()  
  
   INSERT INTO PolicyManagement..TPolicyDetailAudit ( PlanDescriptionId, IndigoClientId, ConcurrencyId, PolicyDetailId, StampAction, StampDateTime, StampUser)  
 VALUES ( @PlanDescriptionId, @IndigoClientId, 1, @PolicyDetailId, 'C', GetDate(),  @StampUser )  
  
  
-- Create a TPolicyOwner record(s)  
 DECLARE @PolicyOwnerId bigint  
 DECLARE @PolicyOwnerCRMId bigint  
  
 SET @PolicyOwnerCRMId = @CRMContactId1  
  
  
   
 INSERT INTO PolicyManagement..TPolicyOwner (CRMContactId, PolicyDetailId, ConcurrencyId )   
 VALUES ( @PolicyOwnerCRMId, @PolicyDetailId, 1)   
  
 SET @PolicyOwnerId = SCOPE_IDENTITY()  
  
 INSERT INTO PolicyManagement..TPolicyOwnerAudit ( CRMContactId,  PolicyDetailId, ConcurrencyId,PolicyOwnerId, StampAction, StampDateTime, StampUser)  
 VALUES ( @PolicyOwnerCRMId, @PolicyDetailId, 1, @PolicyOwnerId, 'C', GetDate(), @StampUser )  
  
 -- add the second owner  
 IF @CRMContactId2 IS NOT NULL  
 BEGIN  
  INSERT INTO PolicyManagement..TPolicyOwner (CRMContactId, PolicyDetailId, ConcurrencyId )   
  VALUES ( @CRMContactId2, @PolicyDetailId, 1)   
   
  SET @PolicyOwnerId = SCOPE_IDENTITY()  
   
  INSERT INTO PolicyManagement..TPolicyOwnerAudit ( CRMContactId,  PolicyDetailId, ConcurrencyId,PolicyOwnerId, StampAction, StampDateTime, StampUser)  
  VALUES ( @CRMContactId2, @PolicyDetailId, 1, @PolicyOwnerId, 'C', GetDate(), @StampUser )  
  
 END  
   
  
 -- Get the LifeCycleId  
 DECLARE @LifeCycleId bigint  
  
 SET @LifeCycleId = (  
  SELECT b.LifeCycleId   
  FROM PolicyManagement..TRefPlanType2ProdSubType a  
  JOIN PolicyManagement..TLifeCycle2RefPlanType b on a.RefPlanTypeId=b.RefPlanTypeId  
  JOIN PolicyManagement..TLifeCycle c on b.LifeCycleId=c.LifeCycleId  
  WHERE b.AdviceTypeId = @AdviceTypeId   
  AND a.RefPlanType2ProdSubTypeId=@RefPlanType2ProdSubTypeId  
  AND c.Status = 1  
 )  
  
  
  
  
-- Create the TPolicyBusiness record  
 DECLARE @PolicyBusinessId bigint  
  
 DECLARE @RefFrequencyId bigint  
 DECLARE @RefContributionTypeId int  
   
 DECLARE @RegAmount money, @LumpAmount money  
  
 IF @ContributionFrequency = 'One-off' OR @ContributionFrequency = 'Single'  
  SET @LumpAmount = @ContributionAmount  
 ELSE  
  SET @RegAmount = @ContributionAmount  
  
  
 IF @ContributionFrequency = 'N/A'  
  SET @ContributionFrequency = NULL  
  
 INSERT INTO PolicyManagement..TPolicyBusiness (PolicyDetailId,PolicyNumber, PractitionerId,TnCCoachId, AdviceTypeId, IndigoClientId, TotalRegularPremium, TotalLumpSum, PremiumType, PolicyStartDate, MaturityDate, LifeCycleId, ProductName, ConcurrencyId)  
 VALUES (@PolicyDetailId,@PolicyNumber, @SellingAdviserId,@TnCCoachId, @AdviceTypeId, @IndigoClientId, @RegAmount, @LumpAmount, @ContributionFrequency, @StartDate, @MaturityDate, @LifeCycleId, @ProductName, 1)  
  
 SET @PolicyBusinessId = SCOPE_IDENTITY()  
  
 INSERT INTO PolicyManagement..TPolicyBusinessAudit
 (PolicyDetailId, PractitionerId,TnCCoachId, AdviceTypeId, IndigoClientId, TotalRegularPremium, TotalLumpSum, PremiumType, PolicyStartDate, MaturityDate, LifeCycleId, ProductName, 
	SequentialRef, ConcurrencyId, PolicyBusinessId, StampAction, StampDateTime, StampUser)  
Select PolicyDetailId, PractitionerId,TnCCoachId, AdviceTypeId, IndigoClientId, TotalRegularPremium, TotalLumpSum, PremiumType, PolicyStartDate, MaturityDate, LifeCycleId, ProductName, 
	SequentialRef, ConcurrencyId, PolicyBusinessId, 'C', GetDate(), @StampUser
 From PolicyManagement..TPolicyBusiness
 Where PolicyBusinessId = @PolicyBusinessId
  
-- create the TPolicyBusinessExt record
 DECLARE @PolicyBusinessExtId bigint,
         @ReceivingAdviserId INT,
         @UseCRABanding TINYINT

 SELECT @ReceivingAdviserId = ReceivingPractitionerId, @UseCRABanding = UseCRABandingFg
 FROM Commissions..TReceivingAdviser
 WHERE SellingPractitionerId = @SellingAdviserId

 INSERT INTO PolicyManagement..TPolicyBusinessExt (PolicyBusinessId, BandingTemplateId, ForwardIncomeToAdviserId, ForwardIncomeToUseAdviserBanding)
 VALUES (@PolicyBusinessId, @BandingTemplateId, @ReceivingAdviserId, @UseCRABanding)

 SET @PolicyBusinessExtId = SCOPE_IDENTITY()

EXEC dbo.[SpNAuditPolicyBusinessExt] @StampUser, @PolicyBusinessExtId, 'C'

-- Add  Status for the plan (In force for pre-existing otherwise draft  
 DECLARE @StatusId bigint  
 DECLARE @StatusHistoryId bigint  
 DECLARE @Advice varchar(50)  
  
 SELECT @Advice=IntelligentOfficeAdviceType FROM PolicyManagement..TAdviceType WHERE AdviceTypeId=@AdviceTypeId  
   
 IF lower(@Advice)='pre-existing'  
 BEGIN  
  SET @StatusId = (  
   SELECT TOP 1 StatusId  
   FROM PolicyManagement..TStatus   
   WHERE IndigoClientId = @IndigoClientId  
   AND IntelligentOfficeStatusType = 'In Force'  
  )   
 END  
 ELSE  
 BEGIN   
  SET @StatusId = (  
   SELECT TOP 1 StatusId  
   FROM PolicyManagement..TStatus   
   WHERE IndigoClientId = @IndigoClientId  
   AND IntelligentOfficeStatusType = 'Draft'  
  )  
 END  
  
 INSERT INTO PolicyManagement..TStatusHistory(PolicyBusinessId, StatusId, ChangedToDate, ChangedByUserId, DateOfChange, CurrentStatusFg, LifeCycleStepFg, ConcurrencyId)  
 VALUES (@PolicyBusinessId, @StatusId, getdate(), @StampUser, getdate(), 1, 1, 1)  
  
 SET @StatusHistoryId = SCOPE_IDENTITY()  
  
 INSERT INTO PolicyManagement..TStatusHistoryAudit(PolicyBusinessId, StatusId, ChangedToDate, ChangedByUserId, DateOfChange, CurrentStatusFg, LifeCycleStepFg, ConcurrencyId, StatusHistoryId, StampAction, StampDateTime, StampUser)  
 VALUES (@PolicyBusinessId, @StatusId, getdate(), @StampUser, getdate(), 1, 1, 1, @StatusHistoryId, 'C', getdate(), @StampUser)  
  
  
-- Create any contribution records  
  
 DECLARE @PolicyMoneyInId bigint  
  
 IF @ContributionAmount IS NOT NULL AND @ContributionFrequency IS NOT NULL  
 BEGIN  
  
  -- get the RefFrequencyId  
  SET @RefContributionTypeId = 1  
  
  IF @ContributionFrequency = 'One-Off'   
   BEGIN  
    set @ContributionFrequency = 'Single'  
    set @RefContributionTypeId = 2  
   END  
  
  SET @RefFrequencyId = (  
   SELECT RefFrequencyId   
   FROM PolicyManagement..TRefFrequency rf  
   WHERE FrequencyName = @ContributionFrequency  
   AND RetireFg = 0  
  )  
    
  INSERT INTO PolicyManagement..TPolicyMoneyIn (Amount, RefFrequencyId, PolicyBusinessId, StartDate, RefContributionTypeId, RefContributorTypeId, ConcurrencyId)  
  VALUES (@ContributionAmount, @RefFrequencyId, @PolicyBusinessId, @StartDate, @RefContributionTypeId, 1, 1)  
  
  SET @PolicyMoneyInId = SCOPE_IDENTITY()  
  
  
  INSERT INTO PolicyManagement..TPolicyMoneyInAudit (Amount, RefFrequencyId, PolicyBusinessId, StartDate, RefContributionTypeId, RefContributorTypeId, ConcurrencyId, PolicyMoneyInId, StampAction, StampDateTime, StampUser)  
  VALUES (@ContributionAmount, @RefFrequencyId, @PolicyBusinessId, @StartDate, @RefContributionTypeId, 1, 1, @PolicyMoneyInId, 'C', GetDate(), @StampUser )  
    
    
 END  
  
  
--Create any commission records (initial only)  
 IF @InitialCommission IS NOT NULL  
 BEGIN  
   DECLARE @PolicyExpectedCommissionId bigint  
   DECLARE @RefCommissionTypeId bigint  
   DECLARE @RefPaymentDueTypeId bigint  
  
   SELECT @RefCommissionTypeId=1,@RefPaymentDueTypeId=1  
     
   INSERT INTO PolicyManagement..TPolicyExpectedCommission(PolicyBusinessId,RefCommissionTypeId,RefPaymentDueTypeId,ExpectedAmount,ExpectedCommissionType,     
     _CreatedByUserId,_CreatedDate,_LastUpdatedByUserId,_LastUpdatedDate,ConcurrencyId)    
   SELECT @PolicyBusinessId,@RefCommissionTypeId,@RefPaymentDueTypeId,@InitialCommission,0,CONVERT(bigint, @StampUser), GETDATE(),  
   CONVERT(bigint, @StampUser),GETDATE(),1      
      
   SELECT @PolicyExpectedCommissionId = SCOPE_IDENTITY()    
      
   INSERT INTO TPolicyExpectedCommissionAudit (PolicyBusinessId,RefCommissionTypeId,RefPaymentDueTypeId,ExpectedAmount,     
    ExpectedCommissionType,ConcurrencyId,PolicyExpectedCommissionId,StampAction,StampDateTime,StampUser)    
   SELECT PolicyBusinessId,RefCommissionTypeId,RefPaymentDueTypeId,ExpectedAmount,ExpectedCommissionType,ConcurrencyId,    
    PolicyExpectedCommissionId,'C',GetDate(),@StampUser    
    
   FROM TPolicyExpectedCommission    
   WHERE PolicyExpectedCommissionId = @PolicyExpectedCommissionId      
 END  
  
  
  
SET @ReturnId = @PolicyBusinessId  
  
end
GO
