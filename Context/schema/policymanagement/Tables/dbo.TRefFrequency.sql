CREATE TABLE [dbo].[TRefFrequency]
(
[RefFrequencyId] [int] NOT NULL IDENTITY(1, 1),
[FrequencyName] [varchar] (50)  NULL,
[OrigoRef] [varchar] (50)  NULL,
[RetireFg] [tinyint] NULL,
[OrderNo] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFrequency_ConcurrencyId] DEFAULT ((1)),
[MultiplierForAnnualisedAmount] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TRefFrequency] ADD CONSTRAINT [PK_TRefFrequency] PRIMARY KEY CLUSTERED  ([RefFrequencyId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefFrequency_RefFrequencyId_FrequencyName_OrigoRef_RetireFg_OrderNo_ConcurrencyId] ON [dbo].[TRefFrequency] ([RefFrequencyId], [FrequencyName], [OrigoRef], [RetireFg], [OrderNo], [ConcurrencyId])
GO
