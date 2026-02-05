SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spNCustomCreateCommissionRebatesForMatchedStatement]
	@StampUser varchar (255),
	@ProvComStateId bigint,
	@IndClientId int
AS

DECLARE @FeeId bigint
DECLARE @ProvBreakId bigint 
DECLARE @Amount money
DECLARE @AnalysedDate datetime
--
-- 18 Apr 02  - Created -  AH & AK  
-- Used when cash matched to provider statement - Create commission rebate credit notes for all matched prov breaks with fees with commission rebate flag set

-- 10 May 06: MT - 
--Copied to .Net ... I don't think it is used because thre are currently no FeeToPolicyRecords with the Rebate Flag set .... ?  - Don't like use of cursor !!!



--
	DECLARE cursor_CommissionRebates CURSOR  FAST_FORWARD FOR
		SELECT Fee2Policy.FeeId, Item.ProvBreakId, Item.Amount, Item.AnalysedDate
		FROM commissions..TProvBreak Item
		INNER JOIN PolicyManagement..TPolicyBusiness Policies ON Item.PolicyId = Policies.PolicyBusinessId
		INNER JOIN PolicyManagement..TFee2Policy Fee2Policy ON Policies.PolicyBusinessId = Fee2Policy.PolicyBusinessId
		WHERE Item.ProvComStateId = @ProvComStateId AND Fee2Policy.RebateCommission = 1 AND Item.IndClientId = @IndClientId
--
-- Loop round @tblCommissionRebates and for each record  Insert cached prov breaks into TCreditNote & its audit table.
--	
	OPEN  cursor_CommissionRebates 
	FETCH NEXT FROM  cursor_CommissionRebates INTO @FeeId, @ProvBreakId, @Amount, @AnalysedDate

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC SpCreateCreditNote @StampUser,@IndClientId,@FeeId,@ProvBreakId,@Amount,DEFAULT,@AnalysedDate

		FETCH NEXT FROM cursor_CommissionRebates INTO @FeeId, @ProvBreakId, @Amount, @AnalysedDate
	END	

   	CLOSE cursor_CommissionRebates
	DEALLOCATE cursor_CommissionRebates
   
RETURN (0)
GO
