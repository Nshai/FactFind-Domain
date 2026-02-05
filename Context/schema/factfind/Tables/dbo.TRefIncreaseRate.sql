CREATE TABLE [dbo].[TRefIncreaseRate]
(
[RefIncreaseRateId] [int] NOT NULL IDENTITY(1, 1),
[IncreaseRateType] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [smallint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIncreaseRate_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefIncreaseRate] ADD CONSTRAINT [PK_TRefIncreaseRate] PRIMARY KEY NONCLUSTERED  ([RefIncreaseRateId])
GO
