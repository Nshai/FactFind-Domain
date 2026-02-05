SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateWrapperPolicyBusiness]  
 @StampUser varchar (255),  
 @ParentPolicyBusinessId bigint,   
 @PolicyBusinessId bigint   
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
   
 DECLARE @WrapperPolicyBusinessId bigint  
     
   
 INSERT INTO TWrapperPolicyBusiness (  
  ParentPolicyBusinessId,   
  PolicyBusinessId,   
  ConcurrencyId)  
    
 VALUES(  
  @ParentPolicyBusinessId,   
  @PolicyBusinessId,  
  1)  
  
 SELECT @WrapperPolicyBusinessId = ident_current('TWrapperPolicyBusiness') 
   
 INSERT INTO TWrapperPolicyBusinessAudit (  
  ParentPolicyBusinessId,   
  PolicyBusinessId,   
  ConcurrencyId,  
  WrapperPolicyBusinessId,  
  StampAction,  
     StampDateTime,  
     StampUser)  
 SELECT    
  ParentPolicyBusinessId,   
  PolicyBusinessId,   
  ConcurrencyId,  
  WrapperPolicyBusinessId,  
  'C',  
     GetDate(),  
     @StampUser  
 FROM TWrapperPolicyBusiness  
 WHERE WrapperPolicyBusinessId = @WrapperPolicyBusinessId  
 EXEC SpRetrieveWrapperPolicyBusinessById @WrapperPolicyBusinessId  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)
  
GO
