SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*###################################################################
Modification Summary : Modified to create a record even amount is null
                       in order to track the frequency in edit
#####################################################################*/
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanWithdrawal]
	@StampUser varchar(50),
	@PolicyBusinessId bigint,
	@RefFrequencyId bigint,
	@Amount money,
	@StartDate datetime,
	@RefWithdrawalTypeId bigint	
AS	
DECLARE @PolicyMoneyOutId bigint


-- Add money in
INSERT INTO PolicyManagement..TPolicyMoneyOut (
	PolicyBusinessId, Amount, RefFrequencyId, PaymentStartDate, RefWithdrawalTypeId, ConcurrencyId)        
VALUES (
	@PolicyBusinessId, @Amount, @RefFrequencyId, @StartDate, @RefWithdrawalTypeId, 1)

-- Audit    
SET @PolicyMoneyOutId = SCOPE_IDENTITY()        
EXEC PolicyManagement..SpNAuditPolicyMoneyOut @StampUser, @PolicyMoneyOutId, 'C'         	    	    
GO
