USE policymanagement;
DECLARE @ScriptGUID UNIQUEIDENTIFIER,
        @Comments VARCHAR(255)
/*
Summary
****************************************************
Adding a few more tax years to a drop down menu
DatabaseName        TableName      Expected Rows
****************************************************
policymanagement      TRefTaxYear   34
*/
SELECT
    @ScriptGUID = 'FF9B30B9-944B-485E-924E-00A02A7099BF',
    @Comments = 'IOSC-1183 Adding a few more tax years to a drop down menu'
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
SET NOCOUNT ON
SET XACT_ABORT ON
BEGIN TRY
BEGIN TRANSACTION

DROP TABLE IF EXISTS #UPDATEDTREFSTATUS
SELECT RefTaxYearId,RefTaxYearName,   
       CASE WHEN Convert(INT,SUBSTRING(RefTaxYearName,0,3))<=25
       THEN '20' + SUBSTRING(RefTaxYearName,0,3)+'/'+ '20'+SUBSTRING(RefTaxYearName,4,2)
       ELSE '19' + SUBSTRING(RefTaxYearName,0,3)+'/'+ '19'+SUBSTRING(RefTaxYearName,4,2)
    END as FULL_YEAR
    INTO #UPDATEDTREFSTATUS
FROM TRefTaxYear ORDER BY RefTaxYearName

UPDATE TRefTaxYear SET RefTaxYearName = FULL_YEAR
FROM TRefTaxYear AS RTY
INNER JOIN #UPDATEDTREFSTATUS AS RTY_COPY ON RTY_COPY.RefTaxYearId = RTY.RefTaxYearId

INSERT INTO TRefTaxYear (RefTaxYearName, RetireFg, ConcurrencyId) VALUES ('2025/2026', 0, 1)
INSERT INTO TRefTaxYear (RefTaxYearName, RetireFg, ConcurrencyId) VALUES ('2026/2027', 0, 1)
INSERT INTO TRefTaxYear (RefTaxYearName, RetireFg, ConcurrencyId) VALUES ('2027/2028', 0, 1)
INSERT INTO TRefTaxYear (RefTaxYearName, RetireFg, ConcurrencyId) VALUES ('2028/2029', 0, 1)
INSERT INTO TRefTaxYear (RefTaxYearName, RetireFg, ConcurrencyId) VALUES ('2029/2030', 0, 1)

UPDATE TRefTaxYear SET RefTaxYearName = '1999/2000' WHERE RefTaxYearId = 4

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW
END CATCH
SET XACT_ABORT OFF
SET NOCOUNT OFF
RETURN;