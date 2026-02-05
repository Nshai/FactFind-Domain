SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAssetClass_Custom_Delete]   
@Guid uniqueidentifier    
  
AS  
  
DECLARE @AtrAssetClassId bigint  

DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'  
  
SET @AtrAssetClassId=(SELECT AtrAssetClassId FROM TAtrAssetClassCombined WHERE Guid=@Guid)  
  
 DELETE FROM TAtrAssetClass   
 WHERE Guid=@Guid  

 EXEC FactFind..SpNAuditAtrAssetClassCombined @StampUser,@AtrAssetClassId,'D'
  
 DELETE FROM TAtrAssetClassCombined  
 WHERE Guid=@Guid  
GO
