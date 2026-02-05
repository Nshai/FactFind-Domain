SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrQuestionsForAuthor]  
@CRMContactId bigint,  
@Type bit = 0 -- 0=client profile / investment, 1=retirement  
as  
  
 declare @ATRTemplateGuid uniqueidentifier  
 declare @TenantGuid uniqueidentifier  
 declare @AtrCategoryId bigint  
 declare @cid1 bigint, @cid2 bigint, @cid1Name varchar(255), @cid2Name varchar(255)  
 declare @TenantId bigint  
 declare @HasFreeTextAnswers bit  
  
--create temp table to hold questions/answers as we don't know if we need to use TATRInvestment or TATRRetirement  
 declare @ATRQuestions TABLE (  
  AtrId bigint PRIMARY KEY,   
  AtrQuestionGuid uniqueidentifier,  
  AtrAnswerGuid uniqueidentifier,  
  CRMContactId bigint,  
  FreeTextAnswer varchar(max)  
 )  
  
-- get the client's tenant   
 set @TenantId = (  
  select IndClientId   
  from CRM..TCRMContact   
  WHERE CRMContactId = @CRMContactId  
 )  
   
-- get the tenant guid  
 set @TenantGuid = (   
  select Guid   
  from Administration..TIndigoClient   
  WHERE IndigoClientId = @TenantId   
 )  
  
-- get the active ATRTemplate  
 select @AtrTemplateGuid =   
  case   
   when BaseATRTemplate is null then Guid   
   else BaseATRTemplate   
  end,  
  @HasFreeTextAnswers = HasFreeTextAnswers   
 from TAtrTemplate   
 WHERE IndigoClientId = @TenantId AND Active = 1  
  
-- get the ATRCategory based on the @Type, choose Default if not specified  
 IF @Type = 0   
  set @AtrCategoryId = ( select ATRCategoryId from TATRInvestmentCategory where CRMContactId = @cid1 )  
 else  
  set @AtrCategoryId = ( select ATRCategoryId from TATRRetirementCategory where CRMContactId = @cid1 )  
  
 IF @ATRCategoryId IS NULL  
  SET @ATRCategoryId = ( SELECT ATRCategoryId FROM TATRCategoryCombined WHERE Name = 'Default' AND TenantGuid = @TenantGuid )  
  
-- get the client details. Can't assume the the CRMContactId we pass in is client1 in the FF.  
 SELECT   
  @cid1 = CRMContactId1,   
  @cid2 = CRMContactId2,   
  @cid1Name = isnull(c1.FirstName,'') + isnull(' ' + c1.LastName,'') + isnull(c1.CorporateName,''),  
  @cid2Name = isnull(c2.FirstName,'') + isnull(' ' + c2.LastName,'') + isnull(c2.CorporateName,'')  
 FROM TFactFind f  
 LEFT JOIN CRM..TCRMContact c1 ON c1.CRMContactId = f.CRMContactId1  
 LEFT JOIN CRM..TCRMContact c2 on c2.CRMContactId = f.CRMContactId2  
 WHERE (CRMContactId1 = @CRMContactId OR CRMContactId2 = @CRMContactId)  
   
-- get the question sets for the @Type (investment/profile or retirement)  
 IF @Type = 0  
 BEGIN  
  INSERT INTO @ATRQuestions (AtrId, AtrQuestionGuid, AtrAnswerGuid, CRMContactId, FreeTextAnswer)  
  SELECT AtrInvestmentId, AtrQuestionGuid, AtrAnswerGuid, CRMContactId, FreeTextAnswer  
  FROM TATRInvestment  
  WHERE CRMContactId in (@cid1, @cid2)  
 END  
 ELSE  
 BEGIN  
  INSERT INTO @ATRQuestions (AtrId, AtrQuestionGuid, AtrAnswerGuid, CRMContactId, FreeTextAnswer)  
  SELECT AtrRetirementId, AtrQuestionGuid, AtrAnswerGuid, CRMContactId, FreeTextAnswer  
  FROM TATRRetirement  
  WHERE CRMContactId in (@cid1, @cid2)  
 END  
  
  
