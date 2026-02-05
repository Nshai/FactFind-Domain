SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAuthorFactFindData]              
@CRMContactId bigint

AS     

BEGIN    


-- is this a personal or corporate client?    
declare @IsPerson bit    
select @IsPerson = case when CRMContactType = 1 then 1 else 0 end from crm..TCRMContact where CRMContactId = @CRMContactId    

SELECT               
1 as tag,              
NULL as parent,              
ff.FactFindId as [FactFind!1!FactFindId],              
ff.CRMContactId1 as [FactFind!1!CRMContactId1],              
ff.CRMContactId2 as [FactFind!1!CRMContactId2],        
isnull(c1.FirstName,'') + isnull(' ' + c1.LastName,'') + isnull(c1.CorporateName,'') as [FactFind!1!Client1FullName],    
isnull(c2.FirstName,'') + isnull(' ' + c2.LastName,'') + isnull(c2.CorporateName,'') as [FactFind!1!Client2FullName],    
c1.ExternalReference as [FactFind!1!Client1Reference],            
c2.ExternalReference as [FactFind!1!Client2Reference], 
isnull(c1.FirstName,'') as [FactFind!1!Client1FirstName],          
isnull(c1.LastName,'') as [FactFind!1!Client1LastName],             
isnull(c2.FirstName,'') as [FactFind!1!Client2FirstName],          
isnull(c2.LastName,'') as [FactFind!1!Client2LastName],          
convert(varchar(20),aa.DateOfFirstInterview,103) as [FactFind!1!DateOfFirstInterview],            
convert(varchar(20),caa.DateOfFirstAppointment,103) as [FactFind!1!DateOfFirstAppointment],              
isnull(pgn.GoalsAndNeeds,'') as [FactFind!1!ProtectionGoalsNeeds],              
isnull(rgn.GoalsAndNeeds,'') as [FactFind!1!RetirementGoalsNeeds],              
isnull(sgn.GoalsAndNeeds,'') as [FactFind!1!SavingsGoalsNeeds],              
isnull(egn.GoalsAndNeeds,'') as [FactFind!1!EstateGoalsNeeds],           
isnull(pn.Notes,'') as [FactFind!1!ProfileNotes],            
isnull(en.Note,'') as [FactFind!1!EmploymentNotes],            
isnull(bm.BudgetNotes,'') as [FactFind!1!BudgetNotes],            
isnull(pm.Notes,'') as [FactFind!1!ProtectionNotes],            
isnull(bm.AssetLiabilityNotes,'') as [FactFind!1!AssetLiabilityNotes],            
isnull(dn.declarationnotes,'') as [FactFind!1!DeclarationNotes],            
isnull(dn2.declarationnotes,'') as [FactFind!1!DeclarationNotesClient2],       
isnull(mm.Notes,'') as [FactFind!1!MortgageNotes],         
isnull(rns.NextSteps, '') as [FactFind!1!RetirementNextSteps],        
isnull(ens.NextSteps, '') as [FactFind!1!EstatePlanningNextSteps],        
isnull(sns.NextSteps, '') as [FactFind!1!InvestmentNextSteps],         
isnull(ecp.EstimatedLiabilities, '') as [FactFind!1!EstimatedLiabilities],         
isnull(ecp2.EstimatedLiabilities, '') as [FactFind!1!EstimatedLiabilitiesClient2],       
isnull(ecp.EstimatedLiabilitiesJoint, '') as [FactFind!1!EstimatedLiabilitiesJoint],       
isnull(ed.EmploymentStatus, '') as [FactFind!1!EmploymentStatus],    
isnull(ed2.EmploymentStatus, '') as [FactFind!1!EmploymentStatusClient2],    
case   
 when ed.EmploymentStatus in ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness', 'Self-Employed')   
 then ed.Role   
 else ''   
end as [FactFind!1!Role],    
case   
 when ed2.EmploymentStatus in ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness', 'Self-Employed')   
 then ed2.Role   
 else ''   
end as [FactFind!1!RoleClient2],    
case   
 when ed.EmploymentStatus in ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness')   
 then ed.Employer  
 else ''   
end as [FactFind!1!Employer],    
case   
 when ed2.EmploymentStatus in ('Employed', 'Company Director', 'Semi-Retired', 'Maternity Leave', 'Long Term Illness')   
 then ed2.Employer  
 else ''   
end as [FactFind!1!EmployerClient2],    

