SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



Create PROCEDURE [dbo].[SpNAuditTAtrAssetClassToEvalueAssetClassMapping]  
 @StampUser varchar (255),  
 @AtrAssetClassToEvalueAssetClassMappingId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrAssetClassToEvalueAssetClassMappingAudit   
(RefEvalueAssetClassId,AtrRefAssetClassId,AtrAssetClassToEvalueAssetClassMappingId,ConcurrencyId,
	StampAction,StampDateTime,StampUser)   

Select RefEvalueAssetClassId,AtrRefAssetClassId,AtrAssetClassToEvalueAssetClassMappingId,ConcurrencyId,
		@StampAction, GetDate(), @StampUser  
FROM TAtrAssetClassToEvalueAssetClassMapping  
WHERE AtrAssetClassToEvalueAssetClassMappingId = @AtrAssetClassToEvalueAssetClassMappingId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  



GO
