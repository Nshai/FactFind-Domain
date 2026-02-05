SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListPolicyMoneyIn]      
 @PolicyBusinessId bigint      
AS      
      
BEGIN      
  SELECT      
    1 AS Tag,      
    NULL AS Parent,      
    T1.PolicyMoneyInId AS [PolicyMoneyIn!1!PolicyMoneyInId],       
    ISNULL(CONVERT(varchar(24), T1.Amount), '') AS [PolicyMoneyIn!1!Amount],       
    ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), '') AS [PolicyMoneyIn!1!EscalationPercentage],       
    T1.RefFrequencyId AS [PolicyMoneyIn!1!RefFrequencyId],       
    ISNULL(CONVERT(varchar(24), T1.StartDate, 120),'') AS [PolicyMoneyIn!1!StartDate],       
    T1.PolicyBusinessId AS [PolicyMoneyIn!1!PolicyBusinessId],       
    ISNULL(T1.RefTaxBasisId, '') AS [PolicyMoneyIn!1!RefTaxBasisId],       
    ISNULL(T1.RefTaxYearId, '') AS [PolicyMoneyIn!1!RefTaxYearId],       
    ISNULL(T1.RefContributionTypeId, '') AS [PolicyMoneyIn!1!RefContributionTypeId],       
    ISNULL(T1.RefContributorTypeId, '') AS [PolicyMoneyIn!1!RefContributorTypeId],       
    ISNULL(T1.CurrentFg, '') AS [PolicyMoneyIn!1!CurrentFg],       
    ISNULL(T1.RefEscalationTypeId, '') AS [PolicyMoneyIn!1!RefEscalationTypeId],       
    ISNULL(CONVERT(varchar(24), T1.SalaryPercentage), '') AS [PolicyMoneyIn!1!SalaryPercentage],       
    ISNULL(CONVERT(varchar(24), T1.StopDate, 120),'') AS [PolicyMoneyIn!1!StopDate],      
    CASE      
 when isnull(t1.StartDate,getdate()) > getdate()      
  then 0      
 when  t1.RefFrequencyId=1 --weekly      
  then t1.amount + (t1.amount * floor(datediff(day,t1.StartDate,AdjustedStopDate)/7))      
      
 when  t1.RefFrequencyId=2 --fortnightly       
  then amount + (amount * floor((datediff(day,StartDate,AdjustedStopDate)/7)/2))      
      
 when  t1.RefFrequencyId=3 --four weekly      
  then amount + (amount * floor((datediff(day,StartDate,AdjustedStopDate)/7)/4))      
      
 when  t1.RefFrequencyId=4 --monthly      
  and datepart(day,AdjustedStopDate) < datepart(day,StartDate) then       
   amount + (amount * (datediff(month,StartDate,AdjustedStopDate)-1))      
      
 when  t1.RefFrequencyId=4 --monthly      
  and datepart(day,AdjustedStopDate) >= datepart(day,StartDate) then       
   amount + (amount * (datediff(month,StartDate,AdjustedStopDate)))      
      
-- when  t1.RefFrequencyId=5 --quarterly      
--  and ((datepart(month,AdjustedStopDate)/3)+1) < ((datepart(month,StartDate)/3)+1) then       
--   amount + (amount * ((datediff(month,StartDate,AdjustedStopDate)/3)))      
  
 when  t1.RefFrequencyId=5 --quarterly    
  then amount + (amount * (datediff(quarter,StartDate,AdjustedStopDate) -   
      case when 1=1 and DateAdd(q,DATEDIFF(q,StartDate,AdjustedStopDate),StartDate)<=AdjustedStopDate then 0 else 1 end))          
        
-- when  t1.RefFrequencyId=5 --quarterly      
--  and ((datepart(month,AdjustedStopDate)/3)+1) >= ((datepart(month,StartDate)/3)+1) then       
--   amount + (amount * (datediff(month,StartDate,AdjustedStopDate)/3+1))      
         
 --when  t.RefFrequencyId=6 then 6 -- termly - what the heck is this?      
       
 when  t1.RefFrequencyId=7 --half yearly      
  and (((datepart(month,AdjustedStopDate)-1)/6) + 1) < (((datepart(month,StartDate)-1)/6) + 1) then       
   amount + (amount * ((datediff(month,StartDate,AdjustedStopDate)/6)))      
      
 when  t1.RefFrequencyId=7 --half yearly      
  and (((datepart(month,AdjustedStopDate)-1)/6) + 1) >= (((datepart(month,StartDate)-1)/6) + 1) then       
   amount + (amount * (datediff(month,StartDate,AdjustedStopDate)/6+1))      
      
