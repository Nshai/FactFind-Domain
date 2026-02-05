SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRefClientType]
	@StampUser varchar (255),
	@RefClientTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefClientTypeAudit 
( 
	 RefClientTypeId
	,Name
	,ClientTypeGroup
	,ConcurrencyId
	,StampAction
	,StampDateTime
	,StampUser
) 
Select 
	 RefClientTypeId
	,Name
	,ClientTypeGroup
	,ConcurrencyId
	,@StampAction
	,GetUtcDate()
	,@StampUser
FROM 
	TRefClientType
WHERE 
	RefClientTypeId = @RefClientTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
