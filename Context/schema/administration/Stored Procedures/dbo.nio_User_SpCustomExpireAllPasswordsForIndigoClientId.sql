SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_User_SpCustomExpireAllPasswordsForIndigoClientId]
	(
		@TenantId Bigint
	)

as      
      
begin      
      
	SET NOCOUNT ON

	DECLARE @tx int
	SELECT @tx = @@TRANCOUNT
	IF @tx = 0 BEGIN TRANSACTION TX
	BEGIN
	
	 Update TUser  
	 Set ExpirePasswordOn = GETDATE() - 1  
	Where IndigoClientId = @TenantId  

		IF @@ERROR != 0 GOTO errh
	
	
		IF @tx = 0 COMMIT TRANSACTION TX
			SELECT 1
	END
	RETURN (0)

	errh:
	  IF @tx = 0 ROLLBACK TRANSACTION TX
	  RETURN (100)

end
GO
