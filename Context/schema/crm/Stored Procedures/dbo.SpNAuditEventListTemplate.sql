SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditEventListTemplate]    
	@StampUser varchar (255),    
	@EventListTemplateId bigint,    
	@StampAction char(1)    
	AS    
  
	INSERT INTO TEventListTemplateAudit     
	(Name, AllowAddTaskFg, IndigoClientId, ClientRelatedFg,     
	PlanRelatedFg, LeadRelatedFg, AdviserRelatedFg, SchemeRelatedFg,     
	ConcurrencyId,     
	EventListTemplateId, StampAction, StampDateTime, StampUser,IsArchived,GroupId,ServiceCaseRelatedFg,IsPropagated)     
	SELECT Name, AllowAddTaskFg, IndigoClientId, ClientRelatedFg,     
	PlanRelatedFg, LeadRelatedFg, AdviserRelatedFg, SchemeRelatedFg,     
	ConcurrencyId,     
	EventListTemplateId, @StampAction, GetDate(), @StampUser,IsArchived,GroupId,ServiceCaseRelatedFg,IsPropagated    
	FROM TEventListTemplate    
	WHERE EventListTemplateId = @EventListTemplateId   
    
IF @@ERROR != 0 GOTO errh    
    
RETURN (0)    
    
errh:    
RETURN (100)    




GO