ISNULL(lcc.ImpactOnYou,'') as [FactFind!1!LifeCoverCicImpactOnYou],
ISNULL(lcc.ImpactOnDependants,'') as [FactFind!1!LifeCoverCicImpactOnDependants],
ISNULL(lcc.HowToAddress,'') as [FactFind!1!LifeCoverCicHowToAddress],
ISNULL(lcc.NotReviewingReason,'') as [FactFind!1!LifeCoverCicNotReviewingReason],

ISNULL(ip.ImpactOnYou,'') as [FactFind!1!IncomeProtectionImpactOnYou],
ISNULL(ip.ImpactOnDependants,'') as [FactFind!1!IncomeProtectionImpactOnDependants],
ISNULL(ip.HowToAddress,'') as [FactFind!1!IncomeProtectionHowToAddress],
ISNULL(ip.NotReviewingReason,'') as [FactFind!1!IncomeProtectionNotReviewingReason],

ISNULL(bcp.HowToAddress,'') as [FactFind!1!BuildingContentsProtectionHowToAddress],
ISNULL(bcp.WhenToReview,'') as [FactFind!1!BuildingContentsProtectionWhenToReview],
ISNULL(bcp.NotReviewingReason,'') as [FactFind!1!BuildingContentsProtectionNotReviewingReason],
  
null as [FactFindQuestionCategory!2!Ordinal],          
null as [FactFindQuestionCategory!2!CategoryId],          
null as [FactFindQuestionCategory!2!CategoryName],          
    
null as [FactFindQuestion!3!Ordinal],          
null as [FactFindQuestion!3!QuestionId],          
null as [FactFindQuestion!3!QuestionText],      
null as [FactFindQuestion!3!IsTextArea],     
null as [FactFindQuestion!3!AnswerClient1],      
null as [FactFindQuestion!3!AnswerClient2],            
null as [FactFindQuestion!3!FreeTextAnswerClient1],      
null as [FactFindQuestion!3!FreeTextAnswerClient2],    
     
null as [FactFindQuestionAnswer!4!Ordinal],     
null as [FactFindQuestionAnswer!4!QuestionId],     
null as [FactFindQuestionAnswer!4!AnswerId],          
null as [FactFindQuestionAnswer!4!AnswerText]    
    
              
FROM TFactFind ff WITH(NOLOCK)              
JOIN CRM..TCRMContact c1 ON c1.CRMContactId = ff.CRMContactId1              
LEFT JOIN CRM..TCRMContact c2 ON c2.CRMContactId = ff.CRMContactId2              
LEFT JOIN TAdviceAreas aa WITH(NOLOCK) ON aa.CRMContactId = ff.CRMContactId1              
LEFT JOIN TProtectionGoalsNeeds pgn WITH(NOLOCK) ON pgn.CRMContactId = ff.CRMContactId1              
LEFT JOIN tRetirementGoalsNeeds rgn WITH(NOLOCK) ON rgn.CRMContactId = ff.CRMContactId1              
LEFT JOIN tSavingsGoalsNeeds sgn WITH(NOLOCK) ON sgn.CRMContactId = ff.CRMContactId1              
LEFT JOIN tEstateGoalsNeeds egn WITH(NOLOCK) ON egn.CRMContactId = ff.CRMContactId1              
LEFT JOIN TCorporateAdviceAreas caa WITH(NOLOCK) ON caa.CRMContactId = ff.CRMContactId1            
LEFT JOIN TProfileNotes pn WITH (NOLOCK) ON pn.CRMContactId = ff.CRMContactId1            
LEFT JOIN TEmploymentNote en WITH (NOLOCK) ON en.CRMContactId = ff.CRMContactId1            
LEFT JOIN TBudgetMiscellaneous bm WITH (NOLOCK) ON bm.CRMContactId = ff.CRMContactId1            
LEFT JOIN TProtectionMiscellaneous pm WITH (NOLOCK) ON pm.CRMContactId = ff.CRMContactId1            
LEFT JOIN TDeclarationNotes dn WITH (NOLOCK) ON dn.CRMContactId = ff.CRMContactId1            
LEFT JOIN TDeclarationNotes dn2 WITH (NOLOCK) ON dn2.CRMContactId = ff.CRMContactId2      
LEFT JOIN TMortgageMiscellaneous mm WITH (NOLOCK) ON mm.CRMContactId = ff.CRMContactId1          
LEFT JOIN TRetirementNextSteps  rns WITH (NOLOCK) ON rns.CRMCOntactId = ff.CRMContactId1        
LEFT JOIN TEstateNextSteps  ens WITH (NOLOCK) ON ens.CRMCOntactId = ff.CRMContactId1        
LEFT JOIN TSavingsNextSteps  sns WITH (NOLOCK) ON sns.CRMCOntactId = ff.CRMContactId1        
LEFT JOIN TEstateCurrentPosition ecp WITH (NOLOCK) ON ecp.CRMCOntactId = ff.CRMContactId1        
LEFT JOIN TEstateCurrentPosition ecp2 WITH (NOLOCK) ON ecp2.CRMCOntactId = ff.CRMContactId2      
LEFT JOIN (    
 SELECT CRMContactId, MAX(EmploymentDetailId) as EmploymentDetailId     
 FROM TEmploymentDetail ed    
 JOIN TFactFind ff on ff.CRMContactId1 = ed.CRMContactId    
 WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)     
 GROUP BY CRMContactId    
 ) maxEd1 on maxEd1.CRMContactId = ff.CRMContactId1    
