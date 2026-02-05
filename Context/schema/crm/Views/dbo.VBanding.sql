SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VBanding

AS

SELECT
	SB.SplitBasicId,
	SB.IndClientId,
	SB.PractitionerId,
	SB.PractitionerCRMContactId,
	SB.BandingTemplateId,
	SB.GroupingId,
	SB.GroupCRMContactId,
	SB.SplitPercent,
	SB.PaymentEntityId,
	SB.PractitionerFg,
	SB.Extensible,
	SB.ConcurrencyId,
	G.GroupId
FROM
	dbo.TSplitBasic SB
	LEFT JOIN Administration..TGroup G ON G.CRMContactId = SB.GroupCRMContactId
GO
