SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-------------------------------------------------------
-- Helper Procedure called from SpNCustomUpdateGeneralInsurancePlan
-------------------------------------------------------
CREATE PROCEDURE [dbo].SpNCustomUpdateGeneralInsuranceDetail       
	@StampUser varchar(255),
	@GeneralInsuranceDetailId bigint,
	@SumInsured money = null,
	@AccidentalDamage bit,
	@Excess money = null
AS
DECLARE @CurrentDamageOption bit, @InsuranceCoverOptions int
IF @GeneralInsuranceDetailId IS NULL
	RETURN;

-- Find current damage option
SELECT 
	@CurrentDamageOption = InsuranceCoverOptions&1
FROM PolicyManagement..TGeneralInsuranceDetail
WHERE GeneralInsuranceDetailId = @GeneralInsuranceDetailId
	
PRINT @GeneralInsuranceDetailId	
	
-- See if details have changed.
IF EXISTS (SELECT 1 FROM PolicyManagement..TGeneralInsuranceDetail WHERE GeneralInsuranceDetailId = @GeneralInsuranceDetailId 
	AND (ISNULL(SumAssured, -1) != ISNULL(@SumInsured, -1)
		OR ISNULL(ExcessAmount, -1) != ISNULL(@Excess, -1)
		OR @CurrentDamageOption != @AccidentalDamage))
BEGIN
	-- Audit
	EXEC PolicyManagement..SpNAuditGeneralInsuranceDetail @StampUser, @GeneralInsuranceDetailId, 'U'
		
	-- Update
	UPDATE PolicyManagement..TGeneralInsuranceDetail
	SET
		SumAssured = @SumInsured,
		ExcessAmount = @Excess,
		-- Need to updated the options flag...
		InsuranceCoverOptions = CASE 
			-- Option removed
			WHEN @CurrentDamageOption = 1 AND @AccidentalDamage = 0 THEN InsuranceCoverOptions - 1
			-- Option Added
			WHEN @CurrentDamageOption = 0 AND @AccidentalDamage = 1 THEN InsuranceCoverOptions + 1
			-- No change
			ELSE InsuranceCoverOptions 
		END,
		ConcurrencyId = ConcurrencyId + 1
	WHERE
		GeneralInsuranceDetailId = @GeneralInsuranceDetailId 
		
END						
GO
