SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPractitioner]
                @StampUser varchar (255),
                @PractitionerId bigint,
                @StampAction char(1)
AS

INSERT INTO TPractitionerAudit 
( IndClientId, PersonId, CRMContactId, TnCCoachId, 
                                AuthorisedFG, PIARef, AuthorisedDate, ExperienceLevel, 
                                FSAReference, MultiTieFg, OffPanelFg, ManagerId, 
                                PractitionerTypeId, _ParentId, _ParentTable, _ParentDb, 
                                _OwnerId, ConcurrencyId, PictureName, 
                PractitionerId, StampAction, StampDateTime, StampUser,JoinDate,LeaveDate,NINumber,SecondaryRef,DeceasedDate,ServicingAdministratorId,ParaplannerUserId) 
Select IndClientId, PersonId, CRMContactId, TnCCoachId, 
                                AuthorisedFG, PIARef, AuthorisedDate, ExperienceLevel, 
                                FSAReference, MultiTieFg, OffPanelFg, ManagerId, 
                                PractitionerTypeId, _ParentId, _ParentTable, _ParentDb, 
                                _OwnerId, ConcurrencyId, PictureName, 
                PractitionerId, @StampAction, GetDate(), @StampUser,JoinDate,LeaveDate,NINumber,SecondaryRef, DeceasedDate,ServicingAdministratorId,ParaplannerUserId
FROM TPractitioner
WHERE PractitionerId = @PractitionerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
