SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveEValueGoal] @FinancialPlanningId int, @group int    
    
as    
    
declare @TargetAmount int, @maxTerm  int  , @maxTermObjectiveId int  
declare @RefLumpsumAtRetirementTypeId bigint, @percentageAtRetiremnt money
      
select @maxterm = max(CASE  
       WHEN getdate() > targetdate THEN 12  
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1  
       ELSE DATEDIFF(month, getdate(), targetdate)  
END / 12)     
     from TFinancialPlanningSelectedGoals g    
     inner join TObjective o on o.objectiveid = g.objectiveid    
     where g.FinancialPlanningId = @FinancialPlanningId    
  
    
select @TargetAmount = sum(isnull(TargetAmount,0))     
      from TFinancialPlanningSelectedGoals g    
      inner join TObjective o on o.objectiveid = g.objectiveid    
      where g.FinancialPlanningId = @FinancialPlanningId and    
      CASE  
       WHEN getdate() > targetdate THEN 12  
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1  
       ELSE DATEDIFF(month, getdate(), targetdate)  
END / 12 = @maxterm      

-- Lets get what type of ref lumpsum at retirement typs it is in case of a retirement session. This will be needed for modelling.
select top 1
		@RefLumpsumAtRetirementTypeId= o.RefLumpsumAtRetirementTypeId,
		@percentageAtRetiremnt = o.LumpSumAtRetirement
	  from TFinancialPlanningSelectedGoals g      
	  inner join TObjective o on o.objectiveid = g.objectiveid  
	  where g.FinancialPlanningId = @FinancialPlanningId --and o.RefLumpsumAtRetirementTypeId = 2
	 order by LumpSumAtRetirement desc
  
select      
@group as id ,    
@RefLumpsumAtRetirementTypeId as RefLumpsumAtRetirementTypeId,
@percentageAtRetiremnt as PercentageAtRetirement,
'Financial Planning Goal' as name,    
cast(datepart(yyyy,getdate()) as varchar(4)) +     
right('00' + cast(datepart(mm,getdate()) as varchar(2)),2) +     
right('00' + cast(datepart(dd,getdate()) as varchar(2)),2)     
 as dateCreated,    
@TargetAmount as targetAmount,    
case when AdjustValue = 1 then 'RPI' else '0' end as todayFactor,    
case when g.RegularImmediateIncome = 0 then 'FORECAST_LUMPSUM'  else 'FORECAST_ANNUITY' end as forecastType,    
@group as groupid     
from TFinancialPlanning g    
where g.FinancialPlanningId = @FinancialPlanningId    
    
GO
