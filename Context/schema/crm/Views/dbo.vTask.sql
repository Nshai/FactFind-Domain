SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VTask]
AS
SELECT     T1.TaskId, T1.StartDate, T1.DueDate, T1.Timezone, T1.OriginalDueDate, T1.PercentComplete, T1.Notes, T1.AssignedUserId, T1.PerformedUserId, T1.AssignedToUserId, T1.AssignedToRoleId, 
                      T1.ReminderId, T1.Subject, T1.RefPriorityId, T1.Other, T1.PrivateFg, T1.DateCompleted, T1.EstimatedTimeHrs, T1.EstimatedTimeMins, T1.ActualTimeHrs, 
                      T1.ActualTimeMins, T1.CRMContactId, T1.URL, T1.RefTaskStatusId, T1.ActivityOutcomeId, T1.IndigoClientId, T1.ReturnToRoleId, T1.ConcurrencyId, T1.SequentialRef, 
                      B.CRMContactId AS AssignedUserCRMContactId, C.CRMContactId AS PerformedUserCRMContactId, D.CRMContactId AS AssignedToUserCRMContactId, 
                      T1.ShowinDiary, T1.Guid, T1.IsAvailableToPFPClient, T1.EstimatedAmount, T1.ActualAmount, T1.IsBasedOnCompletionDate,
					  T1.BillingRatePerHour, T1.SpentTimeHrs, t1.SpentTimeMins
FROM         dbo.TTask AS T1 LEFT OUTER JOIN
                      administration.dbo.TUser AS B ON B.UserId = T1.AssignedUserId LEFT OUTER JOIN
                      administration.dbo.TUser AS C ON C.UserId = T1.PerformedUserId LEFT OUTER JOIN
                      administration.dbo.TUser AS D ON D.UserId = T1.AssignedToUserId

GO
