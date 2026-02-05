SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditSplitBasic]
      @StampUser varchar (255),
      @SplitBasicId bigint,
      @StampAction char(1)
AS

INSERT INTO TSplitBasicAudit 
	(
	IndClientId,
	PractitionerId,
	PractitionerCRMContactId,
	BandingTemplateId,
	GroupingId,
	GroupCRMContactId,
	SplitPercent,
	PaymentEntityId,
	PractitionerFg,
	Extensible,
	ConcurrencyId,
	SplitBasicId,
	StampAction,
	StampDateTime,
	StampUser)
SELECT  
	IndClientId,
	PractitionerId,
	PractitionerCRMContactId,
	BandingTemplateId,
	GroupingId,
	GroupCRMContactId,
	SplitPercent,
	PaymentEntityId,
	PractitionerFg,
	Extensible,	
	ConcurrencyId,
	SplitBasicId,
	@StampAction, 
	GetDate(), 
	@StampUser
FROM TSplitBasic
WHERE SplitBasicId = @SplitBasicId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
