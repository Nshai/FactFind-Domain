SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanning]  
 @StampUser varchar (255),  
 @FinancialPlanningId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TFinancialPlanningAudit   
(FactFindId, AdjustValue, RefPlanningTypeId, RefInvestmentTypeId, IncludeAssets, RegularImmediateIncome, IsArchived, ConcurrencyId,  
 FinancialPlanningId, StampAction, StampDateTime, StampUser,goaltype,RefLumpsumAtRetirementTypeId)  
SELECT  FactFindId, AdjustValue, RefPlanningTypeId, RefInvestmentTypeId, IncludeAssets, RegularImmediateIncome, IsArchived,ConcurrencyId,  
 FinancialPlanningId, @StampAction, GetDate(), @StampUser ,goaltype,RefLumpsumAtRetirementTypeId
FROM TFinancialPlanning  
WHERE FinancialPlanningId = @FinancialPlanningId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
