SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRiskProfile]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier, 
 @StampAction char(1)  
AS  
  
INSERT INTO TRiskProfileAudit   
( Descriptor, BriefDescription, IndigoClientId, RiskNumber,   
  LowerBand, UpperBand, AtrTemplateGuid, Guid,   
  ConcurrencyId,   
 RiskProfileId,RiskProfileSyncId, StampAction, StampDateTime, StampUser)   
Select Descriptor, BriefDescription, IndigoClientId, RiskNumber,   
  LowerBand, UpperBand, AtrTemplateGuid, Guid,   
  ConcurrencyId,   
 RiskProfileId,RiskProfileSyncId, @StampAction, GetDate(), @StampUser  
FROM TRiskProfile  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
