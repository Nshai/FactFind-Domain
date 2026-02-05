SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTextMarketer]
	@StampUser varchar (255),
	@TextMarketerId bigint,
	@StampAction char(1)
AS

INSERT INTO TTextMarketerAudit 
	(
	UserName,
	[Password],
	MessageFrom,
	ApplicationLinkId,
	ConcurrencyId,
	TextMarketerId,
	StampAction,
	StampDate,
	StampUser
	)
	
	SELECT
		UserName,
		[Password],
		MessageFrom,
		ApplicationLinkId,
		ConcurrencyId,
		TextMarketerId,
		@StampAction, 
		GetDate(), 
		@StampUser
		
		FROM
		
		TTextMarketer
		WHERE TextMarketerId = @TextMarketerId		
		
IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