/*      
 when  t1.RefFrequencyId=8 --annually      
  and datepart(dayofyear,getdate()) < datepart(dayofyear,StartDate) then      
   amount + (amount * (datediff(year,StartDate, AdjustedStopDate)-1))      
      
 when  t1.RefFrequencyId=8 --annually      
  and datepart(dayofyear,getdate()) >= datepart(dayofyear,StartDate) then      
   amount + (amount * (datediff(year,StartDate, AdjustedStopDate)))      
*/      
-- AJF - regular annual calculation was wrong - since DATEDIFF(YEAR, '31 dec 2005', '1 jan 2006') = 1 according to sql server (should be 0)      
 when  t1.RefFrequencyId=8 then      
  amount + ( amount * ( DATEDIFF(YY,StartDate, AdjustedStopDate) - CASE WHEN ( MONTH(StartDate) = MONTH(AdjustedStopDate) AND DAY(StartDate) > DAY(AdjustedStopDate) OR MONTH(StartDate) > MONTH(AdjustedStopDate) ) THEN 1 ELSE 0 END ) )      
      
 -- AJF - shouldn't be making rebates negative      
 --when  t1.RefFrequencyId=9 and t1.RefContributionTypeId=4 then amount * -1 -- single      
 --when  t1.RefFrequencyId=9 and t1.RefContributionTypeId<4 then amount -- single      
 --when  t1.RefFrequencyId=10 and t1.RefContributionTypeId=4 then amount * -1 -- single      
 --when  t1.RefFrequencyId=10 and t1.RefContributionTypeId<4 then amount -- single      
 when  t1.RefFrequencyId=9 then amount      
 when  t1.RefFrequencyId=10 then amount      
      
      
         
      
    END as [PolicyMoneyIn!1!ContributionsToDate],       
      
    CASE      
 when  t1.RefFrequencyId=1 --weekly      
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 52      
      
 when  t1.RefFrequencyId=2 --fortnightly       
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 26      
      
 when  t1.RefFrequencyId=3 --four weekly      
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 13      
      
 when  t1.RefFrequencyId=4 --monthly      
  and (StopDate is null or StopDate > GetDate())       
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 12      
      
 when  t1.RefFrequencyId=5 --quarterly      
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 4      
         
 --when  t.RefFrequencyId=6 then 6 -- termly - what the heck is this?      
       
 when  t1.RefFrequencyId=7 --half yearly      
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount * 2      
      
 when  t1.RefFrequencyId=8 --annually      
  and (StopDate is null or StopDate > GetDate())      
  and (StartDate <= GetDate() or StartDate is null)      
  then amount      
      
    END as [PolicyMoneyIn!1!AnnualisedContributions],      
    ISNULL(T2.BaseCurrency, 'GBP') AS [PolicyMoneyIn!1!BaseCurrency],      
    CASE       
 WHEN T1.StartDate <= getdate()      
  and StopDate is null or StopDate > getdate()      
  then 1      
 ELSE 0      
    END as [PolicyMoneyIn!1!IsCurrent],      
    T1.ConcurrencyId AS [PolicyMoneyIn!1!ConcurrencyId],       
    NULL AS [RefFrequency!2!RefFrequencyId],       
    NULL AS [RefFrequency!2!FrequencyName],       
    NULL AS [RefFrequency!2!OrigoRef],       
    NULL AS [RefFrequency!2!RetireFg],       
    NULL AS [RefFrequency!2!OrderNo],       
    NULL AS [RefFrequency!2!ConcurrencyId],       
    NULL AS [RefContributionType!3!RefContributionTypeId],       
    NULL AS [RefContributionType!3!RefContributionTypeName],       
    NULL AS [RefContributionType!3!RetireFg],       
    NULL AS [RefContributionType!3!ConcurrencyId],       
    NULL AS [RefContributorType!4!RefContributorTypeId],       
    NULL AS [RefContributorType!4!RefContributorTypeName],       
    NULL AS [RefContributorType!4!RetireFg],       
    NULL AS [RefContributorType!4!ConcurrencyId]      
  FROM     
 (    
 SELECT    
  *,    
   CASE     
   WHEN StopDate IS NULL THEN GETDATE()    
   WHEN StopDate > GETDATE() THEN GETDATE()    
   ELSE StopDate    
  END AS AdjustedStopDate        
 FROM    
  TPolicyMoneyIn    
 WHERE    
  PolicyBusinessId = @PolicyBusinessId    
 )  AS T1    
 JOIN TPolicyBusiness T2 ON T1.PolicyBusinessId = T2.PolicyBusinessId      
      
  UNION ALL     
      
  SELECT      
    2 AS Tag,      
    1 AS Parent,      
    T1.PolicyMoneyInId,       
    ISNULL(CONVERT(varchar(24), T1.Amount), ''),       
    ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), ''),       
    T1.RefFrequencyId,       
    ISNULL(CONVERT(varchar(24), T1.StartDate, 120),''),       
    T1.PolicyBusinessId,       
    ISNULL(T1.RefTaxBasisId, ''),       
    ISNULL(T1.RefTaxYearId, ''),       
    ISNULL(T1.RefContributionTypeId, ''),       
    ISNULL(T1.RefContributorTypeId, ''),       
    ISNULL(T1.CurrentFg, ''),       
    ISNULL(T1.RefEscalationTypeId, ''),       
    ISNULL(CONVERT(varchar(24), T1.SalaryPercentage), ''),       
    ISNULL(CONVERT(varchar(24), T1.StopDate, 120),''),       
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    T1.ConcurrencyId,       
    T2.RefFrequencyId,      
    ISNULL(T2.FrequencyName, ''),       
    ISNULL(T2.OrigoRef, ''),       
    ISNULL(T2.RetireFg, ''),       
    ISNULL(T2.OrderNo, ''),       
    T2.ConcurrencyId,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL      
  FROM TRefFrequency T2      
  INNER JOIN TPolicyMoneyIn T1      
  ON T2.RefFrequencyId = T1.RefFrequencyId      
      
  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)      
      
  UNION ALL      
      
  SELECT      
    3 AS Tag,      
    1 AS Parent,      
    T1.PolicyMoneyInId,       
    ISNULL(CONVERT(varchar(24), T1.Amount), ''),       
    ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), ''),       
    T1.RefFrequencyId,       
    ISNULL(CONVERT(varchar(24), T1.StartDate, 120),''),       
    T1.PolicyBusinessId,       
    ISNULL(T1.RefTaxBasisId, ''),       
    ISNULL(T1.RefTaxYearId, ''),       
    ISNULL(T1.RefContributionTypeId, ''),       
    ISNULL(T1.RefContributorTypeId, ''),       
    ISNULL(T1.CurrentFg, ''),       
    ISNULL(T1.RefEscalationTypeId, ''),       
    ISNULL(CONVERT(varchar(24), T1.SalaryPercentage), ''),       
    ISNULL(CONVERT(varchar(24), T1.StopDate, 120),''),       
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    T1.ConcurrencyId,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    T3.RefContributionTypeId,       
    T3.RefContributionTypeName,       
    T3.RetireFg,       
    T3.ConcurrencyId,       
    NULL,       
    NULL,       
    NULL,       
    NULL      
  FROM TRefContributionType T3      
  INNER JOIN TPolicyMoneyIn T1      
  ON T3.RefContributionTypeId = T1.RefContributionTypeId      
      
  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)      
      
  UNION ALL      
      
  SELECT      
    4 AS Tag,      
    1 AS Parent,      
    T1.PolicyMoneyInId,       
    ISNULL(CONVERT(varchar(24), T1.Amount), ''),       
    ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), ''),       
    T1.RefFrequencyId,       
    ISNULL(CONVERT(varchar(24), T1.StartDate, 120),''),       
    T1.PolicyBusinessId,       
    ISNULL(T1.RefTaxBasisId, ''),       
    ISNULL(T1.RefTaxYearId, ''),       
    ISNULL(T1.RefContributionTypeId, ''),       
    ISNULL(T1.RefContributorTypeId, ''),       
    ISNULL(T1.CurrentFg, ''),       
    ISNULL(T1.RefEscalationTypeId, ''),       
    ISNULL(CONVERT(varchar(24), T1.SalaryPercentage), ''),       
    ISNULL(CONVERT(varchar(24), T1.StopDate, 120),''),       
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    T1.ConcurrencyId,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    T4.RefContributorTypeId,       
    T4.RefContributorTypeName,       
    T4.RetireFg,       
    T4.ConcurrencyId      
  FROM TRefContributorType T4      
  INNER JOIN TPolicyMoneyIn T1      
  ON T4.RefContributorTypeId = T1.RefContributorTypeId      
      
  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)      
      
  ORDER BY [PolicyMoneyIn!1!PolicyMoneyInId], [RefContributorType!4!RefContributorTypeId], [RefContributionType!3!RefContributionTypeId], [RefFrequency!2!RefFrequencyId]      
      
  FOR XML EXPLICIT      
      
END      
RETURN (0)      
GO
