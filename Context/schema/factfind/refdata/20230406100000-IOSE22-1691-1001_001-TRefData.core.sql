-----------------------------------------------------------------------------
--
-- Summary: IOSE22-1691 SQL - Update ordinal attribute of income types for GB region.
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	  , @Comments VARCHAR(255)
DECLARE @StartTranCount int


SELECT 
	@ScriptGUID = '98116D78-9365-4312-9505-4449DFB78A03',
	@Comments = 'Update ordinal attribute of income types for GB region to make Basic Income as default in the select dropdown'

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
    RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
BEGIN TRY

    SELECT @StartTranCount = @@TRANCOUNT

    IF (@StartTranCount = 0)
    BEGIN TRANSACTION 		
 
		UPDATE [factfind].[dbo].[TRefData]
        SET Attributes 
        = CASE Name
            WHEN 'Basic Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"1\"}'
            WHEN 'Wage/Salary (net)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"2\"}'
            WHEN 'Income earned as a partner/sole proprietor' THEN '{\"party_types\":\"Person\",\"ordinal\":\"3\"}'
            WHEN 'Income earned from any additional full or part-time employment' THEN '{\"party_types\":\"Person\",\"ordinal\":\"4\"}'
            WHEN 'State Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"5\"}'
            WHEN 'Company Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"6\"}'
            WHEN 'Private Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"7\"}'
            WHEN 'Taxable State Benefits' THEN '{\"party_types\":\"Person\",\"ordinal\":\"8\"}'
            WHEN 'Non-Taxable State Benefits' THEN '{\"party_types\":\"Person\",\"ordinal\":\"9\"}'
            WHEN 'Taxable Investment Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"10\"}'
            WHEN 'Non-Taxable Investment Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"11\"}'
            WHEN 'Child Benefit' THEN '{\"party_types\":\"Person\",\"ordinal\":\"12\"}'
            WHEN 'Dividends' THEN '{\"party_types\":\"Person\",\"ordinal\":\"13\"}'
            WHEN 'Rental Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"14\"}'
            WHEN 'Trust Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"15\"}'
            WHEN 'Annuities' THEN '{\"party_types\":\"Person\",\"ordinal\":\"16\"}'
            WHEN 'Overtime (Guaranteed)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"17\"}'
            WHEN 'Overtime (Regular)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"18\"}'
            WHEN 'Bonus (Guaranteed)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"19\"}'
            WHEN 'Bonus (Regular)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"20\"}'
            WHEN 'Court Order Maintenance' THEN '{\"party_types\":\"Person\",\"ordinal\":\"21\"}'
            WHEN 'Bedroom Rental' THEN '{\"party_types\":\"Person\",\"ordinal\":\"22\"}'
            WHEN 'Allowance' THEN '{\"party_types\":\"Person\",\"ordinal\":\"23\"}'
            WHEN 'London/Large Town Allowance' THEN '{\"party_types\":\"Person\",\"ordinal\":\"24\"}'
            WHEN 'Mortgage Subsidy' THEN '{\"party_types\":\"Person\",\"ordinal\":\"25\"}'
            WHEN 'Benefits' THEN '{\"party_types\":\"Person\",\"ordinal\":\"26\"}'
            WHEN 'Paternal Pay' THEN '{\"party_types\":\"Person\",\"ordinal\":\"27\"}'
            WHEN 'Sick Pay' THEN '{\"party_types\":\"Person\",\"ordinal\":\"28\"}'
            WHEN 'Other Income' THEN '{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"29\"}'
        ELSE Attributes
        END
        WHERE Name IN ('Basic Income', 'Wage/Salary (net)', 'Income earned as a partner/sole proprietor', 'Income earned from any additional full or part-time employment', 'State Pension', 'Company Pension', 'Private Pension', 'Taxable State Benefits', 'Non-Taxable State Benefits', 'Taxable Investment Income', 'Non-Taxable Investment Income', 'Child Benefit', 'Dividends', 'Rental Income', 'Trust Income', 'Annuities', 'Overtime (Guaranteed)', 'Overtime (Regular)', 'Bonus (Guaranteed)', 'Bonus (Regular)', 'Court Order Maintenance', 'Bedroom Rental', 'Allowance', 'London/Large Town Allowance', 'Mortgage Subsidy', 'Benefits', 'Paternal Pay', 'Sick Pay', 'Other Income') 
        AND RegionCode = 'GB';

        UPDATE [factfind].[dbo].[TRefData]
        SET Attributes 
        = CASE Name
            WHEN 'Basic Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"1\"}'
            WHEN 'Wage/Salary (net)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"2\"}'
            WHEN 'Income earned as a partner/sole proprietor' THEN '{\"party_types\":\"Person\",\"ordinal\":\"3\"}'
            WHEN 'Income earned from any additional full or part-time employment' THEN '{\"party_types\":\"Person\",\"ordinal\":\"4\"}'
            WHEN 'State Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"5\"}'
            WHEN 'Company Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"6\"}'
            WHEN 'Private Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"7\"}'
            WHEN 'Taxable State Benefits' THEN '{\"party_types\":\"Person\",\"ordinal\":\"8\"}'
            WHEN 'Non-Taxable State Benefits' THEN '{\"party_types\":\"Person\",\"ordinal\":\"9\"}'
            WHEN 'Taxable Investment Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"10\"}'
            WHEN 'Non-Taxable Investment Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"11\"}'
            WHEN 'Dividends' THEN '{\"party_types\":\"Person\",\"ordinal\":\"12\"}'
            WHEN 'Rental Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"13\"}'
            WHEN 'Trust Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"14\"}'
            WHEN 'Annuities' THEN '{\"party_types\":\"Person\",\"ordinal\":\"15\"}'
            WHEN 'Overtime (Guaranteed)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"16\"}'
            WHEN 'Overtime (Regular)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"17\"}'
            WHEN 'Bonus (Guaranteed)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"18\"}'
            WHEN 'Bonus (Regular)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"19\"}'
            WHEN 'Bedroom Rental' THEN '{\"party_types\":\"Person\",\"ordinal\":\"20\"}'
            WHEN 'Maintenance Payments' THEN '{\"party_types\":\"Person\",\"ordinal\":\"21\"}'
            WHEN 'Working Tax Credit' THEN '{\"party_types\":\"Person\",\"ordinal\":\"22\"}'
            WHEN 'Pension Drawdown' THEN '{\"party_types\":\"Person\",\"ordinal\":\"23\"}'
            WHEN 'ABSTUDY' THEN '{\"party_types\":\"Person\",\"ordinal\":\"24\"}'
            WHEN 'Age Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"25\"}'
            WHEN 'Austudy' THEN '{\"party_types\":\"Person\",\"ordinal\":\"26\"}'
            WHEN 'Capital Gains' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"27\"}'
            WHEN 'Carer Allowance' THEN '{\"party_types\":\"Person\",\"ordinal\":\"28\"}'
            WHEN 'Carer Payment' THEN '{\"party_types\":\"Person\",\"ordinal\":\"29\"}'
            WHEN 'Child Care Rebate' THEN '{\"party_types\":\"Person\",\"ordinal\":\"30\"}'
            WHEN 'Disability Support Pension' THEN '{\"party_types\":\"Person\",\"ordinal\":\"31\"}'
            WHEN 'Exempt Current Pension Income' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"32\"}'
            WHEN 'Family Tax Benefit' THEN '{\"party_types\":\"Person\",\"ordinal\":\"33\"}'
            WHEN 'Foreign Income' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"34\"}'
            WHEN 'Franked Dividends' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"35\"}'
            WHEN 'Franking Credits' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"36\"}'
            WHEN 'General Income' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"37\"}'
            WHEN 'Interest' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"38\"}'
            WHEN 'Profit' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"39\"}'
            WHEN 'Newstart Allowance' THEN '{\"party_types\":\"Person\",\"ordinal\":\"40\"}'
            WHEN 'Non-arms-length Income of a Complying SMSF' THEN '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"41\"}'
            WHEN 'Other Income' THEN '{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"42\"}'
            WHEN 'Other Irregular Income' THEN '{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"43\"}'
        ELSE Attributes
        END
        WHERE Name IN ('Basic Income', 'Wage/Salary (net)', 'Income earned as a partner/sole proprietor', 'Income earned from any additional full or part-time employment', 'State Pension', 'Company Pension', 'Private Pension', 'Taxable State Benefits', 'Non-Taxable State Benefits', 'Taxable Investment Income', 'Non-Taxable Investment Income', 'Dividends', 'Rental Income', 'Trust Income', 'Annuities', 'Overtime (Guaranteed)', 'Overtime (Regular)', 'Bonus (Guaranteed)', 'Bonus (Regular)', 'Bedroom Rental', 'Maintenance Payments', 'Working Tax Credit', 'Pension Drawdown', 'ABSTUDY', 'Age Pension', 'Austudy', 'Capital Gains', 'Carer Allowance', 'Carer Payment', 'Child Care Rebate', 'Disability Support Pension', 'Exempt Current Pension Income', 'Family Tax Benefit', 'Foreign Income', 'Franked Dividends', 'Franking Credits', 'General Income', 'Interest', 'Profit', 'Newstart Allowance', 'Non-arms-length Income of a Complying SMSF', 'Other Income', 'Other Irregular Income') 
        AND RegionCode = 'AU';

        UPDATE [factfind].[dbo].[TRefData]
        SET Attributes 
        = CASE Name
            WHEN 'Basic Income' THEN '{\"party_types\":\"Person\",\"ordinal\":\"1\"}'
            WHEN 'Wage/Salary (net)' THEN '{\"party_types\":\"Person\",\"ordinal\":\"2\"}'
            WHEN 'Income earned as a partner/sole proprietor' THEN '{\"party_types\":\"Person\",\"ordinal\":\"3\"}'
        ELSE Attributes
        END
        WHERE Name IN ('Basic Income', 'Wage/Salary (net)', 'Income earned as a partner/sole proprietor') 
        AND RegionCode = 'US';
				 
        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, @Comments)
 
	IF (@StartTranCount = 0)
		COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF