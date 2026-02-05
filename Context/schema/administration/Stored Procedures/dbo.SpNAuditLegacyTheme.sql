SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditLegacyTheme]
	@StampUser varchar (255),
	@LegacyThemeId bigint,
	@StampAction char(1)
AS

INSERT INTO TLegacyThemeAudit 
(IndigoClientId, DefaultFont, DefaultSize, AlternateFont, AlternateSize, Colour1, 
	Colour2, Colour3, Colour4, Colour5, Colour6,
	LegacyThemeId, StampAction, StampDateTime, StampUser)
SELECT  IndigoClientId, DefaultFont, DefaultSize, AlternateFont, AlternateSize, Colour1, 
	Colour2, Colour3, Colour4, Colour5, Colour6,
	LegacyThemeId, @StampAction, GetDate(), @StampUser
FROM TLegacyTheme
WHERE LegacyThemeId = @LegacyThemeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
