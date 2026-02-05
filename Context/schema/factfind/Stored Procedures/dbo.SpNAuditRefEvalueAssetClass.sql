SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefEvalueAssetClass]  
 @StampUser varchar (255),  
 @RefEvalueAssetClassId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TRefEvalueAssetClassAudit   
(RefEvalueAssetClassId,Identifier,ConcurrencyId,
	StampAction,StampDateTime,StampUser)   

Select RefEvalueAssetClassId,Identifier,ConcurrencyId,
		@StampAction, GetDate(), @StampUser  
FROM TRefEvalueAssetClass  
WHERE RefEvalueAssetClassId = @RefEvalueAssetClassId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  

GO
