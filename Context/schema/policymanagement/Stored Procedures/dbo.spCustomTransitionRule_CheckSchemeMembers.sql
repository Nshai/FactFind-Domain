SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckSchemeMembers]  
  @PolicyBusinessId bigint,  
  @ErrorMessage varchar(512) output  
AS  
  
BEGIN  
  
 DECLARE @GroupSchemeId BIGINT  
   , @NonDeletedPlanCount INT  
  
 SELECT @GroupSchemeId = GroupSchemeId FROM PolicyManagement.dbo.TGroupScheme
						 WHERE PolicyBusinessId = @PolicyBusinessId  
  
 -- If the plan is not a group scheme we can exit  
 IF @GroupSchemeId IS NULL RETURN(0)  
  
 IF EXISTS(SELECT 1 FROM PolicyManagement.dbo.TGroupSchemeMember WHERE GroupSchemeId = @GroupSchemeId
				 AND PolicyBusinessId IS NOT NULL 
				 AND ISNULL(IsLeaver,0)=0)  
 BEGIN  
  
  SELECT  
   @NonDeletedPlanCount = count(*)  
  FROM  
   PolicyManagement.dbo.TGroupSchemeMember GSM  
   JOIN PolicyManagement.dbo.TStatusHistory SH ON SH.PolicyBusinessId = GSM.PolicyBusinessId  
   JOIN PolicyManagement.dbo.TStatus S ON S.StatusId = SH.StatusId  
  WHERE  
   GSM.GroupSchemeId = @GroupSchemeId  
   AND  
   S.IntelligentOfficeStatusType != 'Deleted'  
  
  IF @NonDeletedPlanCount > 0  
   SELECT @ErrorMessage = 'SCHEMEMEMBERS'  
  
 END  
  
END  


GO
