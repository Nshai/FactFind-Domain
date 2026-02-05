SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditGroupSecurity]   
@StampUser varchar (255),   
@GroupSecurityId bigint,   
@StampAction char(1)  
AS    
INSERT INTO TGroupSecurityAudit  
		(GroupSecurityId , GroupId, IsActivityCategoryPropagationAllowed, IsEventListPropagationAllowed, 
		IsFeeModelPropagationAllowed,TenantId, ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT [GroupSecurityId], [GroupId], [IsActivityCategoryPropagationAllowed], [IsEventListPropagationAllowed],
[IsFeeModelPropagationAllowed], [TenantId], [ConcurrencyId],@StampAction, GetDate(), @StampUser  
FROM TGroupSecurity  
WHERE GroupSecurityId = @GroupSecurityId    


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
