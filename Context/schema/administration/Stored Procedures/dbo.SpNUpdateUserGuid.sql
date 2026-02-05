SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNUpdateUserGuid]  
 @UserId Bigint,  
 @StampUser varchar (255)  
AS  
  
Declare @Result int  
Execute @Result = dbo.SpNAuditUser @StampUser, @UserId, 'U'  
  
IF @Result  != 0 GOTO errh  
  
UPDATE T1  
SET T1.Guid = [dbo].[NewCombGuid](),  
    T1.ConcurrencyId = T1.ConcurrencyId + 1  
FROM TUser T1  
WHERE T1.UserId = @UserId   
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  




  
GO
