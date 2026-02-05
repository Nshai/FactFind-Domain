SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrCategory_Custom_Update]         
	@AtrCategoryId	BIGINT,
	@Name			VARCHAR(255),      
	@IsArchived		BIT,  
	@ConcurrencyId	BIGINT,  
	@Id				UNIQUEIDENTIFIER       
AS      
  
DECLARE @StampUser varchar(255)    
SELECT  @StampUser = '999888777' 

SELECT @AtrCategoryId=AtrCategoryId FROM TAtrCategory WHERE [Guid]=@Id
        
BEGIN      
	 UPDATE TAtrCategory       
	 SET Name=@Name,IsArchived=@IsArchived        
	 WHERE [Guid]=@Id     
    
	 EXEC FactFind..SpNAuditAtrCategoryCombined  
		 @StampUser, @AtrCategoryId,'U'    
      
	 UPDATE TAtrCategoryCombined       
	 SET Name=@Name,IsArchived=@IsArchived        
	 WHERE [Guid]=@Id          
END
GO