LEFT JOIN TEmploymentDetail ed WITH (NOLOCK) ON ed.EmploymentDetailId = maxEd1.EmploymentDetailId    
LEFT JOIN (    
 SELECT CRMContactId, MAX(EmploymentDetailId) as EmploymentDetailId     
 FROM TEmploymentDetail ed    
 JOIN TFactFind ff on ff.CRMContactId2 = ed.CRMContactId    
 WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)     
 GROUP BY CRMContactId    
 ) maxEd2 on maxEd2.CRMContactId = ff.CRMContactId2    
LEFT JOIN TEmploymentDetail ed2 WITH (NOLOCK) ON ed2.EmploymentDetailId = maxEd2.EmploymentDetailId 

LEFT JOIN TLifeCoverAndCic lcc ON  lcc.CRMContactId = ff.CRMContactId1
LEFT JOIN TIncomeProtection ip ON ip.CRMContactId = ff.CRMContactId1
LEFT JOIN TBuildingAndContentsProtection bcp ON bcp.CRMContactId = ff.CRMContactId1
   
WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)      
             
UNION          
          
SELECT DISTINCT          
2 as tag,          
1 as parent,          
ff.FactFindId as [FactFind!1!FactFindId],              
ff.CRMContactId1 as [FactFind!1!CRMContactId1], 
null, null, null, null, null, null, null, null, null, null, null,           
null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,null, null, null, null,    
case when @IsPerson = 1 then ffqcp.Ordinal else ffqcc.Ordinal end,          
case when @IsPerson = 1 then ffqcp.RefNeedsAndPrioritiesCategoryId else ffqcc.RefNeedsAndPrioritiesCategoryId end,          
case when @IsPerson = 1 then ffqcp.CategoryName else ffqcc.CategoryName end,        
null, null, null, null, null, null, null, null, null, null, null, null        
FROM TFactFind ff WITH(NOLOCK)              
JOIN CRM..TCRMContact c1 ON c1.CRMContactId = ff.CRMContactId1             
JOIN administration..TNeedsAndPrioritiesQuestion ffq on ffq.TenantId = c1.IndClientId and ffq.IsArchived = 0 and ( (@IsPerson = 1 and ffq.RefPersonalCategoryId is not null) or ( @IsPerson = 0 and ffq.RefCorporateCategoryId is not null) )    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcp on ffqcp.RefNeedsAndPrioritiesCategoryId = ffq.RefPersonalCategoryId    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcc on ffqcc.RefNeedsAndPrioritiesCategoryId = ffq.RefCorporateCategoryId    
WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)           
          
UNION          
          
