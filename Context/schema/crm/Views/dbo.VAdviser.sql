SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VAdviser]
AS
SELECT     P.PractitionerId, P.IndClientId, P.PersonId, P.CRMContactId, P.TnCCoachId, P.AuthorisedFG, P.PIARef, P.AuthorisedDate, P.ExperienceLevel, P.FSAReference, 
                      P.MultiTieFg, P.OffPanelFg, P.ManagerId, P.PractitionerTypeId, P._ParentId, P._ParentTable, P._ParentDb, P._OwnerId, P.Extensible, P.ConcurrencyId, 
                      TU.CRMContactId AS TnCCoachCRMContactId, U.CRMContactId AS ManagerCRMContactId, P.PictureName, P.JoinDate, P.LeaveDate, P.NINumber, 
                      P.SecondaryRef, P.DeceasedDate, P.MigrationRef,P.ServicingAdministratorId,P.ParaplannerUserId, G.GroupId, G.Identifier as GroupName
FROM         dbo.TPractitioner AS P LEFT OUTER JOIN
                      compliance.dbo.TTnCCoach AS T ON T.TnCCoachId = P.TnCCoachId LEFT OUTER JOIN
                      administration.dbo.TUser AS TU ON TU.UserId = T.UserId LEFT OUTER JOIN
                      administration.dbo.TUser AS U ON U.UserId = P.ManagerId LEFT OUTER JOIN					 
                      crm.dbo.TCRMContact AS C ON C.CRMContactId = P.CRMContactId LEFT OUTER JOIN
                      administration.dbo.TUser AS AU ON C.CRMContactId = AU.CRMContactId LEFT OUTER JOIN
                      administration.dbo.TGroup AS G ON G.GroupId = AU.GroupId  

GO



