SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveDocStoreTypeByIndigoClientId]  
@IndigoClientId bigint  
AS  
BEGIN 
  SELECT distinct DocStoreType 
  FROM administration..TTenantDocumentStoreConfig 
  where TenantId = @IndigoClientId
END  
RETURN (0)  
  
GO
