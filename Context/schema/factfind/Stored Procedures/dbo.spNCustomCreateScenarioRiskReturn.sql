SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomCreateScenarioRiskReturn]  
@financialplanningid bigint,  
@financialplanningScenarioid bigint,  
@AverageAnnualReturn decimal(18, 9),  
@AverageVolatilityReturn decimal(18, 9)  
  
as  
  
delete from TFinancialPlanningScenarioRiskReturn  
where @financialplanningScenarioid = financialplanningScenarioid  
  
insert into TFinancialPlanningScenarioRiskReturn  
select @financialplanningScenarioid,@AverageAnnualReturn,@AverageVolatilityReturn,@financialplanningid

GO
