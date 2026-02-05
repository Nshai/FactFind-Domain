SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningAdditionalFund]
	@FinancialPlanningAdditionalFundId Bigint,
	@StampUser varchar (255)
	
AS


Declare @Result int
Execute @Result = dbo.SpNAuditFinancialPlanningAdditionalFund @StampUser, @FinancialPlanningAdditionalFundId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TFinancialPlanningAdditionalFund T1
WHERE T1.FinancialPlanningAdditionalFundId = @FinancialPlanningAdditionalFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
