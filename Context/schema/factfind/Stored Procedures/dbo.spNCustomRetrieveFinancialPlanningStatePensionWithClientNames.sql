SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningStatePensionWithClientNames] 

@FinancialPlanningId bigint,
@CRMContactid int,	
@CRMContactid2 int = 0

as

declare @TaxYearFinish bigint

select @TaxYearFinish = max(datepart(yyyy,isnull(TargetDate,getdate())))
from TFinancialPlanningSelectedGoals s
inner join TObjective o on o.objectiveid = s.objectiveid
where financialplanningid = @FinancialPlanningId


select	crm.CRMContactId,
		isnull(FinancialPlanningStatePensionId,0) as FinancialPlanningStatePensionId,
		crm.FirstName + ' ' + crm.LastName as ClientName,
		isnull(fpsa.RefPensionForecastId,5) as RefPensionForecastId,
		(isnull(RefPensionForecastDescription,'Manual')) as RefPensionForecastDescription,
		cast(isnull(BasicAnnualAmount, 0.00)as varchar) as BasicAnnualAmount,
		cast(isnull(AdditionalAnnualAmount, 0.00)as varchar) as AdditionalAnnualAmount,
		case when p.DOB is null then null else  
			left('0' + cast(datepart(d,p.dob) as varchar),2) + '/' +		
			left('0' + cast(datepart(m,p.dob) as varchar),2) + '/' + 
			cast(datepart(yyyy,p.dob) as varchar)		
		 end
		as dateOfBirth,
		GenderType as Gender,		
		case when isnull(AnnualSalary,0)= 0 then isnull(Salary,0) else isnull(AnnualSalary,0) end as TotalEarnings,
		isnull(TaxYearStartWork,datepart(yyyy,getdate())) as TaxYearStartWork,
		isnull(TaxYearFinishWork,@TaxYearFinish) as TaxYearFinishWork
from	TFinancialPlanningStatePension fpsa
inner join TRefPensionForecast rpf on rpf.RefPensionForecastId = isnull(fpsa.RefPensionForecastId,2)
right join crm..TCRMContact crm on crm.CRMContactId = fpsa.CRMContactId
right join crm..TPerson p on p.personid = crm.personid
where	crm.CRMContactId in (@CRMContactid,@CRMContactid2)
GO
