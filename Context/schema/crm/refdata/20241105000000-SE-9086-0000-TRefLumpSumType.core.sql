USE CRM;

DECLARE @ScriptGUID UNIQUEIDENTIFIER,
        @Comments   VARCHAR(255)

/*
Summary
SE-9086: [SQL] [SE-8492] Extend FinanceAndTax API for LSDBA
Insert values into TRefLumpSumType

DatabaseName		TableName			Expected Rows
CRM					TRefLumpSumType		10
*/

SELECT @ScriptGUID = '8D99DFB9-7DA9-4CC5-BAC3-16EA8AE008CB',
	@Comments = 'SE-9086: [SQL] [SE-8492] Extend FinanceAndTax API for LSDBA'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @date DATETIME = GETUTCDATE();
		
INSERT INTO [TRefLumpSumType]
	([RefLumpSumTypeId]
	,[TypeName])
OUTPUT  
	inserted.RefLumpSumTypeId,
	inserted.TypeName,
	'C',
	@date,
	0
INTO TRefLumpSumTypeAudit
	(RefLumpSumTypeId
	,TypeName
	,StampAction
	,StampDateTime
	,StampUser)
VALUES
	(1, 'Pension Commencement Lump Sum'),
	(2, 'Uncrystallised Funds Pension Lump Sum'),
	(3, 'Stand-Alone Lump Sum'),
	(4, 'Serious Ill-Health Lump Sum'),
	(5, 'Uncrystallised funds lump sum death benefit'),
	(6, 'Drawdown pension fund lump sum death benefit'),
	(7, 'Flexi-access drawdown lump sum death benefits'),
	(8, 'Defined benefit lump sum death benefit'),
	(9, 'Pension protection lump sum death benefit'),
	(10,'Annuity protection lump sum death benefit')

INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;