SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviserReallocateStats]  
 @StampUser varchar (255),  
 @AdviserReallocateStatsId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAdviserReallocateStatsAudit   
( ClientCount, RelatedClientCount, TasksCount, OpportunitiesCount, ServiceCasesCount, NewAdviserPartyId,
  UserId, TenantId, ReallocateStatus, ReallocateErrorMessage, [Timestamp],  
  ConcurrencyId, AdviserReallocateStatsId, StampAction, StampDateTime, StampUser)   
Select  ClientCount, RelatedClientCount, TasksCount, OpportunitiesCount, ServiceCasesCount, NewAdviserPartyId,
  UserId, TenantId, ReallocateStatus, ReallocateErrorMessage, [Timestamp],   
  ConcurrencyId, AdviserReallocateStatsId, @StampAction, GetDate(), @StampUser  
FROM TAdviserReallocateStats  
WHERE AdviserReallocateStatsId = @AdviserReallocateStatsId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
  
GO
