SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpUpdateAdviceCaseAfterPlanSTPDateRule]      
 @NumberOfDays BIGINT,   
 @ReopenNumberOfDays BIGINT,       
 @CurrentAutoCloseStatusId BIGINT,      
 @TenantId BIGINT,      
 @UserId BIGINT      
AS          
      
BEGIN      
      
DECLARE @InsertedRows TABLE (AdviceCaseHistoryId BIGINT, AdviceCaseId BIGINT, StatusId BIGINT, PractitionerId BIGINT, StatusDate DATETIME )      
-- FILTER ALL THE REQUIRED LINKED ADVICE CASES AND STORE THEM IN A TEMP TABLE      
DECLARE @AdviceCases TABLE (AdviceCaseId BIGINT)      
DECLARE @StatusId BIGINT, @AdviceTypeId BIGINT      
SELECT @StatusId=StatusId FROM PolicyManagement.dbo.TStatus WHERE IntelligentOfficeStatusType = 'Submitted To Provider' AND IndigoClientId=@TenantId      
SELECT @AdviceTypeId = AdviceTypeId FROM PolicyManagement.dbo.TAdviceType WHERE IntelligentOfficeAdviceType = 'Pre-Existing' AND IndigoClientId=@TenantId      
      
INSERT INTO @AdviceCases      
SELECT           
    AdviceCasePlan.AdviceCaseId    
FROM TAdviceCase AdviceCase    
INNER JOIN TAdviceCasePlan AS AdviceCasePlan      
  ON AdviceCasePlan.AdviceCaseId = AdviceCase.AdviceCaseId    
INNER JOIN PolicyManagement..TPolicyBusiness AS PolicyBusiness    
  ON AdviceCasePlan.PolicyBusinessId = PolicyBusiness.PolicyBusinessId     
   AND PolicyBusiness.AdviceTypeId <> @AdviceTypeId    
LEFT JOIN PolicyManagement..TStatusHistory AS StatusHistory     
  ON PolicyBusiness.PolicyBusinessId = StatusHistory.PolicyBusinessId     
   AND StatusHistory.StatusId = @StatusId    
   AND DATEADD(day,@NumberOfDays,StatusHistory.DateOfChange) <= GETDATE()      
WHERE PolicyBusiness.IndigoClientId = @TenantId     
GROUP BY AdviceCasePlan.AdviceCaseId    
HAVING Min(IsNull(StatusHistory.StatusId,0)) > 0    
-- END OF TEMP TABLE, RE-USE THIS TABLE AGAIN AND AGAIN BELOW. 

DECLARE  @minDate DATETIME ; 
SELECT @minDate = '1/1/1753';

-- INSERT INTO THE STATUS HISTORY TABLE      
INSERT INTO TAdviceCaseHistory      
           (AdviceCaseId, ChangeType, StatusId, PractitionerId, ChangedByUserId, StatusDate, ConcurrencyId)      
 OUTPUT inserted.AdviceCaseHistoryId,      
   inserted.AdviceCaseId,      
   inserted.StatusId,      
   inserted.PractitionerId,      
   inserted.StatusDate      
 INTO @InsertedRows      
SELECT AdviceCase.AdviceCaseId      
  ,'Status'      
  ,@CurrentAutoCloseStatusId --AdviceCase.StatusId      
  ,AdviceCase.PractitionerId      
  ,@UserId      
  ,GETDATE()      
  ,1      
FROM TAdviceCase AdviceCase      
INNER JOIN @AdviceCases tempAdviceCase      
 ON tempAdviceCase.AdviceCaseId = AdviceCase.AdviceCaseId       
INNER JOIN TAdviceCaseStatus AdviceCaseStatus      
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId      
WHERE
 --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReopenDate,@minDate))<=GETDATE()         
 AND AdviceCaseStatus.IsComplete != 1      
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId      
      
-- INSERT INTO THE STATUS HISTORY AUDIT TABLE      
INSERT INTO TAdviceCaseHistoryAudit      
           (AdviceCaseId, ChangeType, StatusId, PractitionerId, ChangedByUserId, StatusDate, ConcurrencyId, AdviceCaseHistoryId      
   , StampAction, StampDateTime, StampUser)      
SELECT AdviceCaseId, 'Status', StatusId, PractitionerId, @UserId, StatusDate, 1, AdviceCaseHistoryId, 'C', GETDATE(),@UserId      
FROM  @InsertedRows      
      
      
-- INSERT INTO AdviceCaseAudit      
INSERT INTO TAdviceCaseAudit      
           (CRMContactId      
           ,PractitionerId      
           ,StatusId      
           ,StartDate      
           ,CaseName      
           ,CaseRef      
           ,BinderId      
           ,SequentialRef      
           ,ConcurrencyId      
           ,AdviceCaseId      
           ,StampAction      
           ,StampDateTime      
           ,StampUser)      
SELECT AdviceCase.CRMContactId      
           ,AdviceCase.PractitionerId      
           ,AdviceCase.StatusId      
           ,AdviceCase.StartDate      
           ,AdviceCase.CaseName      
           ,AdviceCase.CaseRef      
           ,AdviceCase.BinderId      
           ,AdviceCase.SequentialRef      
           ,AdviceCase.ConcurrencyId      
           ,AdviceCase.AdviceCaseId      
     ,'U'      
     ,GETDATE()      
     ,@UserId      
FROM TAdviceCase AdviceCase      
INNER JOIN @AdviceCases tempAdviceCase      
 ON tempAdviceCase.AdviceCaseId = AdviceCase.AdviceCaseId       
INNER JOIN TAdviceCaseStatus AdviceCaseStatus      
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId 
WHERE 
 --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReopenDate,@minDate))<=GETDATE()       
 AND AdviceCaseStatus.IsComplete != 1      
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId      
      
      
-- UPDATE THE ADVICE CASE WITH NEW VALUE      
UPDATE AdviceCase      
SET AdviceCase.StatusId = @CurrentAutoCloseStatusId, 
--re-set reopendate 
AdviceCase.ReopenDate = null   
FROM TAdviceCase AdviceCase      
INNER JOIN @AdviceCases tempAdviceCase      
 ON tempAdviceCase.AdviceCaseId = AdviceCase.AdviceCaseId       
INNER JOIN TAdviceCaseStatus AdviceCaseStatus      
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId     
WHERE     
 --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReopenDate,@minDate))<=GETDATE()   
 AND AdviceCaseStatus.IsComplete != 1      
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId      
      
END      
      
/*      
exec nio_SpUpdateAdviceCaseAfterPlanSTPDateRule 70,2895, 10155, 0      
      
*/ 

GO
