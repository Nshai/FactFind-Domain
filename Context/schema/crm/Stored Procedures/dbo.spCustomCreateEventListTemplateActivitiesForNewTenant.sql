SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomCreateEventListTemplateActivitiesForNewTenant]
(
	@NewTenantId BIGINT
	,@SourceIndigoClientId BIGINT
)
AS

BEGIN

INSERT 	TEventListTemplateActivity	(		EventListTemplateId, 		ActivityCategoryId, 		FixedDateFg, 		DeletableFg, 		Duration, 		ElapsedDays, 		EditElapsedDaysFg, 		AssignedUserId, 		ConcurrencyId, 		IsRecurring, 		RFCCode	)OUTPUT 	inserted.EventListTemplateId, 	inserted.ActivityCategoryId, 	inserted.FixedDateFg, 	inserted.DeletableFg, 	inserted.Duration, 	inserted.ElapsedDays, 	inserted.EditElapsedDaysFg, 	inserted.AssignedUserId, 	inserted.ConcurrencyId, 	inserted.EventListTemplateActivityId, 	'C', 	getdate(), 	'0', 	inserted.IsRecurring, 	inserted.RFCCodeINTO 	TEventListTemplateActivityAudit	(		EventListTemplateId, 		ActivityCategoryId, 		FixedDateFg, 		DeletableFg, 		Duration, 		ElapsedDays, 		EditElapsedDaysFg, 		AssignedUserId, 		ConcurrencyId, 		EventListTemplateActivityId, 		StampAction, 		StampDateTime, 		StampUser, 		IsRecurring, 		RFCCode	)
SELECT 
	NewTenantELT.EventListTemplateId,
	NewTenantAC.ActivityCategoryId,
	SourceELTA.FixedDateFg,
	SourceELTA.DeletableFg,
	SourceELTA.Duration,
	SourceELTA.ElapsedDays,
	SourceELTA.EditElapsedDaysFg,
	SourceELTA.AssignedUserId,
	1,
	SourceELTA.IsRecurring,
	SourceELTA.RFCCode 
FROM 
	TEventListTemplateActivity SourceELTA 
	JOIN TEventListTemplate ETSrc ON ETSrc.EventListTemplateId = SourceELTA.EventListTemplateId
	JOIN TEventListTemplate NewTenantELT ON NewTenantELT.Name = ETSrc.Name 
		AND NewTenantELT.IndigoClientId = @NewTenantId
	JOIN TActivityCategory ACSrc ON ACSrc.ActivityCategoryId = SourceELTA.ActivityCategoryId
	JOIN TActivityCategory NewTenantAC ON NewTenantAC.Name = ACSrc.Name 
		AND NewTenantAC.IndigoClientId = @NewTenantId
		AND NewTenantAC.ActivityEvent = ACSrc.ActivityEvent
	LEFT JOIN TEventListTemplateActivity Destination ON Destination.EventListTemplateId = NewTenantELT.EventListTemplateId
		AND Destination.ActivityCategoryId = NewTenantAC.ActivityCategoryId
WHERE
	ETSrc.IndigoClientId = @SourceIndigoClientId
	AND Destination.EventListTemplateActivityId IS NULL

END

GO
