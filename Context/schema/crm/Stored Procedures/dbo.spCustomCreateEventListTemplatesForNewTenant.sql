SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomCreateEventListTemplatesForNewTenant]
(
	@NewTenantId BIGINT
	,@SourceIndigoClientId BIGINT
)
AS

BEGIN

	INSERT 		TEventListTemplate		(			Name, 			AllowAddTaskFg, 			IndigoClientId, 			ClientRelatedFg, 			PlanRelatedFg, 			LeadRelatedFg, 			AdviserRelatedFg, 			SchemeRelatedFg, 			ConcurrencyId, 			IsArchived, 			GroupId, 			ServiceCaseRelatedFg, 			IsPropagated		)	OUTPUT 		inserted.Name, 		inserted.AllowAddTaskFg, 		inserted.IndigoClientId, 		inserted.ClientRelatedFg, 		inserted.PlanRelatedFg, 		inserted.LeadRelatedFg, 		inserted.AdviserRelatedFg, 		inserted.SchemeRelatedFg, 		inserted.ServiceCaseRelatedFg, 		inserted.ConcurrencyId, 		inserted.EventListTemplateId, 		'C', 		GETDATE(), 		'0', 		inserted.IsArchived, 		inserted.GroupId, 		inserted.IsPropagated	INTO 		TEventListTemplateAudit		(			Name, 			AllowAddTaskFg, 			IndigoClientId, 			ClientRelatedFg, 			PlanRelatedFg, 			LeadRelatedFg, 			AdviserRelatedFg, 			SchemeRelatedFg, 			ServiceCaseRelatedFg, 			ConcurrencyId, 			EventListTemplateId, 			StampAction, 			StampDateTime, 			StampUser, 			IsArchived, 			GroupId, 			IsPropagated		)	SELECT 		Src.Name,		Src.AllowAddTaskFg, 		@NewTenantId,		Src.ClientRelatedFg, 		Src.PlanRelatedFg, 		Src.LeadRelatedFg, 		Src.AdviserRelatedFg, 		Src.SchemeRelatedFg, 		Src.ConcurrencyId, 		Src.IsArchived, 		DestinationTenantGroup.GroupId,		Src.ServiceCaseRelatedFg, 		Src.IsPropagated	FROM 		TEventListTemplate Src		LEFT JOIN Administration..TGroup SourceTenantGroup ON SourceTenantGroup.GroupId = Src.GroupId		LEFT JOIN Administration..TGrouping SourceTenantGrouping ON SourceTenantGrouping.GroupingId = SourceTenantGroup.GroupingId		LEFT JOIN Administration..TGroup DestinationTenantGroup ON DestinationTenantGroup.Identifier = SourceTenantGroup.Identifier			AND DestinationTenantGroup.IndigoClientId = @NewTenantId		LEFT JOIN Administration..TGrouping DestinationTenantGrouping ON DestinationTenantGrouping.Identifier = SourceTenantGrouping.Identifier			AND DestinationTenantGrouping.IndigoClientId = @NewTenantId		LEFT JOIN TEventListTemplate Dest ON Dest.Name = Src.Name			AND Dest.AllowAddTaskFg = Src.AllowAddTaskFg			AND Dest.IndigoClientId = Src.IndigoClientId			AND Dest.ClientRelatedFg = Src.ClientRelatedFg 			AND Dest.PlanRelatedFg = Src.PlanRelatedFg			AND Dest.LeadRelatedFg = Src.LeadRelatedFg			AND Dest.AdviserRelatedFg = Src.AdviserRelatedFg			AND Dest.SchemeRelatedFg = Src.SchemeRelatedFg			AND Dest.ServiceCaseRelatedFg = Src.ServiceCaseRelatedFg			AND Dest.IsPropagated = Src.IsPropagated			AND Dest.IndigoClientId = @NewTenantId	WHERE		Src.IndigoClientId = @SourceIndigoClientId		AND Dest.EventListTemplateId IS NULL
END
GO
