SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditInsuredItem]
	@StampUser varchar (255),
	@InsuredItemId bigint,
	@StampAction char(1)
AS

INSERT INTO 
	TInsuredItemAudit
	(
	QuoteId, 
	RefInsuredItemTypeId, 
	[Description], 
	RefHomeContentCoverCategoryId, 
	Value, 
	ConcurrencyId, 
	InsuredItemId, 
	StampAction, 
	StampDateTime, 
	StampUser
	)
SELECT  
	QuoteId, 
	RefInsuredItemTypeId, 
	[Description], 
	RefHomeContentCoverCategoryId, 
	Value, 
	ConcurrencyId,
	InsuredItemId, 
	@StampAction, 
	GetDate(), 
	@StampUser
FROM 
	TInsuredItem
WHERE 
	InsuredItemId = @InsuredItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
