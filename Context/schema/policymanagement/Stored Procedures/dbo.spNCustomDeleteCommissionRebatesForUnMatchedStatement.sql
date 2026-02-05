SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spNCustomDeleteCommissionRebatesForUnMatchedStatement]
@StampUser varchar (255),
@ProvComStateId bigint,
@IndClientId int
AS

DECLARE @CreditNoteId bigint
DECLARE @ConcurrencyId bigint 
DECLARE @Amount money
DECLARE @AnalysedDate datetime
--
-- 19 Apr 02  - Created -  AH & AK  
-- Used when cash matched to provider statement - Create commission rebate credit notes for all matched prov breaks with fees with commission rebate flag set


-- 10 May 06: MT - 
--Copied to .Net ... I don't think it is used because thre are currently no FeeToPolicyRecords with the Rebate Flag set .... ?  - Don't like use of cursor !!!

--
	DECLARE cursor_CommissionRebates CURSOR  FAST_FORWARD FOR
		SELECT CN.CreditNoteId,CN.ConcurrencyId
		FROM TCreditNote CN
		INNER JOIN Commissions..TProvBreak Item ON Item.ProvBreakId = CN.ProvBreakId
		WHERE Item.ProvComStateId = @ProvComStateId AND Item.IndClientId = @IndClientId
--
-- Loop round @tblCommissionRebates and for each record  Insert cached prov breaks into TCreditNote & its audit table.
--	
	OPEN  cursor_CommissionRebates 
	FETCH NEXT FROM  cursor_CommissionRebates INTO @CreditNoteId, @ConcurrencyId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC SpDeleteCreditNoteByIdAndConcurrencyId @CreditNoteId, @ConcurrencyId, @StampUser

		FETCH NEXT FROM cursor_CommissionRebates INTO  @CreditNoteId, @ConcurrencyId
	END	

   	CLOSE cursor_CommissionRebates
	DEALLOCATE cursor_CommissionRebates
   
RETURN (0)
GO