SELECT          
3 as tag,          
2 as parent,          
ff.FactFindId as [FactFind!1!FactFindId],              
ff.CRMContactId1 as [FactFind!1!CRMContactId1],           
null, null, null, null, null, null, null, null, null, null, null, 
null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,null, null, null, null,    
case when @IsPerson = 1 then ffqcp.Ordinal else ffqcc.Ordinal end,          
case when @IsPerson = 1 then ffqcp.RefNeedsAndPrioritiesCategoryId else ffqcc.RefNeedsAndPrioritiesCategoryId end,          
case when @IsPerson = 1 then ffqcp.CategoryName else ffqcc.CategoryName end,         
ffq.Ordinal, ffq.NeedsAndPrioritiesQuestionId, ffq.Question, ffq.IsTextArea,     
isnull(napa.AnswerId, ''),    
isnull(napa2.AnswerId, ''),    
case when napa.FreeTextAnswer is not null and ffq.IsTextArea = 1 then napa.FreeTextAnswer else '' end,     
case when napa2.FreeTextAnswer is not null and ffq.IsTextArea = 1 then napa2.FreeTextAnswer else '' end,    
null, null, null, null         
FROM TFactFind ff WITH(NOLOCK)              
JOIN CRM..TCRMContact c1 ON c1.CRMContactId = ff.CRMContactId1             
JOIN administration..TNeedsAndPrioritiesQuestion ffq on ffq.TenantId = c1.IndClientId and ffq.IsArchived = 0 and ( (@IsPerson = 1 and ffq.RefPersonalCategoryId is not null) or ( @IsPerson = 0 and ffq.RefCorporateCategoryId is not null) )    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcp on ffqcp.RefNeedsAndPrioritiesCategoryId = ffq.RefPersonalCategoryId    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcc on ffqcc.RefNeedsAndPrioritiesCategoryId = ffq.RefCorporateCategoryId    
--added    
LEFT JOIN administration..TNeedsAndPrioritiesQuestionAnswer ffqa on ffqa.NeedsAndPrioritiesQuestionId = ffq.NeedsAndPrioritiesQuestionId  and ffqa.IsArchived = 0         
LEFT JOIN TNeedsAndPrioritiesAnswer napa on napa.CRMContactId = ff.CRMContactId1 AND napa.QuestionId = ffq.NeedsAndPrioritiesQuestionId --AND napa.AnswerId = ffqa.NeedsAndPrioritiesQuestionAnswerId          
LEFT JOIN TNeedsAndPrioritiesAnswer napa2 on napa2.CRMContactId = ff.CRMContactId2 AND napa2.QuestionId = ffq.NeedsAndPrioritiesQuestionId --AND napa2.AnswerId = ffqa.NeedsAndPrioritiesQuestionAnswerId          
        
WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)         
          
UNION          
          
SELECT           
4 as tag,          
3 as parent,          
ff.FactFindId as [FactFind!1!FactFindId],              
ff.CRMContactId1 as [FactFind!1!CRMContactId1], 
null, null, null, null, null, null, null, null, null, null, null,           
null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,null, null, null, null,     
case when @IsPerson = 1 then ffqcp.Ordinal else ffqcc.Ordinal end,          
case when @IsPerson = 1 then ffqcp.RefNeedsAndPrioritiesCategoryId else ffqcc.RefNeedsAndPrioritiesCategoryId end,          
case when @IsPerson = 1 then ffqcp.CategoryName else ffqcc.CategoryName end,     
ffq.Ordinal, ffq.NeedsAndPrioritiesQuestionId, ffq.Question, ffq.IsTextArea, null, null, null, null,          
ffqa.Ordinal, ffqa.NeedsAndPrioritiesQuestionId, ffqa.NeedsAndPrioritiesQuestionAnswerId, ffqa.Answer           
FROM TFactFind ff WITH(NOLOCK)              
JOIN CRM..TCRMContact c1 ON c1.CRMContactId = ff.CRMContactId1             
JOIN administration..TNeedsAndPrioritiesQuestion ffq on ffq.TenantId = c1.IndClientId and ffq.IsArchived = 0 and ( (@IsPerson = 1 and ffq.RefPersonalCategoryId is not null) or ( @IsPerson = 0 and ffq.RefCorporateCategoryId is not null) )    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcp on ffqcp.RefNeedsAndPrioritiesCategoryId = ffq.RefPersonalCategoryId    
LEFT JOIN administration..TRefNeedsAndPrioritiesCategory ffqcc on ffqcc.RefNeedsAndPrioritiesCategoryId = ffq.RefCorporateCategoryId    
JOIN administration..TNeedsAndPrioritiesQuestionAnswer ffqa on ffqa.NeedsAndPrioritiesQuestionId = ffq.NeedsAndPrioritiesQuestionId  and ffqa.IsArchived = 0         
WHERE (ff.CRMContactId1 = @CRMContactId or ff.CRMContactId2 = @CRMContactId)         
          
          
--ORDER BY [FactFind!1!FactFindId], [FactFindQuestionCategory!2!Ordinal], [FactFindQuestion!3!Ordinal], [FactFindQuestionAnswer!4!Ordinal]          
ORDER BY [FactFind!1!FactFindId], [FactFindQuestionCategory!2!CategoryId], [FactFindQuestion!3!QuestionId], [FactFindQuestionAnswer!4!AnswerId]          
    
FOR XML EXPLICIT                   

END    
      
        
      
GO