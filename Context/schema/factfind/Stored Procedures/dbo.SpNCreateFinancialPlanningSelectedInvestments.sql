SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningSelectedInvestments]
	@StampUser varchar (255),
	@FinancialPlanningId bigint, 
	@InvestmentId bigint, 
	@InvestmentType varchar(50) 	
AS
  
  
DECLARE @FinancialPlanningSelectedInvestmentsId bigint, @Result int  

-- Check if the ID is returned something based on InvestmentId and InvestmentType
--	If 'Yes' then it is a duplicate record and we need to exit the SP. (RVIII-245)
SELECT @FinancialPlanningSelectedInvestmentsId = FinancialPlanningSelectedInvestmentsId
FROM TFinancialPlanningSelectedInvestments
WHERE FinancialPlanningId = @FinancialPlanningId
AND InvestmentId = @InvestmentId
AND InvestmentType = @InvestmentType

IF ISNULL(@FinancialPlanningSelectedInvestmentsId, 0) > 0
BEGIN
	Execute dbo.SpNRetrieveFinancialPlanningSelectedInvestmentsByFinancialPlanningSelectedInvestmentsId @FinancialPlanningSelectedInvestmentsId  
	RETURN
END
     
     
   
INSERT INTO TFinancialPlanningSelectedInvestments  
(FinancialPlanningId, InvestmentId, InvestmentType, ConcurrencyId)  
VALUES(@FinancialPlanningId, @InvestmentId, @InvestmentType, 1)  
  
SELECT @FinancialPlanningSelectedInvestmentsId = SCOPE_IDENTITY(), @Result = @@ERROR  
IF @Result != 0 GOTO errh  
  
  
Execute @Result = dbo.SpNAuditFinancialPlanningSelectedInvestments @StampUser, @FinancialPlanningSelectedInvestmentsId, 'C'  
  
IF @Result  != 0 GOTO errh  
  
Execute dbo.SpNRetrieveFinancialPlanningSelectedInvestmentsByFinancialPlanningSelectedInvestmentsId @FinancialPlanningSelectedInvestmentsId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
GO
