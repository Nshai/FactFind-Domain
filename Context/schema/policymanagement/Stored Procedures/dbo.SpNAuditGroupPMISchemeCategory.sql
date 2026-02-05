CREATE PROCEDURE [dbo].[SpNAuditGroupPMISchemeCategory]  
 @StampUser varchar (255),  
 @GroupPMISchemeCategoryId int,  
 @StampAction char(1)  
AS  
  
INSERT INTO TGroupPMISchemeCategoryAudit   
( GroupSchemeCategoryId, RefUnderwritingId, MemberExcess, HospitalScale,   
  RefCancerCoverId, HasOutpatientDiagnosticTestsAndScans, HasOutpatientConsultationsAndTreatment, HasOutpatientPsychiatricTreatment,   
  HasDentalCover, DentalScale, HasTravelCover, HasPrivateGPCover, HasCoverLinkedToGroupLife,  
  IsOpticalBenefit, TenantId, ConcurrencyId,   
 GroupPMISchemeCategoryId, StampAction, StampDateTime, StampUser)   
Select GroupSchemeCategoryId, RefUnderwritingId, MemberExcess, HospitalScale,   
  RefCancerCoverId, HasOutpatientDiagnosticTestsAndScans, HasOutpatientConsultationsAndTreatment, HasOutpatientPsychiatricTreatment,   
  HasDentalCover, DentalScale, HasTravelCover, HasPrivateGPCover, HasCoverLinkedToGroupLife,  
  IsOpticalBenefit, TenantId, ConcurrencyId,   
 GroupPMISchemeCategoryId, @StampAction, GetDate(), @StampUser  
FROM TGroupPMISchemeCategory  
WHERE GroupPMISchemeCategoryId = @GroupPMISchemeCategoryId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  