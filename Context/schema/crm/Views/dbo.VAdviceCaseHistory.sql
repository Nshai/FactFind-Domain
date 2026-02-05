SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAdviceCaseHistory]  
AS  
SELECT     T1.AdviceCaseHistoryId, T1.AdviceCaseId, T1.ChangeType, T1.StatusId AS AdviceCaseStatusId, T1.ChangedByUserId,   
                      TC.CRMContactId AS ChangedByUserCRMContactId, T1.PractitionerId, T4.CRMContactId AS AdviserCRMContactId, T1.StatusDate,   
                      T1.ConcurrencyId  
FROM         dbo.TAdviceCaseHistory AS T1 LEFT JOIN  
                      Administration.dbo.TUser AS TU ON T1.ChangedByUserId = TU.UserId LEFT JOIN  
                      dbo.TCRMContact AS TC ON TU.CRMContactId = TC.CRMContactId LEFT OUTER JOIN  
                      dbo.TPractitioner AS T3 ON T1.PractitionerId = T3.PractitionerId LEFT OUTER JOIN  
                      dbo.TCRMContact AS T4 ON T3.CRMContactId = T4.CRMContactId  
GO
