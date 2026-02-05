USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = 'ED794C1A-16DF-4975-B574-E396EE74ADC0',
       @Comments = 'FPA-25093 Populate default values in TRefWithdrawalSubType table'

 -- check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- insert the records
        SET IDENTITY_INSERT TRefWithdrawalSubType ON;

        INSERT INTO TRefWithdrawalSubType([RefWithdrawalSubTypeId], [Name])
        VALUES
        (1, 'Uncrystallised Funds Pension Lump Sum (UFPLS)'),
        (2, 'Pension Commencement Lump Sum (PCLS) (3)'),
		(3, 'Tax Free Lump Sum'),
		(4, 'Income'),
		(5, 'Pension Commencement Excess Lump Sum (PCELS)'),
		(6, 'Small Lump Sum'),
		(7, 'Trivial Commutation Lump Sum'),
		(8, 'Trivial Commutation Lump Sum Death Benefit'),
		(9, 'Standalone Lump Sum'),
		(10, 'Pension Debit'),
		(11, 'Serious Ill-Health Lump Sum (SIHLS)'),
		(12, 'Defined Benefits Lump Sum Death Benefit'),
		(13, 'Winding Up Lump Sum'),
		(14, 'Winding Up Lump Sum Death Benefit'),
		(15, 'Annual Allowance Tax Charge (Scheme Pays)'),
		(16, 'Pension Protection Lump Sum Death Benefit'),
		(17, 'Uncrystallised Funds Lump Sum Death Benefit'),
		(18, 'Annuity Protection Lump Sum Death Benefit'),
		(19, 'Drawdown Pension Fund Lump Sum Death Benefit'),
		(20, 'Charity Lump Sum Death Payment'),
		(21, 'Special Lump Sum Death Benefit Charge'),
		(22, 'Short Service Refund Lump Sum'),
		(23, 'Refund of Excess Contribution Lump Sum'),
		(24, 'Overseas Transfer Charge (OTC)'),
		(25, 'Inheritance Tax Charge')

        SET IDENTITY_INSERT TRefWithdrawalSubType OFF

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp)
        VALUES (@ScriptGUID, @Comments, null, getdate() )

   IF @starttrancount = 0
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

 SET XACT_ABORT OFF
 SET NOCOUNT OFF