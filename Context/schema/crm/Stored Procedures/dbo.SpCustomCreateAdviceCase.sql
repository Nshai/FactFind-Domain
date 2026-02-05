SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateAdviceCase]   
 @TenantId bigint , 
 @CRMContactId bigint ,     
 @CaseName varchar(255) ,    
 @CaseRef varchar(50) ,  
 @PractitionerId bigint ,  
 @AdviceCaseStatusId bigint ,    
 @StampUser varchar (255) ,  
 @BinderId bigint = NULL  
     
     
       
      
AS    
    
SET NOCOUNT ON    
    
DECLARE @tx int    
SELECT @tx = @@TRANCOUNT    
IF @tx = 0 BEGIN TRANSACTION TX    
    
BEGIN    
     
 DECLARE @AdviceCaseId bigint,@AdviceCaseHistoryId bigint    
     
 INSERT INTO TAdviceCase (    
  CRMContactId,     
  PractitionerId,     
  StatusId,     
  StartDate,     
  CaseName,   
  CaseRef,    
  BinderId,  
  ConcurrencyId)    
      
 VALUES(    
  @CRMContactId,     
  @PractitionerId,     
  @AdviceCaseStatusId,     
  getdate(),     
  @CaseName,   
  @CaseRef,    
  @BinderId,  
  1)    
    
 SELECT @AdviceCaseId = SCOPE_IDENTITY()    
    
 EXEC SpNAuditAdviceCase @StampUser,@AdviceCaseId,'C'    
    
 IF @@ERROR != 0 GOTO errh    
 --Add a Status history record    
 INSERT TAdviceCaseHistory(AdviceCaseId,ChangeType,StatusId,ChangedByUserId,StatusDate,ConcurrencyId)    
 SELECT @AdviceCaseId,'Status',@AdviceCaseStatusId,@StampUser,getdate(),1    
    
 SELECT @AdviceCaseHistoryId=SCOPE_IDENTITY()    
 IF @@ERROR != 0 GOTO errh    
    
 EXEC SpNAuditAdviceCaseHistory @StampUser,@AdviceCaseHistoryId,'C'    
    
     
    
IF @@ERROR != 0 GOTO errh    
IF @tx = 0 COMMIT TRANSACTION TX    
    
 SELECT 1 AS TAG,    
 NULL AS Parent,    
 @AdviceCaseId AS [AdviceCase!1!AdviceCaseId]    
     
 FOR XML EXPLICIT    
    
END    
RETURN (0)    
    
errh:    
  IF @tx = 0 ROLLBACK TRANSACTION TX    
  RETURN (100)    
GO
