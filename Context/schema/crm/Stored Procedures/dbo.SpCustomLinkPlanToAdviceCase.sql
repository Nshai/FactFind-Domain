SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomLinkPlanToAdviceCase]  
 @AdviceCaseId bigint,  
 @PolicyBusinessId bigint,  
 @StampUser varchar (255)  
   
AS  
  
  
Declare @Result int,@AdviceCasePlanId bigint  
  
  
IF NOT EXISTS(SELECT AdviceCasePlanId FROM TAdviceCasePlan WHERE AdviceCaseId=@AdviceCaseId AND PolicyBusinessId=@PolicyBusinessId)  
BEGIN
 IF (@AdviceCaseId>0 AND @PolicyBusinessId>0)
 BEGIN
	 INSERT TAdviceCasePlan(AdviceCaseId,PolicyBusinessId,ConcurrencyId)  
	 SELECT @AdviceCaseId,@PolicyBusinessId,1  
	  
	 SELECT @AdviceCasePlanId=SCOPE_IDENTITY()  
	 IF @@ERROR != 0 GOTO errh  
	  
	 EXEC SpNAuditAdviceCasePlan @StampUser,@AdviceCasePlanId,'C'  
	 IF @@ERROR != 0 GOTO errh  
 END
  
END  
  
RETURN (0)  
  
errh:  
RETURN (100)
GO
