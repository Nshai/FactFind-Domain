SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPdfSettings]
	@StampUser varchar (255),
	@PdfSettingsId bigint,
	@StampAction char(1)
AS
INSERT INTO TPdfSettingsAudit (
	StampAction, StampDateTime, StampUser, 
	PdfSettingsId, ConcurrencyId, TenantId, Title, SubTitle, TitleColour, SubTitleColour, 
	ClientOneColour, ClientTwoColour, TableHeadingColour, TableSubHeadingColour, ShowRefDataOptions,
	[SectionHeadingBackgroundColour], [LogoAlign], [Acknowledgments])
SELECT 
	@StampAction, GETDATE(), @StampUser, 
	PdfSettingsId, ConcurrencyId, TenantId, Title, SubTitle, TitleColour, SubTitleColour, 
	ClientOneColour, ClientTwoColour, TableHeadingColour, TableSubHeadingColour, ShowRefDataOptions,
	[SectionHeadingBackgroundColour], [LogoAlign], [Acknowledgments]
FROM 
	TPdfSettings
WHERE 
	PdfSettingsId = @PdfSettingsId
GO
