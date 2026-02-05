CREATE TABLE [dbo].[TFeeRetainerOwner]
(
[FeeRetainerOwnerId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[CRMContactId] [int] NULL,
[TnCCoachId] [int] NULL,
[PractitionerId] [int] NULL,
[BandingTemplateId] [int] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFeeRetainerOwner_ConcurrencyId] DEFAULT ((1)),
[SecondaryOwnerId] [int] NULL
)
GO
ALTER TABLE [dbo].[TFeeRetainerOwner] ADD CONSTRAINT [PK_TFeeRetainerOwner_FeeRetainerOwnerId] PRIMARY KEY CLUSTERED  ([FeeRetainerOwnerId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeRetainerOwner_CRMContactId] ON [dbo].[TFeeRetainerOwner] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeRetainerOwner_FeeId] ON [dbo].[TFeeRetainerOwner] ([FeeId],[PractitionerId]) include (CRMContactId)
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeRetainerOwner_PractitionerId] ON [dbo].[TFeeRetainerOwner] ([PractitionerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeRetainerOwner_RetainerId] ON [dbo].[TFeeRetainerOwner] ([RetainerId])
GO
ALTER TABLE [dbo].[TFeeRetainerOwner] ADD CONSTRAINT [FK_TFeeRetainerOwner_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
ALTER TABLE [dbo].[TFeeRetainerOwner] ADD CONSTRAINT [FK_TFeeRetainerOwner_RetainerId_RetainerId] FOREIGN KEY ([RetainerId]) REFERENCES [dbo].[TRetainer] ([RetainerId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeRetainerOwner_SecondaryOwnerID] ON [dbo].[TFeeRetainerOwner] ([SecondaryOwnerId]) INCLUDE ([FeeId],[PractitionerId],FeeRetainerOwnerId)
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeRetainerOwner_BandingTemplateId_IndigoClientId] ON [dbo].[TFeeRetainerOwner] ([BandingTemplateId],[IndigoClientId]) INCLUDE ([FeeId],[CRMContactId],[PractitionerId],[SecondaryOwnerId])
GO