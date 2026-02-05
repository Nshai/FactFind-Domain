SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE [dbo].[SpNAuditRiskProfileCombined]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier, 
 @StampAction char(1)  
AS  
  
INSERT INTO TRiskProfileCombinedAudit   
( Descriptor, BriefDescription, IndigoClientId, IndigoClientGuid, RiskNumber,   
  LowerBand, UpperBand, AtrTemplateGuid, Guid,   
  ConcurrencyId,   
 RiskProfileId, StampAction, StampDateTime, StampUser)   
Select Descriptor, BriefDescription, IndigoClientId, IndigoClientGuid, RiskNumber,   
  LowerBand, UpperBand, AtrTemplateGuid, Guid,   
  ConcurrencyId,   
 RiskProfileId, @StampAction, GetDate(), @StampUser  
FROM TRiskProfileCombined  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  

GO