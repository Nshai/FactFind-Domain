SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCreateCRMContactKeyOnClientShareMerge]  
(
	 @StampUser		VARCHAR (255),  -- User who is doing this action
	 @EntityId		BIGINT,  -- the original client CRMContactId  
	 @NewEntityId	BIGINT,  -- new client CRMContactId, to whom the share is going to merge   
	 @UserId		BIGINT,  -- existing additional adviser id  
	 @ErrorMessage  VARCHAR(255) out   -- return if any erro
 )
AS  
BEGIN  
	SET NOCOUNT ON  

	DECLARE @CRMContactKeyId bigint      
   
	INSERT INTO TCRMContactKey ( EntityId, CreatorId, UserId, RoleId, RightMask, AdvancedMask, ConcurrencyId)      
	SELECT  @NewEntityId, CreatorId, UserId, RoleId, RightMask, AdvancedMask, 1 
	FROM TCRMContactKey WHERE EntityId = @EntityId AND UserId = @UserId
		
  	IF (@@ERROR != 0)
		BEGIN
			SET @ErrorMessage = 'Error while insert TCRMContactKey '
			ROLLBACK TRANSACTION
			RETURN
		END
		
	 SELECT @CRMContactKeyId = SCOPE_IDENTITY()  
	  
	 INSERT INTO TCRMContactKeyAudit (  
	  EntityId, CreatorId, UserId,   RoleId,   RightMask,   AdvancedMask,   
	  ConcurrencyId,  CRMContactKeyId,  StampAction,  StampDateTime,  StampUser)  
	 
	 SELECT  EntityId,   CreatorId,    UserId,   RoleId,   RightMask,   AdvancedMask,   
	  ConcurrencyId,  CRMContactKeyId,  'C',  GetDate(),  @StampUser  
	 FROM TCRMContactKey  
	 WHERE CRMContactKeyId = @CRMContactKeyId  
	 
 	IF (@@ERROR != 0)
		BEGIN
			SET @ErrorMessage = 'Error while insert TCRMContactKeyAudit  '
			ROLLBACK TRANSACTION
			RETURN
		END
  END
 
GO
