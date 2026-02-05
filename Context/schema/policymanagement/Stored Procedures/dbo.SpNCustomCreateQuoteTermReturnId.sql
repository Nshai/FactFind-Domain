SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateQuoteTermReturnId]
	@StampUser varchar (255),
	@QuoteItemId bigint, 
	@PremiumAmount money = NULL, 
	@PremiumType varchar(255)  = NULL, 
	@PremiumIsNet bit = 0,
	@PremiumFrequency varchar(50) = NULL, 
	@CoverAmount money,
	@TerminalIllness bit = Null
AS


DECLARE @QuoteTermId bigint, @Result int
			
	
INSERT INTO TQuoteTerm
(QuoteItemId,  PremiumAmount, PremiumType, PremiumIsNet, 
	PremiumFrequency,CoverAmount, TerminalIllness, ConcurrencyId)
VALUES(@QuoteItemId, @PremiumAmount, @PremiumType, @PremiumIsNet, 
	@PremiumFrequency,@CoverAmount, @TerminalIllness, 1)

SELECT @QuoteTermId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh

Execute @Result = dbo.SpNAuditQuoteTerm @StampUser, @QuoteTermId, 'C'

IF @Result  != 0 GOTO errh

SELECT @QuoteTermId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
