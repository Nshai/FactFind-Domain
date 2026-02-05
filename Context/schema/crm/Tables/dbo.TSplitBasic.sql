CREATE TABLE [dbo].[TSplitBasic]
(
[SplitBasicId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractitionerId] [int] NULL,
[PractitionerCRMContactId] [int] NULL,
[BandingTemplateId] [int] NULL,
[GroupingId] [int] NULL,
[GroupCRMContactId] [int] NULL,
[SplitPercent] [decimal] (10, 2) NOT NULL,
[PaymentEntityId] [int] NOT NULL,
[PractitionerFg] [bit] NOT NULL CONSTRAINT [DF_TSplitBasic_PractitionerFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSplitBasic_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSplitBasic] ADD CONSTRAINT [PK_TSplitBasic] PRIMARY KEY NONCLUSTERED  ([SplitBasicId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSplitBasic_BandingTemplateId] ON [dbo].[TSplitBasic] ([BandingTemplateId]) INCLUDE ([GroupCRMContactId], [GroupingId], [PaymentEntityId], [PractitionerFg], [SplitPercent])
GO
CREATE NONCLUSTERED INDEX [IDX_TSplitBasic_GroupCRMContactId] ON [dbo].[TSplitBasic] ([GroupCRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSplitBasic_PractitionerCRMContactId] ON [dbo].[TSplitBasic] ([PractitionerCRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSplitBasic_PractitionerId] ON [dbo].[TSplitBasic] ([PractitionerId])
GO
ALTER TABLE [dbo].[TSplitBasic] WITH CHECK ADD CONSTRAINT [FK_TSplitBasic_GroupCRMContactId_CRMContactId] FOREIGN KEY ([GroupCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TSplitBasic] WITH CHECK ADD CONSTRAINT [FK_TSplitBasic_PractitionerCRMContactId_CRMContactId] FOREIGN KEY ([PractitionerCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TSplitBasic] WITH CHECK ADD CONSTRAINT [FK_TSplitBasic_PractitionerId_PractitionerId] FOREIGN KEY ([PractitionerId]) REFERENCES [dbo].[TPractitioner] ([PractitionerId])
GO
