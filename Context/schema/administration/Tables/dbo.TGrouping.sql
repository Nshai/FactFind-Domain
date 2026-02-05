CREATE TABLE [dbo].[TGrouping]
(
[GroupingId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64)  NOT NULL,
[ParentId] [int] NULL,
[IsPayable] [bit] NOT NULL CONSTRAINT [DF_TGrouping_IsPayable] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGrouping_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGrouping] ADD CONSTRAINT [PK_TGrouping] PRIMARY KEY NONCLUSTERED  ([GroupingId])
GO
CREATE CLUSTERED INDEX [IDX1_TGrouping_IndigoClientId] ON [dbo].[TGrouping] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGrouping_ParentId] ON [dbo].[TGrouping] ([ParentId])
GO
ALTER TABLE [dbo].[TGrouping] WITH CHECK ADD CONSTRAINT [FK_TGrouping_IndigoClientId_IndigoClientId] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TGrouping] ADD CONSTRAINT [FK_TGrouping_ParentId_GroupingId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[TGrouping] ([GroupingId])
GO
