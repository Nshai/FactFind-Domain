CREATE TABLE [dbo].[TAction]
(
[ActionId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Javascript] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [tinyint] NOT NULL,
[FactFindTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAction_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAction] ADD CONSTRAINT [PK_TAction] PRIMARY KEY NONCLUSTERED  ([ActionId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TAction] WITH NOCHECK ADD CONSTRAINT [FK_TAction_FactFindTypeId_FactFindTypeId] FOREIGN KEY ([FactFindTypeId]) REFERENCES [dbo].[TFactFindType] ([FactFindTypeId])
GO
