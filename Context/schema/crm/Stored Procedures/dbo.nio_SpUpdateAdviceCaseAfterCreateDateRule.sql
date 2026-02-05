SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SP @NumberOfDays and @ReopenNumberOfDays are the no of days set against their autoclose and reopen rules
CREATE PROCEDURE [dbo].[nio_SpUpdateAdviceCaseAfterCreateDateRule]    
 @NumberOfDays BIGINT, 
 @ReopenNumberOfDays BIGINT,       
 @CurrentAutoCloseStatusId BIGINT,
 @TenantId BIGINT,    
 @UserId BIGINT    
AS        
    
BEGIN    
    
DECLARE @InsertedRows TABLE (AdviceCaseHistoryId BIGINT, AdviceCaseId BIGINT,
 StatusId BIGINT, PractitionerId BIGINT, StatusDate DATETIME ); 
 
DECLARE  @minDate DATETIME ; 
SELECT @minDate = '1/1/1753'; 

-- INSERT INTO THE STATUS HISTORY TABLE    
INSERT INTO crm..TAdviceCaseHistory    
           (AdviceCaseId, ChangeType, StatusId, PractitionerId, ChangedByUserId, StatusDate, ConcurrencyId)    
 OUTPUT inserted.AdviceCaseHistoryId,    
   inserted.AdviceCaseId,    
   inserted.StatusId,    
   inserted.PractitionerId,    
   inserted.StatusDate    
 INTO @InsertedRows    
SELECT AdviceCase.AdviceCaseId    
  ,'Status'    
  ,@CurrentAutoCloseStatusId--AdviceCase.StatusId    
  ,AdviceCase.PractitionerId    
  ,@UserId    
  ,GETDATE()    
  ,1    
FROM crm..TAdviceCase AdviceCase    
INNER JOIN crm..TCRMContact Party    
 ON AdviceCase.CRMContactId = Party.CRMContactId    
INNER JOIN crm..TAdviceCaseStatus AdviceCaseStatus    
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId
WHERE Party.IndClientId = @TenantId    
 AND DATEADD(day,@NumberOfDays,AdviceCase.StartDate) <= GETDATE() 
 --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 AND DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReopenDate,@minDate))<=GETDATE()  
 AND AdviceCaseStatus.IsComplete != 1    
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId    
--    
--SELECT AdviceCaseId, 'Status', StatusId, PractitionerId, @UserId, StatusDate, 1, AdviceCaseHistoryId, 'C', GETDATE(),@UserId    
--FROM  @InsertedRows    
    
-- INSERT INTO THE STATUS HISTORY AUDIT TABLE    
INSERT INTO crm..TAdviceCaseHistoryAudit    
           (AdviceCaseId, ChangeType, StatusId, PractitionerId, ChangedByUserId, StatusDate, ConcurrencyId, AdviceCaseHistoryId    
   , StampAction, StampDateTime, StampUser)    
SELECT AdviceCaseId, 'Status', StatusId, PractitionerId, @UserId, StatusDate, 1, AdviceCaseHistoryId, 'C', GETDATE(),@UserId    
FROM  @InsertedRows    
    
    
-- INSERT INTO AdviceCaseAudit-------------------------------------------------------------------------------    
INSERT INTO TAdviceCaseAudit    
           (CRMContactId ,PractitionerId  
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
INNER JOIN TCRMContact Party    
 ON AdviceCase.CRMContactId = Party.CRMContactId    
INNER JOIN TAdviceCaseStatus AdviceCaseStatus    
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId 
WHERE Party.IndClientId = @TenantId    
 AND DATEADD(day,@NumberOfDays,AdviceCase.StartDate) <= GETDATE() 
 --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 AND DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReOpenDate,@minDate))<=GETDATE()    
 AND AdviceCaseStatus.IsComplete != 1    
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId    
    
    
-- UPDATE THE ADVICE CASE STATUS TO AUTOCLOSE------------------------------------------------------------------------------------    
UPDATE AdviceCase    
SET AdviceCase.StatusId = @CurrentAutoCloseStatusId,
AdviceCase.ReopenDate = null  
FROM TAdviceCase AdviceCase    
INNER JOIN TCRMContact Party    
 ON AdviceCase.CRMContactId = Party.CRMContactId    
INNER JOIN TAdviceCaseStatus AdviceCaseStatus    
 ON AdviceCase.StatusId = AdviceCaseStatus.AdviceCaseStatusId 
WHERE Party.IndClientId = @TenantId    
 AND DATEADD(day,@NumberOfDays,AdviceCase.StartDate) <= GETDATE()  
  --add reopen condition for overridiing autoclose rule
 --this will be false only when reopen date exists and its difference is less than current date  
 AND DATEADD(day,@ReopenNumberOfDays,IsNull(AdviceCase.ReOpenDate,@minDate))<=GETDATE()   
 AND AdviceCaseStatus.IsComplete != 1    
 AND AdviceCase.StatusId != @CurrentAutoCloseStatusId    
    
END    
    
/*    
exec nio_SpUpdateAdviceCaseAfterCreateDateRule 1,2890, 10155, 0    
    
*/    
GO
