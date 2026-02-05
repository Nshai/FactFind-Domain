SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[SpCustomConfigureAdviceCaseStatusChanges] @IndigoClientId bigint  
  
AS  
  
--Insert the Default Statuses(Draft, In Process, Complete)  
INSERT TAdviceCaseStatus(TenantId,Descriptor,IsDefault,IsComplete,ConcurrencyId)  
SELECT @IndigoClientId,'Draft',1,0,1  
  

INSERT TAdviceCaseStatus(TenantId,Descriptor,IsDefault,IsComplete,ConcurrencyId)  
SELECT @IndigoClientId,'In Process',0,0,1  
  
INSERT TAdviceCaseStatus(TenantId,Descriptor,IsDefault,IsComplete,ConcurrencyId)  
SELECT @IndigoClientId,'Complete',0,1,1  
  
DECLARE @STATUS_DRAFT bigint,@STATUS_INPROCESS bigint,@STATUS_COMPLETE bigint  
  
SET @STATUS_DRAFT=(SELECT AdviceCaseStatusId FROM TAdviceCaseStatus WHERE TenantId=@IndigoClientId AND IsDefault=1 AND IsComplete=0)  
SET @STATUS_INPROCESS=(SELECT AdviceCaseStatusId FROM TAdviceCaseStatus WHERE TenantId=@IndigoClientId AND IsDefault=0 AND IsComplete=0)  
SET @STATUS_COMPLETE=(SELECT AdviceCaseStatusId FROM TAdviceCaseStatus WHERE TenantId=@IndigoClientId AND IsDefault=0 AND IsComplete=1)  
  
IF (ISNULL(@STATUS_DRAFT,0)!=0 AND ISNULL(@STATUS_INPROCESS,0)!=0 AND ISNULL(@STATUS_COMPLETE,0)!=0)  
  
BEGIN  
  
--Audit  
EXEC SpNAuditAdviceCaseStatus '999999998',@STATUS_DRAFT,'C'  
EXEC SpNAuditAdviceCaseStatus '999999998',@STATUS_INPROCESS,'C'  
EXEC SpNAuditAdviceCaseStatus '999999998',@STATUS_COMPLETE,'C'  
  
--Draft to In Process  
INSERT TAdviceCaseStatusChange(IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId)  
SELECT @IndigoClientId bigint,@STATUS_DRAFT,@STATUS_INPROCESS,1  
  
--In Process to Complete  
INSERT TAdviceCaseStatusChange(IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId)  
SELECT @IndigoClientId bigint,@STATUS_INPROCESS,@STATUS_COMPLETE,1  
  
--Complete to In Process  
INSERT TAdviceCaseStatusChange(IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId)  
SELECT @IndigoClientId bigint,@STATUS_COMPLETE,@STATUS_INPROCESS,1  
  
--In Process to Draft  
INSERT TAdviceCaseStatusChange(IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId)  
SELECT @IndigoClientId bigint,@STATUS_INPROCESS,@STATUS_DRAFT,1  
  
--Audit  
INSERT TAdviceCaseStatusChangeAudit(IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId,AdviceCaseStatusChangeId,  
              StampAction,StampDateTime,StampUser)  
  
SELECT IndigoClientId,AdviceCaseStatusIdFrom,AdviceCaseStatusIdTo,ConcurrencyId,AdviceCaseStatusChangeId,'C',getdate(),'999999998'  
FROM TAdviceCaseStatusChange  
WHERE IndigoClientId=@IndigoClientId  
  
  
declare @MaxId bigint

set @MaxId = (select max(AdviceCaseStatusChangeRoleId) FROM TAdviceCaseStatusChangeRole)

--Configure all roles   
INSERT TAdviceCaseStatusChangeRole(AdviceCaseStatusChangeId,RoleId,ConcurrencyId)  
SELECT B.AdviceCaseStatusChangeId,A.RoleId,1  
FROM Administration..TRole A  
JOIN TAdviceCaseStatusChange B ON A.IndigoClientId=B.IndigoClientId  
WHERE A.IndigoClientId=@IndigoClientId  
AND B.IndigoClientId=@IndigoClientId  
  
--Audit  
INSERT TAdviceCaseStatusChangeRoleAudit(AdviceCaseStatusChangeId,RoleId,ConcurrencyId,AdviceCaseStatusChangeRoleId,  
                  StampAction,StampDateTime,StampUser)  
  
SELECT AdviceCaseStatusChangeId,RoleId,ConcurrencyId,AdviceCaseStatusChangeRoleId,'C',getdate(),'999999999'  
FROM TAdviceCaseStatusChangeRole  
WHERE AdviceCaseStatusChangeRoleId > @MaxId 
  
END  
GO
