SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanPolicyDetail]
	@StampUser varchar(50),  
	@PolicyBusinessId bigint,
	@RefAnnuityPaymentTypeId bigint,
	@CapitalElement money = null,    
	@AssumedGrowthRatePercentage decimal(5, 2) = null	
AS	
------------------------------------------------------
-- Get Detail Id
------------------------------------------------------
DECLARE @PolicyDetailId bigint
SELECT @PolicyDetailId = PolicyDetailId FROM PolicyManagement..TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId

------------------------------------------------------
-- Check for changes
------------------------------------------------------
IF NOT EXISTS (
	SELECT 1 FROM PolicyManagement..TPolicyDetail 
	WHERE PolicyDetailId = @PolicyDetailId 
		AND (ISNULL(RefAnnuityPaymentTypeId, -1) != ISNULL(@RefAnnuityPaymentTypeId, -1) 
		OR ISNULL(CapitalElement, -1) != ISNULL(@CapitalElement, -1) 
		OR ISNULL(AssumedGrowthRatePercentage, -1) != ISNULL(@AssumedGrowthRatePercentage, -1)))
RETURN;

------------------------------------------------------
-- Update
------------------------------------------------------
EXEC PolicyManagement..SpNAuditPolicyDetail @StampUser, @PolicyDetailId, 'U'  

UPDATE PolicyManagement..TPolicyDetail
SET 
	RefAnnuityPaymentTypeId = @RefAnnuityPaymentTypeId, 
	CapitalElement = @CapitalElement,
	AssumedGrowthRatePercentage = @AssumedGrowthRatePercentage,
	ConcurrencyId = ConcurrencyId + 1
WHERE 
	PolicyDetailId = @PolicyDetailId
GO
