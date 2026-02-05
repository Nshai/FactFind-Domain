CREATE TABLE [dbo].[TRefFeeRetainerFrequency]
(
[RefFeeRetainerFrequencyId] [int] NOT NULL IDENTITY(1, 1),
[PeriodName] [varchar] (50)  NULL,
[NumMonths] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefPeriod_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFeeRetainerFrequency] ADD CONSTRAINT [PK_TRefPeriod] PRIMARY KEY CLUSTERED  ([RefFeeRetainerFrequencyId])
GO