-- for Risk, or Investment  
 select   
 1 as tag,  
 NULL as parent,  
 ac.ATRCategoryId as [ATRCategory!1!AtrCategoryId],  
 ac.Name as [ATRCategory!1!Name],  
 --@cid1 as [ATRCategory!1!CRMContactId1],  
 --@cid1Name as [ATRCategory!1!Client1FullName],  
 --@cid2 as [ATRCategory!1!CRMContactId2],  
 --@cid2Name as [ATRCategory!1!Client2FullName],  
 @HasFreeTextAnswers as [ATRCategory!1!HasFreeTextAnswers],  
 @Type as [ATRCategory!1!Type],  
 null as [ATRQuestion!2!AtrQuestionId],  
 null as [ATRQuestion!2!QuestionText],  
 null as [ATRQuestion!2!Ordinal],  
 null as [ATRQuestion!2!Client1Answer],  
 null as [ATRQuestion!2!Client2Answer],  
 null as [ATRAnswer!3!AtrAnswerId],  
 null as [ATRAnswer!3!Ordinal],  
 null as [ATRAnswer!3!AtrQuestionId],  
 null as [ATRAnswer!3!AnswerText]  
 FROM TATRCategory ac  
 WHERE AtrCategoryId = @AtrCategoryId  
  
 UNION  
  
 select   
 2 as tag,  
 1 as parent,  
 ac.ATRCategoryId,  
 null,  
 --null,  
 --null,  
 --null,  
 --null,  
 null,  
 null,  
 aqc.AtrQuestionId,  
 aqc.Description,  
 aqc.Ordinal,  
 isnull(case when @HasFreeTextAnswers = 0 then aac1.Description else ai1.FreeTextAnswer end,''),  
 isnull(case when @HasFreeTextAnswers = 0 then aac2.Description else ai2.FreeTextAnswer end,''),  
 null,  
 null,  
 null,  
 null  
 FROM TATRCategory ac  
 JOIN TATRCategoryQuestion acq ON acq.AtrCategoryGuid = ac.Guid  
 JOIN TATRQuestionCombined aqc on aqc.Guid = acq.ATRQuestionGuid  
 LEFT JOIN @ATRQuestions ai1 on ai1.ATRQuestionGuid = aqc.Guid AND ai1.CRMContactId = @cid1  
 LEFT JOIN TATRAnswerCombined aac1 on aac1.Guid = ai1.ATRAnswerGuid  
 LEFT JOIN @ATRQuestions ai2 on ai2.ATRQuestionGuid = aqc.Guid AND ai2.CRMContactId = @cid2  
 LEFT JOIN TATRAnswerCombined aac2 on aac2.Guid = ai2.ATRAnswerGuid  
 WHERE AtrCategoryId = @AtrCategoryId  
 AND aqc.ATRTemplateGuid = @ATRTemplateGuid  
  
 UNION  
  
 select   
 3 as tag,  
 2 as parent,  
 ac.ATRCategoryId as [ATRCategory!1!AtrCategoryId],  
 null,  
 --null,  
 --null,  
 --null,  
 --null,  
 null,  
 null,  
 aqc.AtrQuestionId as [ATRQuestion!2!AtrQuestionId],  
 null,  
 null,  
 null,  
 null,  
 aac.AtrAnswerId,  
 aac.Ordinal,  
 aqc.ATRQuestionId,  
 aac.Description  
 FROM TATRCategory ac  
 JOIN TATRCategoryQuestion acq ON acq.AtrCategoryGuid = ac.Guid  
 JOIN TATRQuestionCombined aqc on aqc.Guid = acq.ATRQuestionGuid  
 JOIN TATRAnswerCombined aac on aac.AtrQuestionGuid = aqc.Guid  
 WHERE AtrCategoryId = @AtrCategoryId  
 AND aqc.ATRTemplateGuid = @ATRTemplateGuid  
 AND @HasFreeTextAnswers = 0  
  
  
 ORDER BY [ATRCategory!1!AtrCategoryId], [ATRQuestion!2!AtrQuestionId]  
  
  
 FOR XML EXPLICIT
GO
