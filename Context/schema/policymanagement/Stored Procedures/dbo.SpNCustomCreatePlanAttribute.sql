SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlanAttribute]  
 @StampUser bigint,  
 @PolicyBusinessId bigint,   
 @AttributeList2AttributeId bigint,    
 @AttributeValue varchar(255)  = NULL   
AS  
  
  
DECLARE @PolicyBusinessAttributeId bigint, @Result int  
DECLARE @AttributeName varchar(255),@AttributeListType varchar(50),@AttributeId bigint  
SELECT @AttributeName=ISNULL(B.[Name],'') FROM TAttributeList2Attribute A JOIN TAttributeList B ON A.AttributeListId=B.AttributeListId WHERE A.AttributeList2AttributeId=@AttributeList2AttributeId  
SELECT @AttributeListType=B.[Type] FROM TAttributeList2Attribute A JOIN TAttributeList B ON A.AttributeListId=B.AttributeListId WHERE A.AttributeList2AttributeId=@AttributeList2AttributeId  
  
IF @AttributeListType='List'  
BEGIN  
 SELECT @AttributeId=AttributeId FROM TAttributeList2Attribute WHERE AttributeList2AttributeId=@AttributeList2AttributeId  
 SELECT @AttributeValue=[Value] FROM TAttribute WHERE AttributeId=@AttributeId  
END  
  
IF ISNULL(@AttributeValue,'')!='' and isnull(@AttributeValue,'') <> 'false' 
BEGIN   
 INSERT INTO TPolicyBusinessAttribute  
 (PolicyBusinessId, AttributeList2AttributeId, AttributeValue, ConcurrencyId)  
 VALUES(@PolicyBusinessId, @AttributeList2AttributeId, @AttributeValue, 1)  
   
 SELECT @PolicyBusinessAttributeId = SCOPE_IDENTITY(), @Result = @@ERROR  
 IF @Result != 0 GOTO errh  
   
   
 Execute @Result = dbo.SpNAuditPolicyBusinessAttribute @StampUser, @PolicyBusinessAttributeId, 'C'   
   
 IF @Result  != 0 GOTO errh  
   
END  
  
RETURN (0)  
  
errh:  
RETURN (100)

GO
