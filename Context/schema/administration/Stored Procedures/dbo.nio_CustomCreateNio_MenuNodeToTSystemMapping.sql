SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[nio_CustomCreateNio_MenuNodeToTSystemMapping]  
 @nio_MenuNodeId bigint,  
 @SystemPath1 varchar(255)  
As  
  
Declare @SystemId1 bigint, @Message varchar(1000)  
  
Select @SystemId1 = SystemId   
From TSystem  
Where SystemPath = @SystemPath1  
  
If IsNull(@SystemId1, 0) = 0  
Begin  
 Select @Message = 'SystemPath (' + @SystemPath1 + ') not found'  
 Raiserror(@Message, 16, 1)  
 Return  
End  
  
Delete From nio_MenuNodeToTSystem Where nio_MenuNodeId = @nio_MenuNodeId  
  
Insert Into nio_MenuNodeToTSystem  
( nio_MenuNodeId, SystemId )  
Values(@nio_MenuNodeId, @SystemId1)  
GO
