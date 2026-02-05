SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefApplicationErrorMessageMapping]
	@StampUser varchar (255),
	@RefApplicationErrorMessageMappingId bigint,
	@StampAction char(1)
AS

INSERT 
	INTO TRefApplicationErrorMessageMappingAudit( 
	RefApplicationId,Code,ErrorMessage,CustomData, RefApplicationErrorMessageMappingId,
	ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT 
	RefApplicationId,Code,ErrorMessage,CustomData, RefApplicationErrorMessageMappingId, 
	ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM 
	TRefApplicationErrorMessageMapping
WHERE 
	RefApplicationErrorMessageMappingId = @RefApplicationErrorMessageMappingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO