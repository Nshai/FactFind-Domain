CREATE PROCEDURE [dbo].[SpCustomRetrieveUserNameByIndigoClientId]  
@IndigoClientId BIGINT  
AS  
--**********************************************************************************  
--Date : 26-Apr-2012
--Author : KK  
--Return the unc-username for Indigoclientid
--**********************************************************************************  
SET NOCOUNT ON   
DECLARE @Username AS VARCHAR(255)
  
SELECT 
	@Username = SftpUserName  --'nbs01' 
FROM 
	TIndigoClientExtended 
WHERE 
	IndigoClientId = @IndigoClientId 

 SELECT Username = @Username  
  
SET NOCOUNT OFF  
  
RETURN (0)  