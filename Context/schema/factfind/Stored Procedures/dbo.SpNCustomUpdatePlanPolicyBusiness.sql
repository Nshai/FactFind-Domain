SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanPolicyBusiness]  
 @StampUser varchar(50),    
 @PolicyBusinessId bigint,  
 @PolicyNumber varchar(255),  
 @PolicyStartDate datetime,  
 @MaturityDate datetime,  
 @ProductName varchar(200),  
 @IsGuaranteedToProtectOriginalInvestment bit,
 @LowMaturityValue money = null,
 @MediumMaturityValue money = null,
 @HighMaturityValue money = null,
 @ProjectionDetails varchar(5000) = null,
 @PlanCurrency varchar(3) = null
AS   
DECLARE @CurrentStartDate datetime, @CurrentPolicyNumber varchar(50), @TenantId bigint  
  
------------------------------------------------------  
-- Get plan detail  
------------------------------------------------------   
SELECT @TenantId = Indigoclientid, @CurrentPolicyNumber = PolicyNumber  
FROM PolicyManagement..TPolicyBusiness   
WHERE PolicyBusinessId = @PolicyBusinessId  
  
------------------------------------------------------  
-- Policy number hack  
------------------------------------------------------   
IF (@PolicyNumber IS NULL AND @TenantId = 101)      
 SET @PolicyNumber =  @CurrentPolicyNumber  

------------------------------------------------------  
IF(@PlanCurrency IS NULL)
	SET @PlanCurrency = administration.dbo.FnGetRegionalCurrency()
  
------------------------------------------------------  
-- Update any changes  
------------------------------------------------------  
IF NOT EXISTS (SELECT 1 FROM PolicyManagement..TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId AND  
 (ISNULL(@PolicyNumber, '') != ISNULL(PolicyNumber, '')   
 OR ISNULL(@PolicyStartDate, '1753-01-01') != ISNULL(PolicyStartDate, '1753-01-01')   
 OR ISNULL(@MaturityDate, '1753-01-01') != ISNULL(MaturityDate, '1753-01-01')   
 OR ISNULL(@ProductName, '') != ISNULL(ProductName, '')   
 OR ISNULL(@IsGuaranteedToProtectOriginalInvestment, 0) != ISNULL(IsGuaranteedToProtectOriginalInvestment, 0)
 OR ISNULL(@LowMaturityValue,0) != ISNULL(LowMaturityValue,0)
 OR ISNULL(@MediumMaturityValue,0) != ISNULL(MediumMaturityValue,0)
 OR ISNULL(@HighMaturityValue,0) != ISNULL(HighMaturityValue,0)
 OR ISNULL(@ProjectionDetails,'') != ISNULL(ProjectionDetails,'')
 OR @PlanCurrency != BaseCurrency
 ))  
RETURN;  
   
EXEC PolicyManagement..SpNAuditPolicyBusiness @StampUser, @PolicyBusinessId, 'U'    
  
UPDATE PolicyManagement..TPolicyBusiness       
SET   
 PolicyNumber = @PolicyNumber,   
 PolicyStartDate = @PolicyStartDate,   
 MaturityDate = @MaturityDate,  
 ProductName = @ProductName,  
 IsGuaranteedToProtectOriginalInvestment = @IsGuaranteedToProtectOriginalInvestment,  
 ConcurrencyId = ConcurrencyId + 1,
 LowMaturityValue = @LowMaturityValue,
 MediumMaturityValue =@MediumMaturityValue,
 HighMaturityValue = @HighMaturityValue,
 ProjectionDetails = @ProjectionDetails,
 BaseCurrency = @PlanCurrency 
WHERE   
 PolicyBusinessId = @PolicyBusinessId  
GO
