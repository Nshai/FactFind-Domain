SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomRetrieveSystemUserId]
	@IndigoClientId bigint
AS
--**********************************************************************************  
--Date : 18-10-2013
--Author : KK  
--Return the system userid for the tenant 
--**********************************************************************************  
SET NOCOUNT ON   

DECLARE @UserId AS BIGINT

select @UserId  = UserId from administration..tuser 
	where RefUserTypeId = 5 
	and IndigoClientId = @IndigoClientId

 SELECT UserId = coalesce(@UserId,0)
  
SET NOCOUNT OFF  
  
RETURN (0) 