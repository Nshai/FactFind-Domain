SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNUpdateFinancialPlanningStatePension]  
 --@FinancialPlanningStatePensionId Bigint,  
 --@ConcurrencyId bigint,  
 @StampUser varchar (255),  
 @CRMContactId bigint,   
 @RefPensionForecastId int,   
 @BasicAnnualAmount money,   
 @AdditionalAnnualAmount money,  
 @TaxYearStartWork int,  
 @TaxYearFinishWork int,  
 @AnnualSalary money  
  
AS  
  
insert into TFinancialPlanningStatePensionAudit
(CRMContactId,
RefPensionForecastId,
BasicAnnualAmount,
AdditionalAnnualAmount,
TaxYearStartWork,
TaxYearFinishWork,
AnnualSalary,
ConcurrencyId,FinancialPlanningStatePensionId,StampAction,StampDateTime,StampUser)
select CRMContactId,
RefPensionForecastId,
BasicAnnualAmount,
AdditionalAnnualAmount,
TaxYearStartWork,
TaxYearFinishWork,
AnnualSalary,
ConcurrencyId,FinancialPlanningStatePensionId,'D',getdate(),@StampUser
from	TFinancialPlanningStatePension
where	crmcontactid = @CRMContactId
  
delete TFinancialPlanningStatePension
where crmcontactid = @crmcontactid

INSERT INTO TFinancialPlanningStatePension  
(CRMContactId, RefPensionForecastId, BasicAnnualAmount, AdditionalAnnualAmount,TaxYearStartWork, TaxYearFinishWork,AnnualSalary, ConcurrencyId)  
VALUES(@CRMContactId, @RefPensionForecastId, @BasicAnnualAmount, @AdditionalAnnualAmount,@TaxYearStartWork, @TaxYearFinishWork,@AnnualSalary, 1)    
  
GO
