SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefOpportunityType2ProdSubType]
	@StampUser varchar (255),
	@RefOpportunityType2ProdSubTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefOpportunityType2ProdSubTypeAudit 
		    ( 
				ProdSubTypeId,
				OpportunityTypeId, 
				ConcurrencyId, 
				IsArchived, 
				RefOpportunityType2ProdSubTypeId, 
				StampAction, 
				StampDateTime, 
				StampUser
			) 
SELECT ProdSubTypeId,
	   OpportunityTypeId, 
	   ConcurrencyId, 
	   IsArchived, 
	   RefOpportunityType2ProdSubTypeId, 
	   @StampAction, 
	   GetDate(), 
	   @StampUser
FROM TRefOpportunityType2ProdSubType
WHERE RefOpportunityType2ProdSubTypeId = @RefOpportunityType2ProdSubTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
