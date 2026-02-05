SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vEventListActivity]
AS


SELECT
	T1.EventListActivityId,
	T1.EventListId,
	T1.EventListTemplateActivityId,
	T1.FixedDate,
	T1.Duration,
	T1.ElapsedDays,
	T1.EditElapsedDaysFg,
	T1.AssignedUserId,
	T1.AssignedRoleId,
	T1.StartDate,
	T1.DeletedFg,
	T1.CompletedFg,
	T1.ConcurrencyId,
	B.CRMContactId as AssignedUserCRMContactId
	FROM TEventListActivity T1
	LEFT JOIN Administration..TUser B on B.UserId=T1.AssignedUserId
	

GO
