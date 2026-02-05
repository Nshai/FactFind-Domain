SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomAtrCalculateRiskProfile]      
 @AtrTemplateGuid uniqueidentifier, -- this will be the active template NOT the base    
 @CRMContactId bigint,       
 @ObjectiveTypeId bigint = 1 -- Investment or retirement      
AS      
    
DECLARE      
 @Score int  ,    
 @baseTemplate uniqueidentifier,    
 @TenantGuid uniqueidentifier  ,  
 @AtrCategoryId bigint  
    
select @baseTemplate = case when BaseAtrTemplate is null then Guid else BaseAtrTemplate end     
      from TATRTemplateCombined     
      where guid = @AtrTemplateGuid    
    
--select @TenantGuid = guid from administration..TIndigoClient a    
--       inner join crm..TCRMContact b on b.indclientid = a.indigoclientid    
    
--set the AtrCategoryId    
--if its null after checking the relevant Category table check the primary client for the factfind they are in  
IF @ObjectiveTypeId = 1 -- Investment      
begin  
 select @AtrCategoryId =  AtrCategoryId FROM TATRInvestmentCategory where CRMContactId = @CRMContactId  
   
 if(@AtrCategoryId is null)  
  select @AtrCategoryId =  AtrCategoryId   
        FROM TATRInvestmentCategory   
        where CRMContactId = (select max(CRMContactId1) from TFactFind where CRMContactId2 = @CRMContactId)  
   
end else begin  
 select @AtrCategoryId =  AtrCategoryId FROM TATRRetirementCategory where CRMContactId = @CRMContactId  
   
 if(@AtrCategoryId is null)  
  select @AtrCategoryId =  AtrCategoryId   
        FROM TATRRetirementCategory   
        where CRMContactId = (select max(CRMContactId1) from TFactFind where CRMContactId2 = @CRMContactId)  
end  
    
-- Get full list of questions for the active template      
DECLARE @Questions TABLE (AtrQuestionGuid uniqueidentifier, AtrTemplateGuid uniqueidentifier)      
-- Insert      
INSERT @Questions (AtrQuestionGuid, AtrTemplateGuid)      
SELECT [Guid], AtrTemplateGuid      
FROM TAtrQuestionCombined      
WHERE AtrTemplateGuid = @baseTemplate AND Active=1      
      
      
     
-- Investment?      
IF @ObjectiveTypeId = 1 -- Investment      
begin  
  
 SELECT DISTINCT  @Score = SUM(ISNULL(ac.Weighting, 0))      
 FROM  @Questions q       
 JOIN TATRCategoryQuestion cq on cq.AtrQuestionGuid = q.AtrQuestionGuid        
 JOIN TATRAnswerCategory ac on cq.AtrCategoryQuestionId=ac.AtrCategoryQuestionId      
 JOIN TAtrAnswerCombined aco on aco.[Guid] = ac.AtrAnswerGuid     
 JOIN TAtrInvestment I ON I.AtrAnswerGuid = aco.Guid    
 join TAtrCategoryCombined cc on cc.Guid = cq.AtrCategoryGuid     
 WHERE cq.AtrTemplateGuid = @AtrTemplateGuid AND I.CRMContactId = @CRMContactId and cc.AtrCategoryId = @AtrCategoryId       
end ELSE      
   
 SELECT DISTINCT  @Score = SUM(ISNULL(ac.Weighting, 0))      
 FROM  @Questions q       
 JOIN TATRCategoryQuestion cq on cq.AtrQuestionGuid = q.AtrQuestionGuid        
 JOIN TATRAnswerCategory ac on cq.AtrCategoryQuestionId=ac.AtrCategoryQuestionId      
 JOIN TAtrAnswerCombined aco on aco.[Guid] = ac.AtrAnswerGuid     
 JOIN TAtrRetirement I ON I.AtrAnswerGuid = aco.Guid         
 join TAtrCategoryCombined cc on cc.Guid = cq.AtrCategoryGuid    
 WHERE cq.AtrTemplateGuid = @AtrTemplateGuid AND I.CRMContactId = @CRMContactId and cc.AtrCategoryId = @AtrCategoryId       
     
      
SELECT      
 Guid,      
 RiskNumber,      
 Descriptor,      
 BriefDescription       
FROM      
 PolicyManagement..TRiskProfileCombined      
WHERE      
 AtrTemplateGuid = @baseTemplate      
 AND LowerBand <= @Score AND @Score <= UpperBand 
GO
