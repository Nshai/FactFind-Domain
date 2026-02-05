CREATE TABLE [dbo].[TRetainer]
(
[RetainerId] [int] NOT NULL IDENTITY(1, 1),
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[RefFeeRetainerFrequencyId] [int] NULL,
[StartDate] [datetime] NULL,
[ReviewDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[ReceivedFromClientDate] [datetime] NULL,
[SentToBankDate] [datetime] NULL,
[Description] [varchar] (255) NULL,
[IndigoClientId] [int] NOT NULL,
[isVatExempt] [bit] NOT NULL CONSTRAINT [DF_TRetainer_isVatExempt] DEFAULT ((0)),
[RefVATId] [int] NULL,
[SequentialRefLegacy] [varchar] (50) NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOR'+right(replicate('0',(8))+CONVERT([varchar],[RetainerId]),(8)) else [SequentialRefLegacy] end),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRetainer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetainer] ADD CONSTRAINT [PK_TRetainer_RetainerId] PRIMARY KEY CLUSTERED  ([RetainerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRetainer_RefFeeRetainerFrequencyId] ON [dbo].[TRetainer] ([RefFeeRetainerFrequencyId])
GO
CREATE NONCLUSTERED INDEX [IX_TRetainer_IndigoClientId] ON [dbo].[TRetainer] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TRetainer] ADD CONSTRAINT [FK_TRetainer_RefFeeRetainerFrequencyId_RefFeeRetainerFrequencyId] FOREIGN KEY ([RefFeeRetainerFrequencyId]) REFERENCES [dbo].[TRefFeeRetainerFrequency] ([RefFeeRetainerFrequencyId])
GO
