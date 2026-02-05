SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMortgageSourcing]
	@StampUser varchar (255),
	@MortgageSourcingId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageSourcingAudit 
( ApplicationLinkId, IsSaveDocuments, DocumentCategoryId, DocumentSubCategoryId, 
		ConcurrencyId, 
	MortgageSourcingId, StampAction, StampDateTime, StampUser) 
Select ApplicationLinkId, IsSaveDocuments, DocumentCategoryId, DocumentSubCategoryId, 
		ConcurrencyId, 
	MortgageSourcingId, @StampAction, GetDate(), @StampUser
FROM TMortgageSourcing
WHERE MortgageSourcingId = @MortgageSourcingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
