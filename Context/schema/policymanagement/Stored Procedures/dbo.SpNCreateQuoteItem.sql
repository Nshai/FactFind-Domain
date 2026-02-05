SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateQuoteItem]
	@StampUser varchar (255),
	@QuoteId bigint, 
	@PortalQuoteRef varchar(255)  = NULL, 
	@KeyXML varchar(5000)  = NULL, 
	@ExpiryDate datetime = NULL, 
	@CommissionAmount money = NULL, 
	@CommissionNote varchar(1000)  = NULL, 
	@ProductDescription varchar(255)  = NULL, 
	@IsMarked bit = 0, 
	@CanApply bit = 0, 
	@ProductRef varchar(255)  = NULL, 
	@ProviderCodeName varchar(50)  = NULL, 
	@WarningMessage varchar(1000)  = NULL, 
	@QuoteDetailId bigint = NULL	
AS


DECLARE @QuoteItemId bigint, @Result int
			
	
INSERT INTO TQuoteItem
(QuoteId, PortalQuoteRef, KeyXML, ExpiryDate, CommissionAmount, CommissionNote, 
	ProductDescription, IsMarked, CanApply, ProductRef, ProviderCodeName, WarningMessage, 
	QuoteDetailId, ConcurrencyId)
VALUES(@QuoteId, @PortalQuoteRef, @KeyXML, @ExpiryDate, @CommissionAmount, @CommissionNote, 
	@ProductDescription, @IsMarked, @CanApply, @ProductRef, @ProviderCodeName, @WarningMessage, 
	@QuoteDetailId, 1)

SELECT @QuoteItemId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditQuoteItem @StampUser, @QuoteItemId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveQuoteItemByQuoteItemId @QuoteItemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
