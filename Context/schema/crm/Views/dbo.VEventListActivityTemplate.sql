SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VEventListActivityTemplate]

AS

SELECT
	ETA.EventListTemplateActivityId,
	ETA.EventListTemplateId,
    ETA.FixedDateFg,
    ETA.DeletableFg,
    ETA.Duration,
    ETA.ElapsedDays,
    ETA.EditElapsedDaysFg,
    ETA.AssignedUserId,
	ETA.ConcurrencyId,
	ETA.ActivityCategoryId,
	ETAP.CRMContactId AS AssignedUserCRMContactId,  
	ETAP.Identifier AS UserName,
	ETA.IsRecurring AS IsRecurring,
	ETA.RFCCode AS RFCCode
FROM
	CRM..TEventListTemplateActivity ETA
	LEFT JOIN Administration..TUser ETAP ON ETAP.UserId = ETA.AssignedUserId

GO
