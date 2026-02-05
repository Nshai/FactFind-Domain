SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveEValueUser] @CRMContactId bigint, @tenantid bigint     
      
as      
      
      
--company is switched based on environment and active template  
declare @company varchar(50),  
  @activeAtrTemplate varchar(50),  
  @tenantGuid uniqueidentifier  
  
  
select @company = 'Intelliflo'  
  
select @tenantGuid = guid from administration..TIndigoClient where indigoclientid = @tenantId  
  
--set the environment  
DECLARE @BoolIsLnGEnvironment BIT  
Exec Administration.dbo.SpCustomDoesTenantGroupExist 'NBS', @BoolIsLnGEnvironment OUTPUT  
  
--get the active template - only interested if it's based on a   
select @activeAtrTemplate = b.Identifier from TATRTemplateCombined a  
           inner join TATRTemplateCombined b on a.baseatrtemplate = b.guid  
           where a.indigoclientguid = @tenantGuid and a.active = 1  
  
  
  
-- set @company if true  
IF (@BoolIsLnGEnvironment = 1 and @activeAtrTemplate = 'NBS Five Profiles 13 Questions')  
      select @company = 'Intelliflo5Risk'          
      
select       
 case when p.DOB is null then null else        
  cast(datepart(yyyy,p.dob) as varchar)  +       
  left('0' + cast(datepart(m,p.dob) as varchar),2) +       
  left('0' + cast(datepart(d,p.dob) as varchar),2) end      
 as 'dateOfBirth',      
 case when GenderType = 'Male' then 'M' when GenderType = 'Female' then 'F' else null end as 'sex',      
 @company as 'company',      
 AnnualSalary      
 from crm..TPerson p      
 inner join crm..TCRMContact c on c.PersonId = p.PersonId       
 left join factfind..TFinancialPlanningStatePension m on m.crmcontactid = c.crmcontactid      
 where c.CRMContactId = @CRMContactId      
GO
