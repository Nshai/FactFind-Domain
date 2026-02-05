-----------------------------------------------------------------------------
--
-- Summary: INTDAT2-194 SQL - Add Ordinal attribute
--
-----------------------------------------------------------------------------

USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = 'BA0FB792-97A5-4338-B99D-74F946AACEFC'
DECLARE @StartTranCount int

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
    RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
BEGIN TRY

DECLARE @Incomes TABLE(RefDataId INT, Attributes nvarchar(max))

INSERT INTO @Incomes
VALUES 
 (1, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"42\"}')        --Capital Gains,GB
,(2, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"43\"}')        --Foreign Income,GB
,(3, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"44\"}')        --Franking Credits,GB
,(5, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"45\"}')        --Exempt Current Pension Income,GB
,(6, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"46\"}')        --Franked Dividends,GB
,(7, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"47\"}')        --General Income,GB
,(8, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"48\"}')        --Interest,GB
,(9, '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"49\"}')        --Rent,GB
,(10,'{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"50\"}') --Other,GB
,(11,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"51\"}')        --Net Profit,GB
,(12,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"26\"}')        --Capital Gains,AU
,(13,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"33\"}')        --Foreign Income,AU
,(14,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"35\"}')        --Franking Credits,AU
,(16,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"31\"}')        --Exempt Current Pension Income,AU
,(17,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"34\"}')        --Franked Dividends,AU
,(18,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"36\"}')        --General Income,AU
,(19,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"37\"}')        --Interest,AU
,(20,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"42\"}')        --Rent,AU
,(21,'{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"41\"}') --Other,AU
,(22,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"38\"}')        --Net Profit,AU
,(23,'{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"40\"}')        --Non-arms-length Income of a Complying SMSF,AU
,(24,'{\"party_types\":\"Person\",\"ordinal\":\"23\"}')                 --ABSTUDY,AU
,(25,'{\"party_types\":\"Person\",\"ordinal\":\"24\"}')                 --Age Pension,AU
,(26,'{\"party_types\":\"Person\",\"ordinal\":\"22\"}')                 --Allowance,GB
,(27,'{\"party_types\":\"Person\",\"ordinal\":\"15\"}')                 --Annuities,GB
,(28,'{\"party_types\":\"Person\",\"ordinal\":\"14\"}')                 --Annuities,AU
,(29,'{\"party_types\":\"Person\",\"ordinal\":\"25\"}')                 --Austudy,AU
,(30,'{\"party_types\":\"Person\",\"ordinal\":\"29\"}')                 --Basic Income,GB
,(31,'{\"party_types\":\"Person\",\"ordinal\":\"21\"}')                 --Bedroom Rental,GB
,(32,'{\"party_types\":\"Person\",\"ordinal\":\"19\"}')                 --Bedroom Rental,AU
,(33,'{\"party_types\":\"Person\",\"ordinal\":\"25\"}')                 --Benefits,GB
,(34,'{\"party_types\":\"Person\",\"ordinal\":\"18\"}')                 --Bonus (Guaranteed),GB
,(35,'{\"party_types\":\"Person\",\"ordinal\":\"19\"}')                 --Bonus (Regular),GB
,(36,'{\"party_types\":\"Person\",\"ordinal\":\"33\"}')                 --Car Allowance,GB
,(37,'{\"party_types\":\"Person\",\"ordinal\":\"27\"}')                 --Carer Allowance,AU
,(38,'{\"party_types\":\"Person\",\"ordinal\":\"28\"}')                 --Carer Payment,AU
,(39,'{\"party_types\":\"Person\",\"ordinal\":\"11\"}')                 --Child Benefit,GB
,(40,'{\"party_types\":\"Person\",\"ordinal\":\"29\"}')                 --Child Care Rebate,AU
,(41,'{\"party_types\":\"Person\",\"ordinal\":\"5\"}')                  --Company Pension,GB
,(42,'{\"party_types\":\"Person\",\"ordinal\":\"5\"}')                  --Company Pension,AU
,(43,'{\"party_types\":\"Person\",\"ordinal\":\"20\"}')                 --Court Order Maintenance,GB
,(44,'{\"party_types\":\"Person\",\"ordinal\":\"30\"}')                 --Disability Support Pension,AU
,(45,'{\"party_types\":\"Person\",\"ordinal\":\"12\"}')                 --Dividends,GB
,(46,'{\"party_types\":\"Person\",\"ordinal\":\"11\"}')                 --Dividends,AU
,(47,'{\"party_types\":\"Person\",\"ordinal\":\"32\"}')                 --Family Tax Benefit,AU
,(48,'{\"party_types\":\"Person\",\"ordinal\":\"2\"}')                  --Income earned as a partner/sole proprietor,GB
,(49,'{\"party_types\":\"Person\",\"ordinal\":\"2\"}')                  --Income earned as a partner/sole proprietor,AU
,(50,'{\"party_types\":\"Person\",\"ordinal\":\"3\"}')                  --Income earned from any additional full or part-time employment,GB
,(51,'{\"party_types\":\"Person\",\"ordinal\":\"3\"}')                  --Income earned from any additional full or part-time employment,AU
,(52,'{\"party_types\":\"Person\",\"ordinal\":\"38\"}')                 --Life Assurance Bond,GB
,(53,'{\"party_types\":\"Person\",\"ordinal\":\"23\"}')                 --London/Large Town Allowance,GB
,(54,'{\"party_types\":\"Person\",\"ordinal\":\"31\"}')                 --Maintenance Payments,GB
,(55,'{\"party_types\":\"Person\",\"ordinal\":\"20\"}')                 --Maintenance Payments,AU
,(56,'{\"party_types\":\"Person\",\"ordinal\":\"24\"}')                 --Mortgage Subsidy,GB
,(57,'{\"party_types\":\"Person\",\"ordinal\":\"39\"}')                 --Newstart Allowance,AU
,(58,'{\"party_types\":\"Person\",\"ordinal\":\"32\"}')                 --Non-Contributory Pension,GB
,(59,'{\"party_types\":\"Person\",\"ordinal\":\"41\"}')                 --Non-superannuable,GB
,(60,'{\"party_types\":\"Person\",\"ordinal\":\"10\"}')                 --Non-Taxable Investment Income,GB
,(61,'{\"party_types\":\"Person\",\"ordinal\":\"10\"}')                 --Non-Taxable Investment Income,AU
,(62,'{\"party_types\":\"Person\",\"ordinal\":\"8\"}')                  --Non-Taxable State Benefits,GB
,(63,'{\"party_types\":\"Person\",\"ordinal\":\"8\"}')                  --Non-Taxable State Benefits,AU
,(64,'{\"party_types\":\"Person\",\"ordinal\":\"28\"}')                 --Other Income,GB
,(65,'{\"party_types\":\"Person\",\"ordinal\":\"30\"}')                 --Other Irregular Income,GB
,(66,'{\"party_types\":\"Person\",\"ordinal\":\"16\"}')                 --Overtime (Guaranteed),GB
,(67,'{\"party_types\":\"Person\",\"ordinal\":\"15\"}')                 --Overtime (Guaranteed),AU
,(68,'{\"party_types\":\"Person\",\"ordinal\":\"17\"}')                 --Overtime (Regular),GB
,(69,'{\"party_types\":\"Person\",\"ordinal\":\"16\"}')                 --Overtime (Regular),AU
,(70,'{\"party_types\":\"Person\",\"ordinal\":\"26\"}')                 --Paternal Pay,GB
,(71,'{\"party_types\":\"Person\",\"ordinal\":\"39\"}')                 --Pension Drawdown,GB
,(72,'{\"party_types\":\"Person\",\"ordinal\":\"22\"}')                 --Pension Drawdown,AU
,(73,'{\"party_types\":\"Person\",\"ordinal\":\"6\"}')                  --Private Pension,GB
,(74,'{\"party_types\":\"Person\",\"ordinal\":\"6\"}')                  --Private Pension,AU
,(75,'{\"party_types\":\"Person\",\"ordinal\":\"13\"}')                 --Rental Income,GB
,(76,'{\"party_types\":\"Person\",\"ordinal\":\"12\"}')                 --Rental Income,AU
,(77,'{\"party_types\":\"Person\",\"ordinal\":\"37\"}')                 --Shift Allowance,GB
,(78,'{\"party_types\":\"Person\",\"ordinal\":\"27\"}')                 --Sick Pay,GB
,(79,'{\"party_types\":\"Person\",\"ordinal\":\"34\"}')                 --State Benefit - Guaranteed,GB
,(80,'{\"party_types\":\"Person\",\"ordinal\":\"35\"}')                 --State Benefit - Renewable,GB
,(81,'{\"party_types\":\"Person\",\"ordinal\":\"4\"}')                  --State Pension,GB
,(82,'{\"party_types\":\"Person\",\"ordinal\":\"4\"}')                  --State Pension,AU
,(83,'{\"party_types\":\"Person\",\"ordinal\":\"40\"}')                 --Superannuable,GB
,(84,'{\"party_types\":\"Person\",\"ordinal\":\"9\"}')                  --Taxable Investment Income,GB
,(85,'{\"party_types\":\"Person\",\"ordinal\":\"9\"}')                  --Taxable Investment Income,AU
,(86,'{\"party_types\":\"Person\",\"ordinal\":\"7\"}')                  --Taxable State Benefits,GB
,(87,'{\"party_types\":\"Person\",\"ordinal\":\"7\"}')                  --Taxable State Benefits,AU
,(88,'{\"party_types\":\"Person\",\"ordinal\":\"14\"}')                 --Trust Income,GB
,(89,'{\"party_types\":\"Person\",\"ordinal\":\"13\"}')                 --Trust Income,AU
,(90,'{\"party_types\":\"Person\",\"ordinal\":\"52\"}')                 --Universal Credit,GB
,(91,'{\"party_types\":\"Person\",\"ordinal\":\"1\"}')                  --Wage/Salary (net),GB
,(92,'{\"party_types\":\"Person\",\"ordinal\":\"1\"}')                  --Wage/Salary (net),AU
,(93,'{\"party_types\":\"Person\",\"ordinal\":\"43\"}')                 --Widow Allowance,AU
,(94,'{\"party_types\":\"Person\",\"ordinal\":\"36\"}')                 --Working Tax Credit,GB
,(95,'{\"party_types\":\"Person\",\"ordinal\":\"21\"}')                 --Working Tax Credit,AU
,(96,'{\"party_types\":\"Person\",\"ordinal\":\"44\"}')                 --Youth Allowance,AU
,(97,'{\"party_types\":\"Person\",\"ordinal\":\"17\"}')                 --Bonus (Guaranteed),AU
,(98,'{\"party_types\":\"Person\",\"ordinal\":\"18\"}')                 --Bonus (Regular),AU

        
        SELECT @StartTranCount = @@TRANCOUNT

        IF (@StartTranCount = 0)
        BEGIN TRANSACTION
        
        UPDATE rf
        SET rf.Attributes = i.Attributes
        FROM [TRefData] rf 
        INNER JOIN @Incomes i ON i.RefDataId = rf.RefDataId

        -- Record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (@ScriptGUID, 'Add Ordinal attribute to Income category ref data')
 
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