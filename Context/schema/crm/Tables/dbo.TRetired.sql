CREATE TABLE [dbo].[TRetired]
(
[RetiredId] [int] NOT NULL IDENTITY(1, 1),
[OccupationId] [int] NOT NULL,
[PensionIncome] [money] NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetired_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetired] ADD CONSTRAINT [PK_TRetired_2__57] PRIMARY KEY NONCLUSTERED  ([RetiredId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetired_OccupationId] ON [dbo].[TRetired] ([OccupationId]) WITH (FILLFACTOR=80)
GO
