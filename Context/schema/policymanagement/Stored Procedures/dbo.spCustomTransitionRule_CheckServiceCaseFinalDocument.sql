SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
  
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckServiceCaseFinalDocument]  
  @PolicyBusinessId bigint,  
  @ResponseCode varchar(512) output  
AS  
  
BEGIN  
 --make sure the plan 
 --1. is linked to an service case (advice case ) 
 --2. has Binder associated
 --3. Binder has Final versio of document 
 IF(SELECT COUNT(ACP.advicecaseid) FROM CRM..TAdviceCasePlan ACP
INNER JOIN CRM..TAdviceCase AC ON AC.AdviceCaseID=ACP.AdviceCaseId
INNER JOIN DocumentManagement..TBinderDocument BD ON BD.BinderId=AC.BinderId
INNER JOIN DocumentManagement..TDocVersion DV ON DV.DocVersionID=BD.DocVersionID
WHERE PolicyBusinessId = @PolicyBusinessId AND DV.Status='Final') = 0  
 begin  
  SELECT @ResponseCode = 'BINDERFINALDOCUMENT'    
 end  
END  
  
  
  
  
  
  
GO
