SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgageQuote]
	@StampUser varchar (255),
	@MortgageQuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageQuoteAudit 
( CRMContactId, CRMContactId2, OpportunityId, SessionGuid, 
		CRMRef, UserRef, PXIData, ResponseData, 
		AssetDetails, SessionStart, SessionEnd, ObjectiveId, 
		ApplicationLinkId, ConcurrencyId, 
	MortgageQuoteId, StampAction, StampDateTime, StampUser,PropertyDetailId,QuoteId,AdditionalMteData) 
Select CRMContactId, CRMContactId2, OpportunityId, SessionGuid, 
		CRMRef, UserRef, PXIData, ResponseData, 
		AssetDetails, SessionStart, SessionEnd, ObjectiveId, 
		ApplicationLinkId, ConcurrencyId, 
	MortgageQuoteId, @StampAction, GetDate(), @StampUser,
	PropertyDetailId,QuoteId,AdditionalMteData
FROM TMortgageQuote
WHERE MortgageQuoteId = @MortgageQuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
