-----------------------------------------------------------------------------
--
-- Summary: INTTFF-103 SQL - Add additional Income category reference data
--
-----------------------------------------------------------------------------

USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '55DA080B-77F3-485A-85D5-3F94005CAC63'
DECLARE @StartTranCount int

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
	RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
BEGIN TRY
    SELECT @StartTranCount = @@TRANCOUNT

    IF (@StartTranCount = 0)
    BEGIN TRANSACTION
 
		-- First corrections to the existing income type reference data
		DELETE FROM [TRefData]
		WHERE [RefDataId] IN (4, 15)

		UPDATE [TRefData]
		SET [Attributes] = '{\"party_types\":\"Person,Trust,Corporate\"}'
		WHERE [RefDataId] IN (10, 21)

		UPDATE [TRefData]
		SET [Attributes] = '{\"party_types\":\"Trust,Corporate\"}'
		WHERE [RefDataId] IN (11, 22)

		UPDATE [TRefData]
		SET [RegionCode] = 'UK'
		WHERE [RefDataId] = 11

		UPDATE [TRefData]
		SET [RegionCode] = 'UK'
		WHERE [RegionCode] = 'GB'

		-- Now add the new additions to the table
		SET IDENTITY_INSERT [TRefData] ON
 
		INSERT INTO [TRefData]([RefDataId],[Name],[Type],[Property],[RegionCode],[Attributes])
		VALUES  (24, 'ABSTUDY', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(25, 'Age Pension', 'income', 'category', 'AU' ,'{\"party_types\":\"Person\"}'), 
				(26, 'Allowance', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(27, 'Annuities', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(28, 'Annuities', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
		
				(29, 'Austudy', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(30, 'Basic Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(31, 'Bedroom Rental', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(32, 'Bedroom Rental', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(33, 'Benefits', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(34, 'Bonus (Guaranteed)', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(35, 'Bonus (Regular)', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(36, 'Car Allowance', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(37, 'Carer Allowance', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(38, 'Carer Payment', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 

				(39, 'Child Benefit', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(40, 'Child Care Rebate', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(41, 'Company Pension', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(42, 'Company Pension', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(43, 'Court Order Maintenance', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(44, 'Disability Support Pension', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(45, 'Dividends', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(46, 'Dividends', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(47, 'Family Tax Benefit', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(48, 'Income earned as a partner/sole proprietor', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(49, 'Income earned as a partner/sole proprietor', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(50, 'Income earned from any additional full or part-time employment', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(51, 'Income earned from any additional full or part-time employment', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(52, 'Life Assurance Bond', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(53, 'London/Large Town Allowance', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
		
				(54, 'Maintenance Payments', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(55, 'Maintenance Payments', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(56, 'Mortgage Subsidy', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(57, 'Newstart Allowance', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(58, 'Non-Contributory Pension', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(59, 'Non-superannuable', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(60, 'Non-Taxable Investment Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(61, 'Non-Taxable Investment Income', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(62, 'Non-Taxable State Benefits', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(63, 'Non-Taxable State Benefits', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 

				(64, 'Other Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(65, 'Other Irregular Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(66, 'Overtime (Guaranteed)', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(67, 'Overtime (Guaranteed)', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(68, 'Overtime (Regular)', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(69, 'Overtime (Regular)', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(70, 'Paternal Pay', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(71, 'Pension Drawdown', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(72, 'Pension Drawdown', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(73, 'Private Pension', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(74, 'Private Pension', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(75, 'Rental Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(76, 'Rental Income', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(77, 'Shift Allowance', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(78, 'Sick Pay', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 

				(79, 'State Benefit - Guaranteed', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(80, 'State Benefit - Renewable', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(81, 'State Pension', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'), 
				(82, 'State Pension', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'), 
				(83, 'Superannuable', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),

				(84, 'Taxable Investment Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),
				(85, 'Taxable Investment Income', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(86, 'Taxable State Benefits', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),
				(87, 'Taxable State Benefits', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(88, 'Trust Income', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),

				(89, 'Trust Income', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(90, 'Universal Credit', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),
				(91, 'Wage/Salary (net)', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),
				(92, 'Wage/Salary (net)', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(93, 'Widow Allowance', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),

				(94, 'Working Tax Credit', 'income', 'category', 'UK', '{\"party_types\":\"Person\"}'),
				(95, 'Working Tax Credit', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}'),
				(96, 'Youth Allowance', 'income', 'category', 'AU', '{\"party_types\":\"Person\"}')				
				
        SET IDENTITY_INSERT [TRefData] OFF
 
        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, 'Update Income category ref data based on region')
 
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