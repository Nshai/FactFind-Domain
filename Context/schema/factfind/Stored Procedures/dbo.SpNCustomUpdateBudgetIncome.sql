SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateBudgetIncome]
	@StampUser bigint,  
	@BudgetIncomeId bigint, -- Equates to Personid
	@ConcurrencyId bigint = 0, -- Not currently used  
	@CrmContactId bigint,
	@Salary money = NULL	
AS                        
DECLARE @PersonId bigint, @CurrentSalary money
-- Get the current salary
SET @PersonId = @BudgetIncomeId
SELECT @CurrentSalary = Salary FROM CRM..TPerson WHERE PersonId = @PersonId

-- If salary has not changed then exit
IF ISNULL(@Salary, -1) = ISNULL(@CurrentSalary, -1)
	RETURN;

-- Audit
EXEC CRM..SpNAuditPerson @StampUser, @PersonId, 'U'
-- Update
UPDATE CRM..TPerson
SET 
	Salary = @Salary,
	ConcurrencyId = ConcurrencyId + 1
WHERE 
	PersonId = @PersonId
GO
