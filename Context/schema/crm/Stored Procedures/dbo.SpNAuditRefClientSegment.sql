USE [crm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpNAuditRefClientSegment]
	@StampUser varchar (255),
	@RefClientSegmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefClientSegmentAudit 
( ClientSegmentName, IndigoClientId,IsArchived, RefClientSegmentId, StampAction, 
	StampDateTime, StampUser, GroupId, IsPropagated, ConcurrencyId) 
Select ClientSegmentName, IndigoClientId,IsArchived, RefClientSegmentId, @StampAction, 
	GetUtcDate(), @StampUser, GroupId, IsPropagated, ConcurrencyId
FROM TRefClientSegment
WHERE RefClientSegmentId = @RefClientSegmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


