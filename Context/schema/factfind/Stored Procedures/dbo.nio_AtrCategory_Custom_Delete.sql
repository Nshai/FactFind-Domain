SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrCategory_Custom_Delete]    
@Guid uniqueidentifier
    
AS    
  
declare @StampUser varchar(255)  
select @StampUser = '999888777'

DECLARE @AtrCategoryId bigint
  
SELECT @AtrCategoryId=AtrCategoryId FROM TAtrCategory WHERE Guid=@Guid  
      
BEGIN    
 DELETE FROM TAtrCategory WHERE Guid=@Guid    
  
 EXEC FactFind..SpnAuditAtrCategoryCombined @StampUser,@AtrCategoryId,'D'  
     
 DELETE FROM TAtrCategoryCombined WHERE Guid=@Guid     
    
END 

GO
