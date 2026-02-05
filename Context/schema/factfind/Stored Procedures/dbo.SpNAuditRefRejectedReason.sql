SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditRefRejectedReason]
	@StampUser varchar (255),
	@RefRejectedReasonId bigint,
	@StampAction char(1)
AS

INSERT INTO 
	[TRefRejectedReasonAudit] 
	( [Description ]
	, RefRejectedReasonId
	, ConcurrencyId 
	, StampAction
	, StampDateTime
	, StampUser)
SELECT  
	[Description] 
	, RefRejectedReasonId
	, ConcurrencyId
	, @StampAction
	, GetDate()
	, @StampUser
FROM 
	TRefRejectedReason
WHERE 
	RefRejectedReasonId = @RefRejectedReasonId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
