SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[nio_SpCustomGetBudgetMonthlyAffordability]  
	@CrmContactId int,
	@CrmContactId2 int,
	@TenantId int,
	@CurrentDate date = null 
AS  
  
BEGIN   
DECLARE @TotalMonthlyExpenditure Money, @isIncomeRise Bit, @IncomeChangeAmount Money, @IsIncomeChangeExpected Bit
DECLARE @IsDetailedExpenditure Bit, @NonEssentialExpenditureTotalAmount Money
DECLARE @HasLiabilitiesImported Bit, @LiabilitiesMonthlyExpenditure money, @isExpenditureRise Bit, @ExpenditureChangeAmount Money
DECLARE @IsExpenditureChangeExpected Bit, @LiabilitiesConsolidatedPaymentAmount Money, @ExpenditureConsolidatedPaymentAmount Money, @LiabilitiesRepaidPaymentAmount Money
DECLARE @CurrentProtectionPremium Money, @RevisedTotalDisposableMonthlyIncome Money, @TotalMonthlyIncome Money, @RevisedTotalDisposableIncome money
DECLARE  @IsProtectionRebroked Bit, @IsIncomeChangeIncluded Bit,  @IsExpenditureChangeIncluded Bit,  @IsNonEssentialRemoved Bit, @IsLiabilityExpenditureConsolidated Bit,
@IsLiabilityExpenditureRepaid Bit, @MonthlyAfford Money,  @MonthlyIncome Money, @MonthlyNotes VARCHAR(5000), @ConsolidatedExpenditurePayments Money, 
@RepaidExpenditurePayments money, @RevisedMonthlyIncomeAvailable money, @RevisedMonthlyExpenditure money, @LiabilitiesAmount money, @LumpSumAfford Money

SELECT @TotalMonthlyExpenditure = ISNULL(NetMonthlySummaryAmount,0)
, @IsDetailedExpenditure = ISNULL(IsDetailed, 0)
, @HasLiabilitiesImported = ISNULL(HasFactFindLiabilitiesImported, 0)
, @IsExpenditureChangeExpected = ISNULL(IsChangeExpected, 0)
, @isExpenditureRise = ISNULL(IsRiseExpected, 0)
, @ExpenditureChangeAmount = ISNULL(ChangeAmount, 0)
FROM factfind..TExpenditure  WITH(NOLOCK)
WHERE CRMContactId = @CrmContactId

