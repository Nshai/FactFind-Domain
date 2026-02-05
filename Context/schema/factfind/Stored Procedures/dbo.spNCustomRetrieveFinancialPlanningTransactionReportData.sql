SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningTransactionReportData]       
 @FinancialPlanningId bigint      
as      

declare @DeclarationText nvarchar(max)  
      
Select @DeclarationText = IsNull(Declaration,'')
From 
	TFinancialPlanning fp
	Inner Join TFactFind ff on ff.FactFindId = fp.FactFindId
	Left Join TTransactionReportDeclaration rd on rd.tenantid = ff.IndigoClientId	
Where 
	fp.financialplanningid = @FinancialPlanningId

select         
  (        
    
  select   
  case when fp.GoalType = 4 then 1 else 0 end as '@noTarget',  
  case       
  when crm1.crmcontactid is not null then crm.FirstName + ' ' + crm.lastname + ' and ' +  crm1.FirstName + ' ' + crm1.lastname      
  else crm.FirstName + ' ' + crm.lastname end      
        
  as '@clientname',        
        
  right(        
  '00' + cast(datepart(dd,getDate()) as varchar),2) + '/' +         
  right(        
  '00' + cast(datepart(mm,getDate()) as varchar),2) + '/' +           
  cast(datepart(yyyy,getDate()) as varchar) as  '@datecreated',        
  Description as '@description',
  
  (Select @DeclarationText as '@text' For xml path ('declaration'), Type),

  (select        
   (        
    select  Objective as '@objective',         
      TargetAmount as '@target',         
          datediff(yyyy,(case when o.startdate < getdate() then getdate() else o.startdate end),targetdate) as '@term' ,     
      case when isnull(o.crmcontactid2,0) > 0 then 'Joint' else c1.Firstname + ' ' + c1.Lastname end as '@owner'  
    from TFinancialPlanningSelectedGoals  fp        
    inner join TObjective o on o.objectiveid = fp.objectiveid        
    inner join crm..TCRMContact c1 on c1.crmcontactid = o.CRMContactId            
    where financialplanningid = @FinancialPlanningId        
    For xml path ('goal'),Type        
   )        
  For xml path ('goals'),Type        
  )          
  For xml path ('transactionreport'),Type)         
from TFinancialPLanningSession fps        
inner join CRM..TCRMCOntact crm on crm.crmcontactid = fps.crmcontactid        
inner join TFactFind ff on ff.factfindid = fps.factfindid      
left join crm..TCRMContact crm1 on crm1.crmcontactid = ff.crmcontactid2    
inner join TFinancialPlanning fp on fp.financialplanningid = fps.financialplanningid  
where fp.financialplanningid = @FinancialPlanningId        
        
For XML Path ('root'),Type     
      
GO
