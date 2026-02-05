SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrMatrixTerm]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrMatrixTermAudit   
( Identifier, Ordinal, Starting, Ending,   
  IndigoClientId, AtrTemplateGuid, Guid, ConcurrencyId,   
    
 AtrMatrixTermId, StampAction, StampDateTime, StampUser)   
Select Identifier, Ordinal, Starting, Ending,   
  IndigoClientId, AtrTemplateGuid, Guid, ConcurrencyId,   
    
 AtrMatrixTermId, @StampAction, GetDate(), @StampUser  
FROM TAtrMatrixTerm  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