IF(@IsDetailedExpenditure = 1)
BEGIN
    IF(@HasLiabilitiesImported != 1)
    BEGIN
       SELECT @TotalMonthlyExpenditure = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(E.NetAmount,0), E.Frequency))
       FROM factfind..TExpenditureDetail AS E WITH(NOLOCK)
       WHERE (
                (E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
                OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
                OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
                OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
                ) AND (E.EndDate IS NULL OR E.EndDate > ISNULL(@CurrentDate, GETDATE() ) )
     END
     ELSE
      BEGIN
       SELECT @TotalMonthlyExpenditure = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(E.NetAmount,0), E.Frequency))
       FROM factfind..TExpenditureDetail AS E WITH(NOLOCK)
       JOIN TRefExpenditureType AS ET ON E.RefExpenditureTypeId = ET.RefExpenditureTypeId
       JOIN TRefExpenditureGroup AS EG ON ET.RefExpenditureGroupId = EG.RefExpenditureGroupId
       WHERE (
                (E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
                OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
                OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
                OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
                ) AND (E.EndDate IS NULL OR E.EndDate > ISNULL(@CurrentDate, GETDATE() ) ) AND EG.Name != 'Liability Expenditure'
     END

END

IF(@HasLiabilitiesImported = 1)
BEGIN	

	SELECT @LiabilitiesConsolidatedPaymentAmount = SUM(ISNULL(l.PaymentAmountPerMonth, 0))	
	FROM factfind..TLiabilities l  WITH(NOLOCK)	
	WHERE IsConsolidated = 1 and CrmContactId IN (@CrmContactId, @CrmContactId2) OR 	
	IsConsolidated = 1 and  CRMContactId2 = @CrmContactId	

	SELECT @LiabilitiesRepaidPaymentAmount = SUM(ISNULL(l.PaymentAmountPerMonth, 0))	
	FROM factfind..TLiabilities l  WITH(NOLOCK)	
	WHERE IsToBeRepaid = 1 and CrmContactId IN (@CrmContactId, @CrmContactId2) OR 	
	IsToBeRepaid = 1 and CRMContactId2 = @CrmContactId

	SELECT @LiabilitiesAmount = SUM(ISNULL(l.PaymentAmountPerMonth, 0))	
	FROM factfind..TLiabilities l  WITH(NOLOCK)	
	WHERE CrmContactId IN (@CrmContactId, @CrmContactId2) OR 	
	 CRMContactId2 IN (@CrmContactId, @CrmContactId2) 

	SET @TotalMonthlyExpenditure += ISNULL(@LiabilitiesAmount, 0)
END

SELECT @IsIncomeChangeExpected = ISNULL(IsChangeExpected, 0)
, @isIncomeRise = ISNULL(IsRiseExpected, 0)
, @IncomeChangeAmount = ISNULL(ChangeAmount, 0)
FROM factfind..TIncome  WITH(NOLOCK)
WHERE CrmContactId = @CrmContactId

-- get all projection here to avoid second read (to do)

SELECT @MonthlyIncome = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(NetAmount,0), Frequency))
FROM [factfind].[dbo].[TDetailedincomebreakdown] 
WHERE 
        (
            (CRMContactId = @CRMContactId AND CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
            OR (CRMContactId = @CRMContactId2 AND CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
            OR (CRMContactId = @CRMContactId AND (CRMContactId2 IS NULL OR CRMContactId2 = 0)) --single expenses for Cl1
            OR (CRMContactId = @CRMContactId2 AND (CRMContactId2 IS NULL OR CRMContactId2 = 0)) --single expenses for Cl2
        )
AND (EndDate IS NULL OR EndDate > ISNULL(@CurrentDate, GETDATE() ) )

SELECT
@IsIncomeChangeIncluded = IsIncomeChangeIncluded,
@IsExpenditureChangeIncluded  = IsExpenditureChangeIncluded,
@IsNonEssentialRemoved = IsNonEssentialRemoved,
@IsLiabilityExpenditureConsolidated = IsLiabilityExpenditureConsolidated,
@IsLiabilityExpenditureRepaid = IsLiabilityExpenditureRepaid,
@IsProtectionRebroked = IsProtectionRebroked,
@MonthlyAfford = MonthlyAfford,
@MonthlyNotes  = MonthlyNotes,
@LumpSumAfford = LumpSumAfford
FROM 
factfind..TAffordability WITH(NOLOCK) 
WHERE CRMContactId = @CrmContactId

IF(@IsDetailedExpenditure = 1)
BEGIN
	
	SELECT @NonEssentialExpenditureTotalAmount = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(e.NetMonthlyAmount,0), e.Frequency))
	FROM factfind..TExpenditureDetail e  WITH(NOLOCK)
	JOIN factfind..TRefExpenditureType t  WITH(NOLOCK) On t.RefExpenditureTypeId = e.RefExpenditureTypeId AND t.RefExpenditureGroupId = 2
	WHERE (
			(E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
			OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
		  ) 	
	
	IF(ISNULL(@IsLiabilityExpenditureConsolidated, 0)= 1)
	BEGIN
		SELECT @ExpenditureConsolidatedPaymentAmount = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(e.NetMonthlyAmount,0), e.Frequency))
		FROM factfind..TExpenditureDetail e  WITH(NOLOCK)
		JOIN factfind..TRefExpenditureType t  WITH(NOLOCK) On t.RefExpenditureTypeId = e.RefExpenditureTypeId
		WHERE 
		(
			(E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
			OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
		) 
		and IsConsolidated = 1
	END
	
	IF(ISNULL(@IsLiabilityExpenditureRepaid,0) = 1)
	BEGIN
		SELECT @LiabilitiesRepaidPaymentAmount = SUM(dbo.FnConvertAmountToMonthlyFrequency(ISNULL(e.NetMonthlyAmount,0), e.Frequency))
		FROM factfind..TExpenditureDetail e  WITH(NOLOCK)
		JOIN factfind..TRefExpenditureType t  WITH(NOLOCK) On t.RefExpenditureTypeId = e.RefExpenditureTypeId
		WHERE  
		(
			(E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
			OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
		) 
		and IsLiabilityToBeRepaid = 1
	END
END

SET @RevisedMonthlyExpenditure = ISNULL(@TotalMonthlyExpenditure, 0) 

-- Calculate Revised Expenditure. equals (plus/minus revised change) - non-essential if No
IF(ISNULL(@IsExpenditureChangeIncluded,0) = 1)
BEGIN 
	IF(@IsExpenditureChangeExpected = 1 AND @isExpenditureRise = 1)
		SET @RevisedMonthlyExpenditure = (ISNULL(@RevisedMonthlyExpenditure,0) + ISNULL(@ExpenditureChangeAmount,0))
	ELSE IF (@IsExpenditureChangeExpected = 1 AND @isExpenditureRise = 0)
		SET @RevisedMonthlyExpenditure = (ISNULL(@RevisedMonthlyExpenditure,0) - ISNULL(@ExpenditureChangeAmount,0))
END
IF(ISNULL(@IsNonEssentialRemoved, 0) = 1)
SET @RevisedMonthlyExpenditure =(ISNULL(@RevisedMonthlyExpenditure, 0) - ISNULL(@NonEssentialExpenditureTotalAmount, 0))

IF ISNULL(@IsProtectionRebroked, 0) = 1
BEGIN

DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId, PB.PolicyDetailId      
FROM                                
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)                                
  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId      
WHERE                                
 CRMContactId IN (@CRMContactId, @CRMContactId2) and IndigoClientId = @TenantId

SELECT
 @CurrentProtectionPremium = SUM(
 CASE    
  WHEN ISNULL(pb.TotalRegularPremium,0) > 0 THEN ISNULL(pb.TotalRegularPremium,0)                                
  ELSE ISNULL(pb.TotalLumpSum,0)                                
 END )                      
      
FROM                                  
 PolicyManagement..TPolicyDetail Pd WITH(NOLOCK)      
 JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId   
 JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
 JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')                                 
 JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId    
 JOIN factfind..TRefPlanTypeToSection Psec WITH(NOLOCK) ON Psec.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId and Psec.Section ='Protection'                              
 JOIN 
 (        
	SELECT       
	COUNT(PolicyOwnerId) AS OwnerCount,      
	PolicyDetailId,      
	MIN(PolicyOwnerId) AS Owner1Id,                                  
	CASE MAX(PolicyOwnerId)                                  
		WHEN MIN(PolicyOwnerId) THEN NULL                                  
		ELSE MAX(PolicyOwnerId)                                  
	END AS Owner2Id                                  
	FROM PolicyManagement..TPolicyOwner                      
	WHERE PolicyDetailId IN (SELECT DetailId FROM @PlanList)        
	GROUP BY PolicyDetailId
 ) 
 AS PolicyOwners ON Pd.PolicyDetailId = PolicyOwners.PolicyDetailId  
 JOIN PolicyManagement..TPolicyOwner POWN1 ON PolicyOwners.Owner1Id = POWN1.PolicyOwnerId
 LEFT JOIN PolicyManagement..TPolicyOwner POWN2 ON PolicyOwners.Owner2Id = POWN2.PolicyOwnerId
 where pd.IndigoClientId = @TenantId

END

SET @ConsolidatedExpenditurePayments = CASE WHEN (ISNULL(@HasLiabilitiesImported, 0) = 1)
THEN ISNULL(@LiabilitiesConsolidatedPaymentAmount, 0)	
ELSE ISNULL(@ExpenditureConsolidatedPaymentAmount, 0) -- Need to confirm if this is used 	
--ELSE 0	
END

SET @RepaidExpenditurePayments = 
CASE WHEN ISNULL(@IsLiabilityExpenditureRepaid,0) = 1 
THEN ISNULL(@LiabilitiesRepaidPaymentAmount, 0)	
ELSE 0	
END

SET @RevisedMonthlyIncomeAvailable = CASE WHEN ISNULL(@IsIncomeChangeIncluded, 0)= 0 OR ISNULL(@IsIncomeChangeExpected,0)= 0
THEN @MonthlyIncome
ELSE CASE WHEN ISNULL(@isIncomeRise, 0) = 1
		THEN (ISNULL(@MonthlyIncome, 0) + ISNULL(@IncomeChangeAmount, 0))
		ELSE (ISNULL(@MonthlyIncome, 0) - ISNULL(@IncomeChangeAmount, 0))
		END
END

-- Calculate Revised total monthly income
-- Revised Income - Revised Expenditure + Consolidated Expenditure + Repaid expenditure
SET @RevisedTotalDisposableIncome = ISNULL(@RevisedMonthlyIncomeAvailable, 0) - ISNULL(@RevisedMonthlyExpenditure,0)

IF(ISNULL(@IsLiabilityExpenditureConsolidated, 0)= 1)
SET @RevisedTotalDisposableIncome = ISNULL(@RevisedTotalDisposableIncome,0)  + ISNULL(@ConsolidatedExpenditurePayments, 0)

IF(ISNULL(@IsLiabilityExpenditureRepaid, 0)= 1)
SET @RevisedTotalDisposableIncome = @RevisedTotalDisposableIncome + ISNULL(@RepaidExpenditurePayments, 0)


SELECT
@MonthlyIncome AS TotalNetMonthlyIncome,
@TotalMonthlyExpenditure AS TotalMonthlyExpenditure,
(ISNULL(@MonthlyIncome, 0) - ISNULL(@TotalMonthlyExpenditure, 0)) AS TotalMonthlyDisposableIncome,
@IsIncomeChangeIncluded AS IsExpectedIncomeChangesIncorporated,
@IsExpenditureChangeIncluded  AS IsExpectedExpenditureChangesIncorporated,
@IsNonEssentialRemoved AS IsNonEssentialRemoved,
@IsLiabilityExpenditureConsolidated AS IsLiabilityExpenditureConsolidated,
@IsLiabilityExpenditureRepaid AS IsLiabilityExpenditureRepaid,
@IsProtectionRebroked AS IsProtectionRebroked,

@RevisedMonthlyIncomeAvailable AS RevisedMonthlyIncomeAvailable,
@RevisedMonthlyExpenditure AS RevisedMonthlyExpenditure, 

CASE WHEN @IsLiabilityExpenditureConsolidated = 1
THEN @ConsolidatedExpenditurePayments 
ELSE 0 
END AS ConsolidatedExpenditurePayments,

@RepaidExpenditurePayments AS RepaidExpenditurePayments,

CASE WHEN ISNULL(@IsProtectionRebroked, 0) = 1
THEN ISNULL(@CurrentProtectionPremium, 0)
ELSE 0
END AS CurrentProtectionPremium,

@RevisedTotalDisposableIncome AS RevisedTotalDisposableMonthlyIncome,

@MonthlyAfford AS AgreedMonthlyBudget,
@MonthlyNotes  AS Notes,
@LumpSumAfford AS LumpSumForInvestment

END